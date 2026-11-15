import 'dart:convert';
import 'package:event_sharing/controllers/auth_controller.dart';
import 'package:event_sharing/services/api_service.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../geo/models/city.dart';
import '../../geo/models/city_state.dart';
import '../../geo/models/country.dart';
import '../../geo/services/geo_data_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  /// Free GeoNames username.
  /// Create one at https://www.geonames.org/login and enable web services.
  static const String _geoNamesUsername = 'demo';

  final MapController _mapController = MapController();
  LatLng? _selectedPosition;
  String _markerTitle = 'Selected location';
  bool _isSearching = false;
  bool _isSavingLocation = false;

  final ApiService _apiService = Get.find<ApiService>();
  final AuthController _authController = Get.find<AuthController>();
  final GeoDataService _geoService = GeoDataService.instance;

  //=========================> Country / State / City dropdown data <=======================
  List<Country> _countries = [];
  List<CityState> _states = [];
  List<City> _cities = [];
  Country? _selectedCountry;
  CityState? _selectedState;
  City? _selectedCity;
  bool _isLoadingCountries = true;
  bool _isLoadingStates = false;
  bool _isLoadingCities = false;

  /// Fallback strings from geocode/reverse-geocode when dropdown match fails.
  String? _geocodedCountry;
  String? _geocodedState;
  String? _geocodedCity;

  final TextEditingController _locationController = TextEditingController();
  static const LatLng _initialCenter = LatLng(23.791275582872142, 90.39232734518325);

  @override
  void initState() {
    super.initState();
    _loadCountries();
    WidgetsBinding.instance.addPostFrameCallback((_) => _seedFromUserProfile());
  }

  Future<void> _seedFromUserProfile() async {
    await _authController.fetchUserProfile();
    final profile = _authController.userProfile.value;
    if (profile == null || !mounted) return;

    final latRaw = profile['latitude'];
    final lngRaw = profile['longitude'];
    final lat = latRaw is num ? latRaw.toDouble() : double.tryParse('$latRaw');
    final lng = lngRaw is num ? lngRaw.toDouble() : double.tryParse('$lngRaw');

    final locationLabel = (profile['location'] ?? '').toString().trim();
    final city = (profile['city'] ?? '').toString().trim();
    final state = (profile['state'] ?? '').toString().trim();
    final country = (profile['country'] ?? '').toString().trim();

    if (locationLabel.isNotEmpty) {
      _locationController.text = locationLabel;
    } else if ([city, state, country].any((e) => e.isNotEmpty)) {
      _locationController.text =
          [city, state, country].where((e) => e.isNotEmpty).join(', ');
    }

    if (lat != null && lng != null) {
      final pos = LatLng(lat, lng);
      setState(() {
        _selectedPosition = pos;
        _markerTitle = _locationController.text.isNotEmpty
            ? _locationController.text
            : 'Your location';
      });
      _mapController.move(pos, 13);
      await _syncDropdownsFromAddress(
        countryName: country.isNotEmpty ? country : null,
        stateName: state.isNotEmpty ? state : null,
        cityName: city.isNotEmpty ? city : null,
      );
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _updateMarker(LatLng position, {String? title}) {
    setState(() {
      _selectedPosition = position;
      _markerTitle = title ?? 'Selected location';
    });
    _mapController.move(position, 14.0);
  }

  String _buildLocationLabel() {
    final parts = [
      _selectedCity?.name,
      _selectedState?.name,
      _selectedCountry?.name,
    ].whereType<String>().where((e) => e.trim().isNotEmpty).toList();

    if (parts.isNotEmpty) return parts.join(', ');

    final typed = _locationController.text.trim();
    return typed;
  }

  //=========================> Load all countries <=======================
  Future<void> _loadCountries() async {
    final countries = await _geoService.getCountries();
    if (!mounted) return;
    setState(() {
      _countries = countries;
      _isLoadingCountries = false;
    });
  }

  //=========================> Load states for a selected country <=======================
  Future<void> _onCountryChanged(Country? country) async {
    setState(() {
      _selectedCountry = country;
      _selectedState = null;
      _selectedCity = null;
      _states = [];
      _cities = [];
      _isLoadingStates = country != null;
      _isLoadingCities = false;
      _geocodedCountry = country?.name;
      _geocodedState = null;
      _geocodedCity = null;
    });

    if (country == null) return;

    final states = await _geoService.getStatesByCountry(country.id);
    if (!mounted) return;
    setState(() {
      _states = states;
      _isLoadingStates = false;
    });

    // Move map to the selected country without rewriting dropdown values.
    _locationController.text = country.name;
    await _confirmLocation(syncDropdowns: false);
  }

  //=========================> On state selected: load cities <=======================
  Future<void> _onStateChanged(CityState? state) async {
    setState(() {
      _selectedState = state;
      _selectedCity = null;
      _cities = [];
      _isLoadingCities = state != null;
      _geocodedState = state?.name;
      _geocodedCity = null;
    });

    if (state == null || _selectedCountry == null) return;

    final cities = await _geoService.getCitiesByState(state.id);
    if (!mounted) return;
    setState(() {
      _cities = cities;
      _isLoadingCities = false;
    });

    _locationController.text = '${state.name}, ${_selectedCountry!.name}';
    await _confirmLocation(syncDropdowns: false);
  }

  //=========================> On city selected: geocode full location <=======================
  Future<void> _onCityChanged(City? city) async {
    setState(() {
      _selectedCity = city;
      _geocodedCity = city?.name;
    });
    if (city == null || _selectedCountry == null) return;

    final parts = [
      city.name,
      if (_selectedState != null) _selectedState!.name,
      _selectedCountry!.name,
    ];
    _locationController.text = parts.join(', ');
    await _confirmLocation(syncDropdowns: false);
  }

  /// Best-effort match of reverse-geocode parts against local geo datasets.
  /// Exact name match only — fuzzy/contains matching was swapping to wrong countries.
  Future<void> _syncDropdownsFromAddress({
    String? countryName,
    String? stateName,
    String? cityName,
  }) async {
    if (countryName == null || countryName.trim().isEmpty) return;

    final needle = countryName.trim().toLowerCase();
    final countries = _countries.isNotEmpty
        ? _countries
        : await _geoService.getCountries();

    Country? countryMatch;
    for (final c in countries) {
      if (c.name.toLowerCase() == needle) {
        countryMatch = c;
        break;
      }
    }
    if (countryMatch == null || !mounted) return;

    final states = await _geoService.getStatesByCountry(countryMatch.id);
    CityState? stateMatch;
    if (stateName != null && stateName.trim().isNotEmpty && states.isNotEmpty) {
      final stateNeedle = stateName.trim().toLowerCase();
      for (final s in states) {
        if (s.name.toLowerCase() == stateNeedle) {
          stateMatch = s;
          break;
        }
      }
    }

    List<City> cities = [];
    City? cityMatch;
    if (stateMatch != null) {
      cities = await _geoService.getCitiesByState(stateMatch.id);
      if (cityName != null && cityName.trim().isNotEmpty && cities.isNotEmpty) {
        final cityNeedle = cityName.trim().toLowerCase();
        for (final c in cities) {
          if (c.name.toLowerCase() == cityNeedle) {
            cityMatch = c;
            break;
          }
        }
      }
    }

    if (!mounted) return;
    setState(() {
      _countries = countries;
      _selectedCountry = countryMatch;
      _states = states;
      _selectedState = stateMatch;
      _cities = cities;
      _selectedCity = cityMatch;
      _isLoadingStates = false;
      _isLoadingCities = false;
    });
  }

  /// Free GeoNames forward geocoding (address -> lat/lng)
  Future<({LatLng position, String name, String? country, String? state, String? city})?>
      _geocodeWithGeoNames(String address) async {
    final uri = Uri.http('api.geonames.org', '/searchJSON', {
      'q': address,
      'maxRows': '1',
      'username': _geoNamesUsername,
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['status'] != null) return null;

    final List<dynamic> places = data['geonames'] as List<dynamic>? ?? [];
    if (places.isEmpty) return null;

    final place = places.first as Map<String, dynamic>;
    final lat = double.tryParse(place['lat']?.toString() ?? '');
    final lng = double.tryParse(place['lng']?.toString() ?? '');
    if (lat == null || lng == null) return null;

    final city = place['name']?.toString();
    final state = place['adminName1']?.toString();
    final country = place['countryName']?.toString();
    final name = [city, state, country]
        .whereType<String>()
        .where((e) => e.trim().isNotEmpty)
        .join(', ');

    return (
      position: LatLng(lat, lng),
      name: name.isNotEmpty ? name : address,
      country: country,
      state: state,
      city: city,
    );
  }

  /// Free OpenStreetMap Nominatim fallback (no API key)
  Future<({LatLng position, String name, String? country, String? state, String? city})?>
      _geocodeWithNominatim(String address) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': address,
      'format': 'json',
      'addressdetails': '1',
      'limit': '1',
    });

    final response = await http.get(
      uri,
      headers: {
        'User-Agent': 'EventSharingApp/1.0 (gehzi.event_sharing)',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode != 200) return null;

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    if (data.isEmpty) return null;

    final place = data.first as Map<String, dynamic>;
    final lat = double.tryParse(place['lat']?.toString() ?? '');
    final lon = double.tryParse(place['lon']?.toString() ?? '');
    if (lat == null || lon == null) return null;

    final addressMap = place['address'] as Map<String, dynamic>? ?? {};
    final city = (addressMap['city'] ??
            addressMap['town'] ??
            addressMap['village'] ??
            addressMap['suburb'])
        ?.toString();
    final state = addressMap['state']?.toString();
    final country = addressMap['country']?.toString();
    final name = place['display_name']?.toString() ?? address;

    return (
      position: LatLng(lat, lon),
      name: name,
      country: country,
      state: state,
      city: city,
    );
  }

  /// Free GeoNames reverse geocoding (lat/lng -> address)
  Future<({String name, String? country, String? state, String? city})?>
      _reverseWithGeoNames(LatLng position) async {
    final uri = Uri.http('api.geonames.org', '/findNearbyPlaceNameJSON', {
      'lat': position.latitude.toString(),
      'lng': position.longitude.toString(),
      'username': _geoNamesUsername,
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['status'] != null) return null;

    final List<dynamic> places = data['geonames'] as List<dynamic>? ?? [];
    if (places.isEmpty) return null;

    final place = places.first as Map<String, dynamic>;
    final city = place['name']?.toString();
    final state = place['adminName1']?.toString();
    final country = place['countryName']?.toString();
    final parts = [city, state, country]
        .whereType<String>()
        .where((e) => e.trim().isNotEmpty)
        .toList();

    if (parts.isEmpty) return null;
    return (
      name: parts.join(', '),
      country: country,
      state: state,
      city: city,
    );
  }

  /// Free Nominatim reverse fallback
  Future<({String name, String? country, String? state, String? city})?>
      _reverseWithNominatim(LatLng position) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'lat': position.latitude.toString(),
      'lon': position.longitude.toString(),
      'format': 'json',
      'addressdetails': '1',
    });

    final response = await http.get(
      uri,
      headers: {
        'User-Agent': 'EventSharingApp/1.0 (gehzi.event_sharing)',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final addressMap = data['address'] as Map<String, dynamic>? ?? {};
    final city = (addressMap['city'] ??
            addressMap['town'] ??
            addressMap['village'] ??
            addressMap['suburb'])
        ?.toString();
    final state = addressMap['state']?.toString();
    final country = addressMap['country']?.toString();
    final name = data['display_name']?.toString();
    if (name == null || name.isEmpty) return null;

    return (name: name, country: country, state: state, city: city);
  }

  Future<void> _confirmLocation({bool syncDropdowns = true}) async {
    final location = _locationController.text.trim();
    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please type a location')),
      );
      return;
    }

    setState(() => _isSearching = true);

    try {
      var result = await _geocodeWithNominatim(location);
      result ??= await _geocodeWithGeoNames(location);

      if (result == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not found')),
        );
        return;
      }

      // Only rewrite the text field / dropdowns for manual search or map tap.
      // Dropdown-driven searches must keep the user's selected country/state/city.
      if (syncDropdowns) {
        _locationController.text = result.name;
        _geocodedCountry = result.country ?? _geocodedCountry;
        _geocodedState = result.state ?? _geocodedState;
        _geocodedCity = result.city ?? _geocodedCity;
      } else {
        _geocodedCountry = _selectedCountry?.name ?? _geocodedCountry;
        _geocodedState = _selectedState?.name ?? _geocodedState;
        _geocodedCity = _selectedCity?.name ?? _geocodedCity;
      }

      _updateMarker(
        result.position,
        title: syncDropdowns ? result.name : location,
      );

      if (syncDropdowns) {
        await _syncDropdownsFromAddress(
          countryName: result.country ?? _selectedCountry?.name,
          stateName: result.state ?? _selectedState?.name,
          cityName: result.city ?? _selectedCity?.name,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location found')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finding location: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _onMapTap(LatLng position) async {
    _updateMarker(position, title: 'Selected location');

    var address = await _reverseWithNominatim(position);
    address ??= await _reverseWithGeoNames(position);

    if (address != null && mounted) {
      _locationController.text = address.name;
      _geocodedCountry = address.country ?? _geocodedCountry;
      _geocodedState = address.state ?? _geocodedState;
      _geocodedCity = address.city ?? _geocodedCity;
      setState(() {
        _markerTitle = address!.name;
      });
      await _syncDropdownsFromAddress(
        countryName: address.country,
        stateName: address.state,
        cityName: address.city,
      );
    }
  }

  /// PATCH /users/update-me with country, state, city, coords, and location label
  Future<void> _onConfirmAndReturn() async {
    if (_selectedPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search or tap a location first')),
      );
      return;
    }

    final country = (_selectedCountry?.name ?? _geocodedCountry ?? '').trim();
    final state = (_selectedState?.name ?? _geocodedState ?? '').trim();
    final city = (_selectedCity?.name ?? _geocodedCity ?? '').trim();

    if (country.isEmpty && _locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or search a location')),
      );
      return;
    }

    final location = _buildLocationLabel().isNotEmpty
        ? _buildLocationLabel()
        : [city, state, country]
            .where((e) => e.trim().isNotEmpty)
            .join(', ');
    final latitude = _selectedPosition!.latitude;
    final longitude = _selectedPosition!.longitude;

    setState(() => _isSavingLocation = true);

    try {
      final response = await _apiService.patch(
        ApiConstants.updateProfile,
        body: {
          'location': location,
          if (country.isNotEmpty) 'country': country,
          if (state.isNotEmpty) 'state': state,
          if (city.isNotEmpty) 'city': city,
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      if (!mounted) return;

      if (response != null && response['success'] == true) {
        // Apply to AuthController so home app bar / profile update immediately.
        final current = Map<String, dynamic>.from(
          _authController.userProfile.value ?? {},
        );
        if (response['data'] is Map) {
          current.addAll(Map<String, dynamic>.from(response['data']));
        }
        // Always keep the location the user just confirmed (API may omit fields).
        current['location'] = location;
        if (country.isNotEmpty) current['country'] = country;
        if (state.isNotEmpty) current['state'] = state;
        if (city.isNotEmpty) current['city'] = city;
        current['latitude'] = latitude;
        current['longitude'] = longitude;
        _authController.userProfile.value = Map<String, dynamic>.from(current);
        await _apiService.saveUserData(current);

        // Refresh profile but preserve location fields if API response is incomplete.
        await _authController.fetchUserProfile();
        final refreshed = Map<String, dynamic>.from(
          _authController.userProfile.value ?? {},
        );
        refreshed['location'] = location;
        if (country.isNotEmpty) refreshed['country'] = country;
        if (state.isNotEmpty) refreshed['state'] = state;
        if (city.isNotEmpty) refreshed['city'] = city;
        refreshed['latitude'] = latitude;
        refreshed['longitude'] = longitude;
        _authController.userProfile.value = refreshed;
        await _apiService.saveUserData(refreshed);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location updated successfully')),
        );
        Get.back(result: {
          'address': location,
          'location': location,
          'latitude': latitude,
          'longitude': longitude,
          'country': country,
          'state': state,
          'city': city,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response?['message']?.toString() ?? 'Failed to update location',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating location: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSavingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 14.4746,
              onTap: (tapPosition, point) => _onMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.gehzi.event_sharing',
              ),
              if (_selectedPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPosition!,
                      width: 48,
                      height: 48,
                      alignment: Alignment.topCenter,
                      child: Tooltip(
                        message: _markerTitle,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 12.w,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new,
                    size: 16.w, color: Colors.black),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.h),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.65,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: 'Select your location',
                      fontsize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 16.h),

                    //=========================> Country dropdown <=======================
                    _isLoadingCountries
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: LinearProgressIndicator(),
                          )
                        : DropdownButtonFormField<Country>(
                            key: ValueKey('country-${_selectedCountry?.id}'),
                            initialValue: _selectedCountry,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Country',
                              border: OutlineInputBorder(),
                            ),
                            items: _countries
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c.name),
                                  ),
                                )
                                .toList(),
                            onChanged: _onCountryChanged,
                          ),
                    SizedBox(height: 12.h),

                    //=========================> State dropdown <=======================
                    if (_selectedCountry != null)
                      _isLoadingStates
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: LinearProgressIndicator(),
                            )
                          : _states.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: CustomText(
                                    text:
                                        'No states available for this country in the dataset.',
                                    fontsize: 11.sp,
                                    color: Colors.grey,
                                  ),
                                )
                              : DropdownButtonFormField<CityState>(
                                  key: ValueKey(
                                      'state-${_selectedCountry?.id}-${_selectedState?.id}'),
                                  initialValue: _selectedState,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'State / Province',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _states
                                      .map(
                                        (s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(s.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: _onStateChanged,
                                ),
                    SizedBox(height: 12.h),

                    //=========================> City dropdown <=======================
                    if (_selectedState != null)
                      _isLoadingCities
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: LinearProgressIndicator(),
                            )
                          : _cities.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: CustomText(
                                    text:
                                        'No cities available for this state in the dataset.',
                                    fontsize: 11.sp,
                                    color: Colors.grey,
                                  ),
                                )
                              : DropdownButtonFormField<City>(
                                  key: ValueKey(
                                      'city-${_selectedState?.id}-${_selectedCity?.id}'),
                                  initialValue: _selectedCity,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: 'City',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _cities
                                      .map(
                                        (c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(c.name),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: _onCityChanged,
                                ),
                    SizedBox(height: 16.h),

                    CustomTextField(
                      controller: _locationController,
                      hintText: 'Type your location',
                      prifixicon: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        child: SvgPicture.asset(
                          AppIcons.locationIcon,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      sufixicons: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        child: _isSearching
                            ? SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: const CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : GestureDetector(
                                onTap: _confirmLocation,
                                child: const Icon(Icons.search),
                              ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomButton(
                      onTap: _isSearching ? () {} : _confirmLocation,
                      textColor: Colors.white,
                      text: _isSearching ? 'Searching...' : 'Search Location',
                      color: AppColors.buttonColor,
                    ),
                    SizedBox(height: 10.h),
                    CustomButton(
                      onTap: _isSavingLocation ? () {} : _onConfirmAndReturn,
                      textColor: Colors.white,
                      text:
                          _isSavingLocation ? 'Saving...' : 'Confirm Location',
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

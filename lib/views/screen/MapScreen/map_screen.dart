import 'dart:convert';
import 'package:event_sharing/services/api_service.dart';
import 'package:event_sharing/utils/api_constants.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

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

  GoogleMapController? mapController;
  Marker? _selectedLocationMarker;
  LatLng? _selectedPosition;
  bool _isSearching = false;
  bool _isSavingLocation = false;

  final ApiService _apiService = Get.find<ApiService>();
  final GeoDataService _geoService = GeoDataService.instance;

  //=========================> Country / State dropdown data <=======================
  List<Country> _countries = [];
  List<CityState> _states = [];
  Country? _selectedCountry;
  CityState? _selectedState;
  bool _isLoadingCountries = true;
  bool _isLoadingStates = false;

  final TextEditingController _locationController = TextEditingController();
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(23.791275582872142, 90.39232734518325),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  @override
  void dispose() {
    _locationController.dispose();
    mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _updateMarker(LatLng position, {String? title}) {
    setState(() {
      _selectedPosition = position;
      _selectedLocationMarker = Marker(
        markerId: const MarkerId('selected-location'),
        position: position,
        infoWindow: InfoWindow(title: title ?? 'Selected location'),
      );
    });
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 14.0));
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
    if (country == null) return;

    setState(() {
      _selectedCountry = country;
      _selectedState = null;
      _states = [];
      _isLoadingStates = true;
    });

    final states = await _geoService.getStatesByCountry(country.id);

    if (!mounted) return;
    setState(() {
      _states = states;
      _isLoadingStates = false;
    });

    // No states in the dataset for this country (e.g. most countries
    // outside the US/Canada) — still fall back to geocoding the country
    // name itself so search still works.
    if (states.isEmpty) {
      _locationController.text = country.name;
      _confirmLocation();
    }
  }

  //=========================> On state selected: build location string + geocode <=======================
  void _onStateChanged(CityState? state) {
    setState(() => _selectedState = state);
    if (state == null || _selectedCountry == null) return;

    _locationController.text = '${state.name}, ${_selectedCountry!.name}';
    _confirmLocation();
  }

  /// Free GeoNames forward geocoding (address -> lat/lng)
  Future<({LatLng position, String name})?> _geocodeWithGeoNames(
      String address) async {
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

    final name = [
      place['name']?.toString(),
      place['adminName1']?.toString(),
      place['countryName']?.toString(),
    ].whereType<String>().where((e) => e.trim().isNotEmpty).join(', ');

    return (position: LatLng(lat, lng), name: name.isNotEmpty ? name : address);
  }

  /// Free OpenStreetMap Nominatim fallback (no API key)
  Future<({LatLng position, String name})?> _geocodeWithNominatim(
      String address) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': address,
      'format': 'json',
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

    final name = place['display_name']?.toString() ?? address;
    return (position: LatLng(lat, lon), name: name);
  }

  /// Free GeoNames reverse geocoding (lat/lng -> address)
  Future<String?> _reverseWithGeoNames(LatLng position) async {
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
    final parts = [
      place['name']?.toString(),
      place['adminName1']?.toString(),
      place['countryName']?.toString(),
    ].whereType<String>().where((e) => e.trim().isNotEmpty).toList();

    return parts.isEmpty ? null : parts.join(', ');
  }

  /// Free Nominatim reverse fallback
  Future<String?> _reverseWithNominatim(LatLng position) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'lat': position.latitude.toString(),
      'lon': position.longitude.toString(),
      'format': 'json',
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
    return data['display_name']?.toString();
  }

  Future<void> _confirmLocation() async {
    final location = _locationController.text.trim();
    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please type a location')),
      );
      return;
    }

    setState(() => _isSearching = true);

    try {
      var result = await _geocodeWithGeoNames(location);
      result ??= await _geocodeWithNominatim(location);

      if (result == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not found')),
        );
        return;
      }

      _locationController.text = result.name;
      _updateMarker(result.position, title: result.name);

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

    String? address = await _reverseWithGeoNames(position);
    address ??= await _reverseWithNominatim(position);

    if (address != null && mounted) {
      _locationController.text = address;
      setState(() {
        _selectedLocationMarker = Marker(
          markerId: const MarkerId('selected-location'),
          position: position,
          infoWindow: InfoWindow(title: address),
        );
      });
    }
  }

  /// PATCH /users/update-me with the selected location as form data
  Future<void> _onConfirmAndReturn() async {
    if (_selectedPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search or tap a location first')),
      );
      return;
    }

    final address = _locationController.text.trim();
    final latitude = _selectedPosition!.latitude;
    final longitude = _selectedPosition!.longitude;

    setState(() => _isSavingLocation = true);

    try {
      final response = await _apiService.multipartRequest(
        ApiConstants.updateProfile,
        method: 'PATCH',
        fields: {
          'location': address,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          if (_selectedCountry != null) 'country': _selectedCountry!.name,
          if (_selectedState != null) 'state': _selectedState!.name,
        },
      );

      if (!mounted) return;

      if (response != null && response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location updated successfully')),
        );
        Get.back(result: {
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
          'country': _selectedCountry?.name,
          'state': _selectedState?.name,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                response?['message']?.toString() ?? 'Failed to update location'),
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
          GoogleMap(
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: _onMapCreated,
            onTap: _onMapTap,
            markers: _selectedLocationMarker != null
                ? {_selectedLocationMarker!}
                : {},
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
                      initialValue: _selectedCountry,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                      items: _countries
                          .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.name),
                      ))
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
                        initialValue: _selectedState,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'State / Province',
                          border: OutlineInputBorder(),
                        ),
                        items: _states
                            .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.name),
                        ))
                            .toList(),
                        onChanged: _onStateChanged,
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
                      text: _isSavingLocation ? 'Saving...' : 'Confirm Location',
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
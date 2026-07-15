import 'dart:async';
import 'dart:convert';

import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../base/custom_text.dart';

/// A single place suggestion returned by Nominatim
class _PlaceSuggestion {
  final String displayName;
  final double lat;
  final double lon;

  _PlaceSuggestion({
    required this.displayName,
    required this.lat,
    required this.lon,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Marker? _selectedMarker;

  final TextEditingController _locationController = TextEditingController();

  // Type-ahead state
  List<_PlaceSuggestion> _suggestions = [];
  bool _isSearching = false;
  Timer? _debounce;
  bool _showSuggestions = false;

  // Currently confirmed location text (returned via Get.back)
  String _confirmedLocation = '';

  final CameraPosition _initialCamera = const CameraPosition(
    target: LatLng(23.7915, 90.3922), // Dhaka default
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _locationController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _locationController.removeListener(_onSearchChanged);
    _locationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ── Nominatim free geocoding search ──────────────────────────────────────
  void _onSearchChanged() {
    final query = _locationController.text.trim();

    if (query.length < 2) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchNominatim(query);
    });
  }

  Future<void> _searchNominatim(String query) async {
    setState(() => _isSearching = true);

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}'
        '&format=json'
        '&addressdetails=1'
        '&limit=10',
      );

      final response = await http.get(
        uri,
        headers: {
          // Nominatim requires a User-Agent
          'User-Agent': 'EventSharingApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final suggestions = data
            .map((item) => _PlaceSuggestion(
                  displayName: item['display_name'] as String,
                  lat: double.parse(item['lat'] as String),
                  lon: double.parse(item['lon'] as String),
                ))
            .toList();

        if (mounted) {
          setState(() {
            _suggestions = suggestions;
            _showSuggestions = suggestions.isNotEmpty;
          });
        }
      }
    } catch (e) {
      debugPrint('Nominatim search error: $e');
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  // ── Select a suggestion ───────────────────────────────────────────────────
  void _selectSuggestion(_PlaceSuggestion suggestion) {
    final position = LatLng(suggestion.lat, suggestion.lon);

    // Use only the first meaningful part of the display name as label
    final shortName = suggestion.displayName.split(',').first.trim();

    setState(() {
      _locationController.text = suggestion.displayName;
      _locationController.selection = TextSelection.fromPosition(
        TextPosition(offset: _locationController.text.length),
      );
      _suggestions = [];
      _showSuggestions = false;
      _confirmedLocation = suggestion.displayName;

      _selectedMarker = Marker(
        markerId: const MarkerId('selected-location'),
        position: position,
        infoWindow: InfoWindow(title: shortName),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(position, 13.0),
    );
  }

  // ── Confirm and return ────────────────────────────────────────────────────
  void _confirmLocation() {
    if (_selectedMarker == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please search and select a location first.')),
      );
      return;
    }
    // Return selected location string to caller
    Navigator.of(context).pop(_confirmedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Google Map ──────────────────────────────────────────
          GoogleMap(
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _initialCamera,
            onMapCreated: (controller) => _mapController = controller,
            markers:
                _selectedMarker != null ? {_selectedMarker!} : {},
            onTap: (latLng) {
              // Dismiss suggestions on map tap
              setState(() => _showSuggestions = false);
            },
          ),

          // ── Bottom sheet ────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: 'Select your location',
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 12.h),

                  // ── Search field ──────────────────────────────
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Type a city, state or country…',
                      hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.greyColor),
                      filled: true,
                      fillColor: AppColors.fillColor,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 14.h),
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        child: SvgPicture.asset(
                          AppIcons.locationIcon,
                          colorFilter: ColorFilter.mode(
                              AppColors.primaryColor,
                              BlendMode.srcIn),
                          width: 20.w,
                        ),
                      ),
                      suffixIcon: _isSearching
                          ? Padding(
                              padding: EdgeInsets.all(12.w),
                              child: SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child:
                                    const CircularProgressIndicator(
                                        strokeWidth: 2),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.search),
                              color: AppColors.primaryColor,
                              onPressed: () {
                                final q =
                                    _locationController.text.trim();
                                if (q.isNotEmpty) {
                                  _searchNominatim(q);
                                }
                              },
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                            color: AppColors.primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                            color: AppColors.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                            color: AppColors.primaryColor, width: 2),
                      ),
                    ),
                  ),

                  // ── Suggestions list ──────────────────────────
                  if (_showSuggestions && _suggestions.isNotEmpty)
                    Container(
                      constraints: BoxConstraints(maxHeight: 200.h),
                      margin: EdgeInsets.only(top: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: AppColors.colorC8D7DE),
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4)
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _suggestions.length,
                        separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: AppColors.colorC8D7DE),
                        itemBuilder: (context, index) {
                          final s = _suggestions[index];
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primaryColor,
                              size: 18.w,
                            ),
                            title: Text(
                              s.displayName,
                              style: TextStyle(fontSize: 12.sp),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => _selectSuggestion(s),
                          );
                        },
                      ),
                    ),

                  SizedBox(height: 12.h),

                  // ── Confirm button ────────────────────────────
                  CustomButton(
                    onTap: _confirmLocation,
                    textColor: Colors.white,
                    text: 'Confirm Location',
                    color: AppColors.buttonColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

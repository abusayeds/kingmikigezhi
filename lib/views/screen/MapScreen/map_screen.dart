import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:event_sharing/views/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../base/custom_text.dart';
import 'package:geocoding/geocoding.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Marker? _selectedLocationMarker;
  final LatLng _center = const LatLng(23.8103, 90.4125);
  final TextEditingController _locationController = TextEditingController();
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(23.791275582872142, 90.39232734518325),
    zoom: 14.4746,
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _confirmLocation() async {
    String location = _locationController.text;
    try {
      List<Location> locations = await Geocoding().locationFromAddress(location);
      if (locations.isEmpty) {
        final LatLng position =
            LatLng(locations.first.latitude, locations.first.longitude);

        setState(() {
          _selectedLocationMarker = Marker(
            markerId: const MarkerId('selected-location'),
            position: position,
            infoWindow: InfoWindow(title: location),
          );
        });

        mapController
            ?.animateCamera(CameraUpdate.newLatLngZoom(position, 14.0));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location not found")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error finding location: $e")));
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
            initialCameraPosition: _kGooglePlex,
            onMapCreated: _onMapCreated,
            markers: _selectedLocationMarker != null
                ? {_selectedLocationMarker!}
                : {},
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              //===========================> Select location Text Field <======================
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
                  //===========================> Location Text Field <======================
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
                      child: const Icon(Icons.search),
                    ),
                  ),
                  //===========================> Confirm location Field <======================
                  SizedBox(height: 16.h),
                  CustomButton(
                      onTap: _confirmLocation,
                      textColor: Colors.white,
                      text: 'Confirm Location'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

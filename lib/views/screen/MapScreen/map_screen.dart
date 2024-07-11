import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../base/custom_text.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  LatLng _initialPosition =
      LatLng(19.432608, -99.133209); // Default to Mexico City
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Select Your Lcation',
          fontsize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
            myLocationEnabled: true,
          ),
          Positioned(
            top: 20.h,
            right: 15.w,
            left: 15.w,
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a place',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: const EdgeInsets.all(10.0),
                ),
              ),
              suggestionsCallback: (pattern) async {
                // Here, you can use a service to get place suggestions
                return []; // Return a list of suggestions
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  leading: SvgPicture.asset(AppIcons.locationIcon),
                  title: CustomText(text: suggestion.toString()),
                );
              },
              onSuggestionSelected: (suggestion) {
                // Handle the selected suggestion
                // Update the map location based on the suggestion
              },
            ),
          ),
          //==========================> Confirm location Button <==========================
          Positioned(
              bottom: 20.h,
              left: 15.w,
              right: 15.w,
              child: CustomButton(
                onTap: () {},
                text: 'Confirm location',
                textColor: Colors.white,
              )),
        ],
      ),
    );
  }
}

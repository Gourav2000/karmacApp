import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class TravelScreen extends StatefulWidget {
  @override
  _TravelScreenState createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  Completer<GoogleMapController> _controller = Completer();
  RxBool isLoading = false.obs;
  RxDouble long = 0.5.obs;
  RxDouble lat = 0.5.obs;

  @override
  void initState() {
    super.initState();
    isLoading.value = true;
    getLocation();
  }

  Future<void> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    setState(() {
      lat.value = _locationData.latitude as double;
      long.value = _locationData.longitude as double;
    });
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value == true
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.lightGreen,
              ),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat.value, long.value),
                zoom: 16,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: {
                Marker(
                  markerId: MarkerId('m1'),
                  position: LatLng(lat.value, long.value),
                  infoWindow: InfoWindow(title: 'your current position'),
                ),
              },
            ),
    );
  }
}

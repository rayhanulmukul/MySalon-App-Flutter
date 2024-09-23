import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
class MyLocation extends StatefulWidget {
  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  Position? _currentPosition;
  String _locationMessage = "";

  @override
  // void initState() {
  //   super.initState();
  //   _getLocation();
  // }

  Future<void> _getLocation() async {
    // for web
    // void requestGeolocationPermission() {
    //   js.context.callMethod('requestGeolocationPermission');
    // }
    // Check if permission is granted for android
    PermissionStatus status = await Permission.location.status;
    if (status.isGranted) {
      // You have location permission
    } else {
      // Request location permission
      status = await Permission.location.request();

      if (status.isGranted) {
        // Permission granted
      } else {
        // Handle the scenario where the user denies location permission
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentPosition = position;
        _locationMessage = "Place Name: ${place.name}, ${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
      setState(() {
        _locationMessage = "Error getting location data.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location and Place Name'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null)
              Text(
                "Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            if (_currentPosition != null)
              Text(
                _locationMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text("Get Location"),
            ),
          ],
        ),
      ),
    );
  }
}



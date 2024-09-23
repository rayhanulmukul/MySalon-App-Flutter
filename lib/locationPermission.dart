import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService{
  Future<Position> getLocation() async  {
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

    try{
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
  }catch (e){
      print("Error getting locaton: $e");
      // edited timestamp: null to DateTime(2022)
      return Position(longitude: 0, latitude: 0, timestamp: DateTime(2022), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
  }
}
  
}
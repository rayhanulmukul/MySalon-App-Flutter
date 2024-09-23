import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

Future<List<DocumentSnapshot>> getNearestShops(Position userLocation) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<DocumentSnapshot> nearestShops = [];

  try {
    final shops = await _firestore.collection('locationDetails').get();
    final shopsList = shops.docs;

    shopsList.sort((a, b) {
      double distanceA = _calculateDistance(a['latitude'], a['longitude'], userLocation.latitude, userLocation.longitude);
      double distanceB = _calculateDistance(b['latitude'], b['longitude'], userLocation.latitude, userLocation.longitude);
      return distanceA.compareTo(distanceB);
    });

    nearestShops.addAll(shopsList.take(30)); // Get the nearest 30 shops

  } catch (e) {
    print('Error fetching nearest shops: $e');
  }
  return nearestShops;
}

double _calculateDistance(double lat1, double long1, double lat2, double long2) {
  // Use the Haversine formula or geolocator to calculate distance
  return Geolocator.distanceBetween(lat1, long1, lat2, long2);
}

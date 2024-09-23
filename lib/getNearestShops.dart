import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

Future<List<DocumentSnapshot>> getNearestShops(Position userLocation) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<DocumentSnapshot> nearestShops = [];

  try {
    final shops = await _firestore.collection('locationDetails').get();
    final shopsList = shops.docs;

    nearestShops.addAll(shopsList.take(30)); // Get the nearest 30 shops

  } catch (e) {
    print('Error fetching nearest shops: $e');
  }
  return nearestShops;
}
import 'package:barberbook/main.dart';
import 'package:barberbook/serialDetailsList.dart';
import 'package:barberbook/shopInfo4User.dart';
import 'package:barberbook/userSettings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'getNearestShops.dart';
import 'locationPermission.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // for appBar
  String appBar = '';

  final LocationService locationService = LocationService();
  Position? _currentPosition;
  List<DocumentSnapshot>? _nearestShops;
  // DocumentSnapshot<Object?> shopSnapshot = _nearestShops as DocumentSnapshot<Object?>; // Your DocumentSnapshot

  Future<void> _fetchLocation() async {
    final Position position = await locationService.getLocation();
    try {
      setState(() {
        _currentPosition = position;
      });

      // 30 Nearest Shop
      setState(() async {
        _nearestShops = await getNearestShops(_currentPosition as Position);
      });
    } catch (e) {
      print(e);
    }
  }

  double _calculateDistance(
      double lat1, double long1, double lat2, double long2) {
    // Use the Haversine formula or geolocator to calculate distance
    return Geolocator.distanceBetween(lat1, long1, lat2, long2);
  }

  @override
  void initState() {
    super.initState();
     _fetchLocation();
    _fetchFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CircleAvatar(
          backgroundColor: Colors.black45,
          child: Icon(Icons.person),
        ),
        title: Text(appBar),
        centerTitle: false,
        actions: [
          IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserSettings()));
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
   // Available Shops
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 5,top: 5),
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Available Shops",
                style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),
              ),
            ),
   //Shop List Box
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                height: 500,
                width: double.infinity,
                //color: Colors.cyanAccent.shade100,
                decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _nearestShops != null
                    ? ListView.builder(
                        //padding: const EdgeInsets.all(10),
                        itemCount: _nearestShops?.length,
                        itemBuilder: (context, index) {
                          final shop = _nearestShops?[index];
                          return Container(
                            //padding: const EdgeInsets.only(bottom: 5),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Card(
                                elevation: 10,
                                shadowColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: ListTile(
                                  leading: CircleAvatar(
                                      child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  title: Text(
                                    shop![SplashPageState.STORENAME],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Icon(Icons.social_distance),
                                      Text(
                                        //"Latitude: ${shop?['latitude']} | ${shop?.id}| Longitude: ${shop?['longitude']} | Distance: ${_calculateDistance(shop?['latitude'], shop?['longitude'], _currentPosition!.latitude, _currentPosition!.longitude).toStringAsFixed(2)} meters ",
                                        " ${_calculateDistance(shop?['latitude'], shop?['longitude'], _currentPosition!.latitude, _currentPosition!.longitude).toStringAsFixed(0)} m",
                                      ),
                                    ],
                                  ),
                                  trailing: SerialDetail(
                                      documentId: shop.id,
                                      details: 'limit-total'),
                                  onTap: () {
                                    print(shop!.id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShopInfo4User(
                                          documentId: shop!.id,
                                          shopName:
                                              shop![SplashPageState.STORENAME],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      )
                     : FutureBuilder(future: _fetchLocation(),
                    builder: (context, snapsot){
                        return const Center(child: CircularProgressIndicator());
                    },
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchFromLocalStorage() async {
    var sharePref = await SharedPreferences.getInstance();
    var userName = sharePref.getString(SplashPageState.USERNAME);
    setState(() {
      appBar = userName!;
    });
  }

}

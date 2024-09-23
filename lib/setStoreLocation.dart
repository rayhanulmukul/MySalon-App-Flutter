import 'package:barberbook/login.dart';
import 'package:barberbook/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barberbook/locationPermission.dart';

class SetStoreLocation extends StatefulWidget {
  const SetStoreLocation({super.key});

  @override
  State<SetStoreLocation> createState() => _SetStoreLocationState();
}

class _SetStoreLocationState extends State<SetStoreLocation> {
  final LocationService locationService = LocationService();
  final  storeName = TextEditingController();

  Position? _currentPosition;
  String _locationMessage = "";
  Future<void> _fetchLocation() async {
    final Position position = await locationService.getLocation();
    try {

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentPosition = position;
        _locationMessage = "${place.name}, ${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
      setState(() {
        _locationMessage = "Error getting location data.";
      });
    }
    // Use the location data as needed.
  }
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Set Name & Store Location"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1,
              right: 35,
              left: 35),
          child: Column(

            children:[
              TextField(
                controller: storeName,
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Store Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              if(_currentPosition != null)
                Column(
                    children:[
                      SizedBox(height: 50,),
                      Container(
                        decoration: BoxDecoration(color: Colors.cyan,shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsetsDirectional.all(15),
                          child: Text("Your Current Location",
                            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),)),
                      SizedBox(height: 3,),
                      Container(
                          decoration:BoxDecoration(color: Colors.black12,shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsetsDirectional.all(20),
                          child: Text(_locationMessage,
                            style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight:FontWeight.w500 ),)),
                    ]
                ),
              // Text("data"),

              // SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _fetchLocation,
              //   child: Text("Get Location"),
              // ),
              SizedBox(height: 30,),
              ElevatedButton(
                  onPressed: () async {
                    try{
                      final locationDetails = FirebaseFirestore.instance.collection('locationDetails');
                      final users = FirebaseFirestore.instance.collection('users');
                      var user = FirebaseAuth.instance.currentUser;
                      await locationDetails.doc(user!.uid).set({
                        SplashPageState.STORENAME : storeName.text,
                        'latitude' : _currentPosition!.latitude,
                        'longitude' : _currentPosition!.longitude,
                      },SetOptions(merge: true ));
                      await users.doc(user!.uid).set({
                        SplashPageState.STORENAME : storeName.text,
                      },SetOptions(merge: true ));
                      // Successfully notification
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.green,
                            content: Center(
                              child: Text("Save Location Successfully"),
                            )
                        ),
                      );
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> MyLogin()));
                    }catch (error){
                      print("Error ${error.toString()}");
                      // error Notification
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.red,
                            content: Center(
                              child: Text("There found a problem"),
                            )
                        ),
                      );

                    }

                  },
                  child: const Text("Save",style: TextStyle(color: Colors.green, fontSize: 25, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ),
    );
  }
}

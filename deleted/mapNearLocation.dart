// import 'dart:html' ;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class MapNearbyLocation extends StatelessWidget {
   MapNearbyLocation({super.key});

  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Map Location") ,),
      body: SafeArea(
        child: Container(

          child: Center(
            child: TextButton(onPressed: () async {
              GeoFirePoint myLocation = geo.point(latitude: 12.96, longitude: 77.64);
              await _firestore
              .collection('mapLocationDetails')
              .add({
                'name' : 'random name',
                'position' : myLocation.data
              });
            }, child: Text("Add location"),),

          ),
        ),
      )
    );
  }
}

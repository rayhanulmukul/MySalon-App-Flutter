import 'dart:async';

import 'package:barberbook/serialDetailsList.dart';
import 'package:barberbook/serviceProviderSettings.dart';
import 'package:barberbook/switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addSerial.dart';
import 'main.dart';

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({super.key});

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  // for app Bar
  String appBar = '';
  var user = FirebaseAuth.instance.currentUser;
  var collection = FirebaseFirestore.instance.collection('serialList');
  //var total = SerialDetail(documentId: user!.uid, details: 'nothing',);

  @override
  void initState() {
    super.initState();
    _fetchFromLocalStorage();

    //findTotal();
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
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ServiceProviderSettings()));
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Text((add(1, 1)).toString()),
            const SizedBox(
              height: 20,
            ),

            // total limit ans switch
            Container(
                //height: 50,
                //color: Colors.green,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Text("Total : ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                        SerialDetail(documentId: user!.uid, details: 'total'),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Limit : ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        SerialDetail(documentId: user!.uid, details: 'limit'),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    int inputNum = -1;
                                    return AlertDialog(
                                      title: const Text('Set Limit'),
                                      content: TextField(
                                        keyboardType: TextInputType.number,
                                        maxLength: 2,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onChanged: (number) {
                                          inputNum = int.parse(number);
                                        },
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Save'),
                                          onPressed: () {
                                            if (inputNum >= 0) {
                                              collection
                                                  .doc(user!.uid)
                                                  .update({'limit': inputNum});
                                            }
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(Icons.arrow_upward))
                      ],
                    ),
                    //switch button
                    const SwitchScreen(),
                  ],
                )),
             SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.only(left:30, right: 30, bottom: 5,top: 5),
              decoration: BoxDecoration(
                color: Colors.orange.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Serial List",
                style: TextStyle(fontSize:20,fontWeight: FontWeight.bold, ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: user!.uid.isNotEmpty
                    ? SerialDetail(
                        documentId: '${user?.uid}',
                        details: 'nothing',
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 100,
              width: double.infinity,
              // from addSerial.dart
              child: const AddSerial(),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchFromLocalStorage() async {
    var sharePref = await SharedPreferences.getInstance();
    var storeName = sharePref.getString(SplashPageState.STORENAME);
    setState(() {
      appBar = storeName!;
    });
  }

  // String findTotal() {
  //  // var e = user?;
  //   collection.doc(user!.uid).get().then((documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       total = documentSnapshot.data()?['total'];
  //     }
  //   });
  //   return total.toString();
  // }
}

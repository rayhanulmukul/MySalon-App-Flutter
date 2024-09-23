import 'package:barberbook/serialDetailsList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class ShopInfo4User extends StatefulWidget {
  final String documentId;
  final String shopName;
  const ShopInfo4User(
      {super.key, required this.documentId, required this.shopName});

  @override
  State<ShopInfo4User> createState() => _ShopInfo4UserState();
}

class _ShopInfo4UserState extends State<ShopInfo4User> {
  var userName = "user";
  String phone = "";

  User? _user;
  bool giveSerial = false;

  @override
  void initState() {
    super.initState();
    _fetchFromLocalStorage();
    // Get the current user
    _user = FirebaseAuth.instance.currentUser;

    // FirebaseFirestore.instance
    //     .collection('serialList')
    //     .doc(_user!.uid)
    //     .get()
    //     .then((value) => isToggle = value['giveSerial']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ListTile(
            title: Text(widget.shopName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            subtitle: Row(
              children: [
                Icon(Icons.call_rounded,size: 15),
                Text(" $phone"),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 18, bottom: 5, left: 10, right: 10),
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 30, right: 30, bottom: 5, top: 5),
                decoration: BoxDecoration(
                  color: Colors.tealAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Serial List",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: widget.documentId!.isNotEmpty
                    ? SerialDetail(
                        documentId: widget.documentId,
                        details: 'nothing',
                      ) // access received documetId
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                onPressed: () async {
                  var sharePref = await SharedPreferences.getInstance();
                  setState(() {
                    giveSerial = !giveSerial;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(_user!.uid)
                        .update({SplashPageState.GIVESERIAL: giveSerial});
                    sharePref.setBool(SplashPageState.GIVESERIAL, giveSerial);
                  });

                  if (giveSerial) {
                    //for localStorage

                    int count = 1;
                    // print(_count.toString());
                    //_user = FirebaseAuth.instance.currentUser;
                    // Handle the input data here (e.g., add to Firestore)
                    var collection =
                        FirebaseFirestore.instance.collection('serialList');
                    var total;
                    var limit;
                    var activity;
                    collection
                        .doc(widget.documentId)
                        .get()
                        .then((documentSnapshot) {
                      if (documentSnapshot.exists) {
                        print("documentSnapshot");
                        //array,serial_list length
                        count = documentSnapshot.data()?['name'].length;
                        total = documentSnapshot.data()?['total'];
                        limit = documentSnapshot.data()?['limit'];
                        activity = documentSnapshot.data()?['activity'];
                      }
                    }).then((value) {
                      print("activity : $activity");
                      print("$total + 1  $limit");
                      if (total + 1 <= limit && activity) {
                        var data = collection
                            .doc(widget.documentId); // <-- Document ID
                        data.set({
                          'name': FieldValue.arrayUnion([userName])
                        }, SetOptions(merge: true));
                        data.set({'total': count + 1}, SetOptions(merge: true));
                      } else if (!activity) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.red,
                              content: Center(
                                child: Text("Shop already Closed"),
                              )),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.red,
                              content: Center(
                                child: Text("Limit Exceeded"),
                              )),
                        );
                      }
                    });
                    // Navigator.of(context).pop();
                  } else {
                    var total;
                    var val = [];
                    val.add(userName);

                    var collection =
                        FirebaseFirestore.instance.collection('serialList');

                    collection.doc(widget.documentId).update({
                      'name': FieldValue.arrayRemove(val),
                    });

                    collection
                        .doc(widget.documentId)
                        .get()
                        .then((documentSnapshot) {
                      if (documentSnapshot.exists) {
                        //array,serial_list length

                        total = documentSnapshot.data()?['total'];
                      }
                    }).then((value) {
                      collection
                          .doc(widget.documentId)
                          .update({'total': total - 1});
                    });
                  }
                },
                backgroundColor: giveSerial ? Colors.red : Colors.green,
                child: giveSerial
                    ? Text(
                        'X',
                        style: TextStyle(fontSize: 20),
                      )
                    : Icon(Icons.add),
              ),
            ],
          ),
        ));
  }

  void _fetchFromLocalStorage() async {
    var sharePref = await SharedPreferences.getInstance();
    userName = sharePref.getString(SplashPageState.USERNAME)!;
    giveSerial = sharePref.getBool(SplashPageState.GIVESERIAL)!;
    var p = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get().
    then((DocumentSnapshot documentSnapshot) {
      if(documentSnapshot.exists){
        phone = documentSnapshot.get(SplashPageState.PHONE);

      }
    });

    // setState(() {
    //   appBar = userName!;
    // });
  }
}

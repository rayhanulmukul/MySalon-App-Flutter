import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SwitchScreen extends StatefulWidget {
  const SwitchScreen({super.key});

  @override
  SwitchClass createState() => SwitchClass();
}

class SwitchClass extends State {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  Future<void> toggleSwitch(bool value) async {
    bool active = isSwitched;
    var user = FirebaseAuth.instance.currentUser;
    var data = await FirebaseFirestore.instance
        .collection('serialList')
        .doc(user!.uid);
      //   .get()
      //   .then((DocumentSnapshot documentSnapshot) {
      // if (documentSnapshot.exists) {
      //   //array,serial_list length
      // }});

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        data.set({'activity' : true}, SetOptions(merge: true));
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isSwitched = false;
        data.set({'activity' : false}, SetOptions(merge: true));
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ Transform.scale(
            scale: 2,
            child: Switch(
              onChanged: toggleSwitch,
              value: isSwitched,
              activeColor: Colors.blue,
              activeTrackColor: Colors.yellow,
              inactiveThumbColor: Colors.redAccent,
              inactiveTrackColor: Colors.orange,
            )
        ),
          //Text(textValue, style: const TextStyle(fontSize: 20),)
        ]);
  }
}
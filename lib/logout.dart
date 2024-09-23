import 'package:barberbook/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyLogout extends StatefulWidget {
  const MyLogout({super.key});

  @override
  State<MyLogout> createState() => _MyLogoutState();
}

class _MyLogoutState extends State<MyLogout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton(
            child: Text('Log out'),
            onPressed: (){
              FirebaseAuth.instance.signOut().then((value){
                print('Log out.');
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyLogin()));
              });
            },
          ),
        ),
      ),
    );
  }
}

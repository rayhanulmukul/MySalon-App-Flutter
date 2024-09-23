import 'package:barberbook/login.dart';
import 'package:barberbook/main.dart';
import 'package:barberbook/setStoreLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final userEmail = TextEditingController();
  final userPassword = TextEditingController();
  final userName = TextEditingController();
  final userPhone = ""; //TextEditingController();

  var options = [
    'User',
    'ServiceProvider',
  ];
  var _currentItemSelected = "User";
  var role = "User";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/register.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 38, top: 140),
              child: const Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 35),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.40,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: userName,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white)),
                          hintText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: userEmail,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white)),
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: userPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white)),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Resister as a : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff4c505b),
                            ),
                          ),
                          DropdownButton<String>(
                            dropdownColor: Colors.blue[200],
                            isDense: true,
                            isExpanded: false,
                            iconEnabledColor: Colors.blue,
                            focusColor: Colors.transparent,
                            items: options.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(
                                  dropDownStringItem,
                                  style: const TextStyle(
                                    color: Color(0xff4c505b),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValueSelected) {
                              setState(() {
                                _currentItemSelected = newValueSelected!;
                                role = newValueSelected;
                              });
                            },
                            value: _currentItemSelected,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Color(0xff4c505b),
                              fontSize: 27,
                              fontWeight: FontWeight.w700),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xff4c505b),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              //Firebase
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: userEmail.text,
                                      password: userPassword.text)
                                  .then((value) {
                                User? userr = value.user;
                                userr?.updateProfile(
                                    displayName: userName.text);
                                var user = FirebaseAuth.instance.currentUser;

                                CollectionReference ref = FirebaseFirestore
                                    .instance
                                    .collection('users');
                                ref.doc(user!.uid).set({
                                  SplashPageState.USERNAME : userName.text,
                                  SplashPageState.PHONE : userPhone,
                                  SplashPageState.EMAIL : userEmail.text,
                                  SplashPageState.ROLE : role,
                                  SplashPageState.STORENAME : "",
                                  SplashPageState.GIVESERIAL : false,
                                });
                                if(role == "ServiceProvider"){
                                  CollectionReference ref = FirebaseFirestore
                                      .instance
                                      .collection('serialList');
                                  ref.doc(user!.uid).set({
                                    'activity': false,
                                    'limit': 5,
                                    'total': 0,
                                    'name' : [],
                                  });
                                }

                                print('Created new account.');
                                // Successfully notification
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Center(
                                        child: Text("Sign up Successfully"),
                                      )),
                                );
                                if (role == "User") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyLogin()));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SetStoreLocation()));
                                }
                              }).onError((error, stackTrace) {
                                print("Error ${error.toString()}");
                                // error Notification
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Center(
                                        child:
                                            Text("This Email already exist!"),
                                      )),
                                );
                              });
                            },
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff4c505b),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyLogin()));
                            },
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color(0xff4c505b),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

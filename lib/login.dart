import 'package:barberbook/main.dart';
import 'package:barberbook/register.dart';
import 'package:barberbook/serviceProviderScreen.dart';
import 'package:barberbook/userScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});
  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final  userEmail = TextEditingController();
  final  userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login.png'), fit: BoxFit.cover)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 38, top: 140),
              child: const Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 35),),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5,
                right: 35,
                left: 35),
                child: Column(
                  children: [
                    TextField(
                      controller: userEmail,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                    ),
                    const SizedBox(height: 30,),
                    TextField(
                      controller: userPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: (){},
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color(0xff4c505b),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign In',
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
                            onPressed: (){
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                  email : userEmail.text,
                                  password : userPassword.text, )
                                  .then((value) {
                                print('Sign in with an account.');
                            // path of User or ServiceProvider
                                route();
                                    // Successfully notification
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Center(
                                            child: Text("Sign in Successfully"),
                                          )
                                      ),
                                    );
                              }).onError((error, stackTrace){
                                print("Error ${error.toString()}");
                                // error Notification
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                      content: Center(
                                        child: Text("email or password is invalid"),
                                      )
                                  ),
                                );
                              });
                              },
                            icon:  const Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff4c505b),),),
                        TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyRegister()));
                            },
                            child: const Text(
                              'Sign Up',
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
void route() async{
    var sharePref = await SharedPreferences.getInstance();
    String name = "User";
    String storeName = "Store";
    String phone = "";
    String email ="";
    bool giveSerial = false;

    sharePref.setBool(SplashPageState.KEYLOGIN, true);
  User? user = FirebaseAuth.instance.currentUser;
  var kk = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      print(documentSnapshot.get("role"));
      print(documentSnapshot);
      if ( documentSnapshot.get('role') == "ServiceProvider") {
        //set role : for this we come to here otherwise it can be call main.dart
        sharePref.setString(SplashPageState.ROLE, "ServiceProvider");

        if(documentSnapshot.get(SplashPageState.USERNAME) != null) {
          name = documentSnapshot.get(SplashPageState.USERNAME);
        }
        if(documentSnapshot.get(SplashPageState.PHONE) != null) {
          phone = documentSnapshot.get(SplashPageState.PHONE);
        }
        if(documentSnapshot.get(SplashPageState.EMAIL) != null) {
          email = documentSnapshot.get(SplashPageState.EMAIL);
        }
        if(documentSnapshot.get(SplashPageState.STORENAME) != null) {
          storeName = documentSnapshot.get(SplashPageState.STORENAME);
        }
        sharePref.setString(SplashPageState.USERNAME, name);
        sharePref.setString(SplashPageState.STORENAME, storeName);
        sharePref.setString(SplashPageState.PHONE, phone);
        sharePref.setString(SplashPageState.EMAIL, email);

        Navigator.pushReplacement(context,
          MaterialPageRoute(
            builder: (context) =>  const ServiceProviderScreen(),
          ),
        );
      }else{
        //set role
        sharePref.setString(SplashPageState.ROLE, "User");

        if(documentSnapshot.get(SplashPageState.USERNAME) != null) {
          name = documentSnapshot.get(SplashPageState.USERNAME);
        }
        if(documentSnapshot.get(SplashPageState.PHONE) != null) {
          phone = documentSnapshot.get(SplashPageState.PHONE);
        }
        if(documentSnapshot.get(SplashPageState.EMAIL) != null) {
          email = documentSnapshot.get(SplashPageState.EMAIL);
        }
        if(documentSnapshot.get(SplashPageState.GIVESERIAL) != null) {
          giveSerial = documentSnapshot.get(SplashPageState.GIVESERIAL);
        }

        sharePref.setString(SplashPageState.USERNAME, name);
        sharePref.setString(SplashPageState.PHONE, phone);
        sharePref.setString(SplashPageState.EMAIL, email);
        sharePref.setBool(SplashPageState.GIVESERIAL, giveSerial);
        Navigator.pushReplacement(context,
          MaterialPageRoute(
            builder: (context) =>  const UserScreen(),
          ),
        );
      }
    } else {
      print('Document does not exist on the database');
    }
  }
  );
}

}

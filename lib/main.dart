import 'dart:async';
//import 'dart:js';
import 'package:barberbook/firebase_options.dart';
import 'package:barberbook/serviceProviderScreen.dart';
import 'package:barberbook/userScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addSerial.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salun',
      theme: ThemeData(
        splashColor: Colors.green,


        iconTheme: const IconThemeData(
          //size: 35,
          // why colors Dont Work
          color: Colors.greenAccent
        ),
        //cardColor: Colors.orange,
       // colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(200,150,207, 1)),
        // colorScheme:ColorScheme.lerp(
        //     backgroundColor: const Color.fromRGBO(252,140,87, 1)),
        primarySwatch: Colors.deepOrange,
        //backgroundColor: Colors.blue,
        // App Bar
        appBarTheme:  const AppBarTheme(
          backgroundColor: Color.fromRGBO(252,140,87, 1),
          elevation: 25,
            //surfaceTintColor: Colors.blue,
           // scrolledUnderElevation: ,
          shadowColor: Color.fromRGBO(252,140,87, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
            )
          )
        ),
        //useMaterial3: true,
      ),
      home:const SplashPage(),
      //home:  PopUp(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => SplashPageState();
}

//_SplashPageStateState eta private.. '_' na thakle static
class SplashPageState extends State<SplashPage> {
  static const String KEYLOGIN = "login";
  static const String ROLE = "role";
  static const String USERNAME = "name";
  static const String EMAIL = "email";
  static const String PHONE = "phone";
  static const String STORENAME = "storeName";
  static const String GIVESERIAL = "giveSerial";
  static const Color BRANDCOLOR = Color.fromRGBO(252,140,87, 1);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
           width: double.infinity,
          //   height: ,
            decoration: const BoxDecoration(

                image: DecorationImage(

                    image: AssetImage('assets/images/logo.png'),

                    fit: BoxFit.cover))
        ),
      ),
    );
  }

  void whereToGo() async {
    var sharePref = await SharedPreferences.getInstance();

    var isLoggedIn = sharePref.getBool(KEYLOGIN);
    var role = sharePref.getString(ROLE);
   // Role = role!;

    Timer(const Duration(seconds: 2),() {
        if (isLoggedIn != null && role != null ) {
          if (isLoggedIn) {
            //role base log in
            if (role == "ServiceProvider") {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(
                    builder: (context) => const ServiceProviderScreen(),
                  ));
            } else {
              Navigator.pushReplacement( context,
                  MaterialPageRoute(
                    builder: (context) => UserScreen(),
                  ));
            }
          } else {
            Navigator.pushReplacement( context,
                MaterialPageRoute(
                  builder: (context) => const MyLogin(),
                ));
          }
        } else{
          Navigator.pushReplacement( context,
              MaterialPageRoute(
                builder: (context) => const MyLogin(),
              ));
        }
      },
    );
  }
}

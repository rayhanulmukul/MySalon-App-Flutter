import 'package:barberbook/login.dart';
import 'package:barberbook/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AllInfoFetch();
  }

  String userName = "User";
  String phone = "Null";
  String email = "Null";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Settings"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(35),
          child: Column(
            children: [
              //SizedBox(height: 20,),
              ListTile(
                leading: const Icon(Icons.person, color: SplashPageState.BRANDCOLOR,size: 35,),
                title: const Text(
                  'Name',
                  textScaleFactor: 1.5,
                ),
                subtitle: userName != null?
                Text(userName,textScaleFactor: 1.5):Text("Null"),
              ),
              //const SizedBox(height: 20,),
              ListTile(
                leading: const Icon(Icons.phone, color: SplashPageState.BRANDCOLOR,size: 35,),
                title: const Text(
                  'Phone',
                  textScaleFactor: 1.5,
                ),
                subtitle: phone != null?
                Text(phone,textScaleFactor: 1.5):Text("Null"),
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined, color: SplashPageState.BRANDCOLOR,size: 35, ),
                title: const Text(
                  'Email',
                  textScaleFactor: 1.5,
                ),
                subtitle: email != null?
                Text(email, textScaleFactor: 1.5):Text("Null"),
              ),
              const SizedBox(
                height: 50,
              ),

              FloatingActionButton(
                  onPressed: () {
                    _showEditPopUp(context);
                  },
                  child: Icon(Icons.edit),
                  // child: const Text(
                  //   "Edit",
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w900,
                  //     color: Colors.green,
                  //     shadows: [
                  //       Shadow(
                  //         color: Colors.black87, // Choose the color of the shadow
                  //         blurRadius:
                  //             2.0, // Adjust the blur radius for the shadow effect
                  //         offset: Offset(2.0,
                  //             2.0), // Set the horizontal and vertical offset for the shadow
                  //       ),
                  //     ],
                  //   ),
                  // )
              ),
              const SizedBox(
                height: 100,
              ),

    //           FirebaseAuth.instance.signOut().then((value){
    // print('Log out.');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyLogin()));
    //
              ElevatedButton(
                  onPressed: () async {
                    var sharePref = await SharedPreferences.getInstance();
                    sharePref.setBool(SplashPageState.KEYLOGIN, false );
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const MyLogin()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.red,
                            content: Center(
                              child: Text("Signed out Successfully"),
                            )
                        ),
                      );

                    });
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))
                ),
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ));
  }

  Future<void> AllInfoFetch() async {
    //var sharePref = await SharedPreferences.getInstance();

    User? user = FirebaseAuth.instance.currentUser;
    var kk = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {

        userName = documentSnapshot.get(SplashPageState.USERNAME);
        phone = documentSnapshot.get(SplashPageState.PHONE);
        email = documentSnapshot.get(SplashPageState.EMAIL);

        }});
    setState(() {

    });
  }
    // userName = sharePref.getString(SplashPageState.USERNAME)!;
    // phone = sharePref.getString(SplashPageState.PHONE)!;
    // email = sharePref.getString(SplashPageState.EMAIL)!;

  void _showEditPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // String inputText = "Customer";
        // String name = "user";
        // //  int _count = 0;

        return AlertDialog(

          title: const Text('Give Information'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      obscureText: false,
                      initialValue: userName,
                      decoration: const InputDecoration(labelText: "Name",icon: Icon(Icons.account_box)),
                      onChanged: (text){
                        userName = text;
                      },
                    ),
                    TextFormField(
                      obscureText: false,
                      initialValue: phone,
                      decoration: const InputDecoration(labelText: "Phone",icon: Icon(Icons.call)),
                            onChanged: (text){
                        phone = text;
                            },
                    ),
                    TextFormField(

                      obscureText: false,
                      initialValue: email,
                      decoration: const InputDecoration(labelText: "Email(Not Changeable)",icon: Icon(Icons.email_outlined)),
                      // onChanged: (text){
                      //   email = text;
                      // },
                    ),

                  ],
                ),
              ),
            ),
          ),


          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                var sharePref = await SharedPreferences.getInstance();
                sharePref.setString(SplashPageState.USERNAME, userName );
                sharePref.setString(SplashPageState.PHONE, phone );
               // sharePref.setString(SplashPageState.EMAIL, email );

                var user = FirebaseAuth.instance.currentUser;
                CollectionReference ref = FirebaseFirestore.instance.collection('users');
                ref.doc(user!.uid).update({
                  SplashPageState.USERNAME : userName,
                  SplashPageState.PHONE: phone,
                  SplashPageState.EMAIL: email,
                 });
                setState(() {

                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

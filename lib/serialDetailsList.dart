import 'package:barberbook/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SerialDetail extends StatefulWidget {
  final String documentId;
  final String details; // Accept the document ID as a parameter

  const SerialDetail({required this.documentId, required this.details});

  @override
  State<SerialDetail> createState() => _SerialDetailState();
}

class _SerialDetailState extends State<SerialDetail> {
  var role;

  //const SerialDetail({super.key, required this.documentId});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchFromLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('serialList')
          .doc(widget.documentId)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text('No data available'));
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> array = data['name'];

        // Total And Limit Start
        var total = data['total'];
        int limit = data['limit'];

        if (widget.details == "total") {
          return Text("$total",
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black));
        }
        if (widget.details == "limit") {
          return Text("$limit",
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black));
        }
        if (widget.details == "limit-total") {
          return Container(
           // width: 150,
            child: FilledButton(
              onPressed: (){},
                child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("$total",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //color: Colors.greenAccent,
                        )),
                      Text("/$limit",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            //color: Colors.greenAccent,
                          )),
                    ],
                  ),
                  const Text("time"),
                ],

              ),
        ),
          );
        }

        // End

        if (array.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        //list tiles Start here
        return ListView.builder(
          itemCount: array.length,
          itemBuilder: (context, index) {
            final TextStyle titleTextStyle = index.isEven
                ? const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown)
                : const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black);
            return Container(
              //distance between two tile
              padding: const EdgeInsetsDirectional.only(bottom: 5),
              // decoration: BoxDecoration(
              //   //borderRadius: BorderRadius.circular(20),
              //   //color: Colors.white,
              // ),
              child: Card(
                // semanticContainer: true,
                elevation: 10,
                //color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                shadowColor: Colors.red,

                child: ListTile(
                  leading: CircleAvatar(
                      child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  )),
                  title: Text(
                    array[index].toString(),
                    style: titleTextStyle,
                  ),
                  // tileColor: Colors.greenAccent,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(20),
                  // ),

                  contentPadding: const EdgeInsets.all(10),
                  titleTextStyle: titleTextStyle,
                  trailing: role == "ServiceProvider"
                      ? ElevatedButton.icon(
                          onPressed: () {
                            var val = [];
                            val.add(array[index].toString());
                            final collection = FirebaseFirestore.instance
                                .collection('serialList');
                            collection.doc(widget.documentId).update({
                              'name': FieldValue.arrayRemove(val),
                            });
                            collection.doc(widget.documentId).update({
                              'total': array.length - 1,
                            });
                          },
                          label: const Text("Done"),
                          icon: const Icon(
                            Icons.done,
                          ),
                        )
                      : Text(""),
                  // FilledButton.icon(
                  //         onPressed: () {},
                  //         icon: const Icon(Icons.),
                  //         label: const Text(""),
                  //       ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _fetchFromLocalStorage() async {
    //finding the role of the users
    var sharePref = await SharedPreferences.getInstance();
    role = sharePref.getString(SplashPageState.ROLE);
  }
}

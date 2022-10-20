import 'package:bestrun/models/acvtivity_model.dart';
import 'package:bestrun/utils/authentication.dart';
import 'package:bestrun/utils/globals.dart' as globals;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MyActivityScreen extends StatefulWidget {
  final String title = 'messageList.screenTitle'.tr();
  final TextStyle titleTextStyle = globals.titleTextStyle;
  final fb = FirebaseDatabase.instance;

  @override
  _MyActivityScreenState createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen> {
  @override
  Widget build(BuildContext context) {
    final ref = this
        .widget
        .fb
        .ref()
        .child('activities')
        .child(Authentication().currentUser!.uid);
    return Scaffold(
      backgroundColor: Colors.black,
      body: FirebaseAnimatedList(
        query: ref,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          var activity =
              Activity.fromJson(snapshot.value as Map<String, dynamic>);
          return Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "2020.12.19",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "03:04:06:20",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Helvetica',
                  ),
                ),
                Text('12 km'),
                Text('4 CP'),
              ],
            ),
          );
        },
      ),
    );
  }
}

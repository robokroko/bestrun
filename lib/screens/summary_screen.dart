import 'package:bestrun/utils/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MyActivityScreen extends StatefulWidget {
  final String title = 'messageList.screenTitle'.tr();
  final TextStyle titleTextStyle = globals.titleTextStyle;

  @override
  _MyActivityScreenState createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: ListView.builder(itemBuilder: (BuildContext ctxt, int index) {
          return Container(
            margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(5),
                  bottomRight: const Radius.circular(5)),
            ),
            width: double.infinity,
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(
                        topRight: const Radius.circular(5),
                        bottomRight: const Radius.circular(5)),
                  ),
                  child: expansionList(ctxt, index),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}



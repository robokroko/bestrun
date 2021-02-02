import 'dart:async';
import 'dart:typed_data';

import 'package:bestrun/components/appbar.dart';
import 'package:bestrun/components/alert_dialog.dart';
import 'package:bestrun/utils/dateTimeFormatter.dart';
import 'package:bestrun/utils/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bestrun/components/menu.dart';
import 'package:flutter/services.dart';

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
  /*Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BestRunAppBar(),
      body: Column(
        children: [
          ListTile(
            title: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: globals.bestRunGreen,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            "2020.12.17",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "02:05:16:55",
                            style: const TextStyle(
                              color: globals.bestRunGreen,
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "4 km",
                            style: const TextStyle(
                              color: globals.bestRunGreen,
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "8 laps",
                            style: const TextStyle(
                              color: globals.bestRunGreen,
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 14.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: globals.bestRunGreen,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            "2020.12.19",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "00:05:12:25",
                            style: const TextStyle(
                              color: globals.bestRunGreen,
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "5 km",
                            style: const TextStyle(
                              color: globals.bestRunGreen,
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "9 laps",
                            style: const TextStyle(
                              color: globals.bestRunGreen,
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 14.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: globals.bestRunGreen,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            "2021.01.22",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "03:04:06:20",
                            style: const TextStyle(
                              color: globals.bestRunGreen,
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "10 km",
                            style: const TextStyle(
                              color: globals.bestRunGreen,
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "16laps",
                            style: const TextStyle(
                              color: globals.bestRunGreen,
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 14.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/
}

Widget expansionList(BuildContext context, int index) {
  print("Building expansion tile");
  return new ExpansionTile(
    initiallyExpanded: false,
    title: Column(
      children: [
        Row(
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
      ],
    ),
    children: [
      Text('Row 1'),
      Text('Row 2'),
      Text('Row 3'),
      Text('Row 4'),
    ],
  );
}

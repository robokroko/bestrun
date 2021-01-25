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
      appBar: BestRunAppBar(),
      drawerEdgeDragWidth: 0,
      endDrawer: Menu(),
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
  }
}

import 'dart:convert';

import 'package:bestrun/components/BR_loading_modal.dart';
import 'package:bestrun/components/appbar.dart';
import 'package:bestrun/components/br_popup_dialogs.dart';
import 'package:bestrun/components/menu.dart';
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
  final _scrollController = ScrollController();
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
      appBar: BestRunAppBar(),
      drawerEdgeDragWidth: 0,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'My Activities',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.headline6!.fontSize,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              reverse: true,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map<String, dynamic> data =
                    jsonDecode(jsonEncode(snapshot.value));
                var activity = Activity.fromJson(data);
                return Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    height: 640,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.5, bottom: 2.5),
                              child: InkWell(
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  height: 26.0,
                                  width: 50.0,
                                  child: const Icon(Icons.delete_outline,
                                      color: Colors.grey),
                                ),
                                onTap: () async {
                                  var result =
                                      await BRPopUpDialogs.openConfirmDialog(
                                          context: context,
                                          message:
                                              'Are you sure to delete this activity?');
                                  if (result) {
                                    BRLoadingDialog.show(
                                        context: context, title: 'Loading...');
                                    ref.child(snapshot.key!).remove();
                                    BRLoadingDialog.hide(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12.0, bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                activity.date.toString(),
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 18,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 240,
                          child:
                              Image.memory(base64Decode(activity.imageCode!)),
                        ),
                        SizedBox(
                          width: 290,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0, top: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total distance:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    Text(
                                      activity.distance!.toStringAsFixed(3) +
                                          ' km',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0, top: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total time:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    Text(
                                      activity.checkpoints.last.time!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0, top: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Average:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    Text(
                                      activity.average! == '0.0'
                                          ? '0.000 km/h'
                                          : activity.average!.substring(
                                                0,
                                                10,
                                              ) +
                                              ' km/h',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0, top: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Checkpoints:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.amber,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 10.0),
                                child: SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    itemCount: activity.checkpoints.length,
                                    controller: _scrollController,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final lap = activity.checkpoints[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, right: 12.0, top: 12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (index + 1).toString() + '.',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontFamily: 'Helvetica',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              lap.time!,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontFamily: 'Helvetica',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              lap.distance!.toStringAsFixed(3) +
                                                  ' km',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontFamily: 'Helvetica',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

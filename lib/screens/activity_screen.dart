import 'dart:async';
import 'dart:typed_data';

import 'package:bestrun/components/appbar.dart';
import 'package:bestrun/components/alert_dialog.dart';
import 'package:bestrun/utils/dateTimeFormatter.dart';
import 'package:bestrun/utils/globals.dart' as globals;
import 'package:bestrun/utils/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bestrun/components/menu.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ActivityScreen extends StatefulWidget {
  final String title = 'messageList.screenTitle'.tr();

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  //map variable
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  GoogleMapController _controller;
  //stopwatch variable
  final _isHours = true;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
    onChange: (value) => print('onChange $value'),
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );
  final _scrollController = ScrollController();

  void _onMapCreated(GoogleMapController _cntlr) {}

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(46.23872780172595, 20.140179885694906),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/images/logo_small.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarker(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarker(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 0.0,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarker(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
  }

  @override
  void dispose() async {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: BestRunAppBar(),
        drawerEdgeDragWidth: 0,
        endDrawer: Menu(),
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: initialLocation,
                    markers: Set.of((marker != null) ? [marker] : []),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                  ),
                ),
                FloatingActionButton(
                    child: Icon(Icons.location_searching),
                    onPressed: () {
                      getCurrentLocation();
                    }),
              ],
            ),
            Flexible(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: _stopWatchTimer.rawTime.value,
                    builder: (context, snap) {
                      final value = snap.data;
                      final displayTime =
                          StopWatchTimer.getDisplayTime(value, hours: _isHours);
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Text(
                                      displayTime,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      "Time",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Text(
                                      "0.00 km",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      "Distance",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'Helvetica',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ]),
            ),
            //laps
            Flexible(
              child: Container(
                height: 200,
                margin: const EdgeInsets.all(8),
                child: StreamBuilder<List<StopWatchRecord>>(
                  stream: _stopWatchTimer.records,
                  initialData: _stopWatchTimer.records.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    if (value.isEmpty) {
                      return Container();
                    }
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut);
                    });
                    print('Listen records. $value');
                    return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final data = value[index];
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${index + 1} ${data.displayTime}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              height: 1,
                            )
                          ],
                        );
                      },
                      itemCount: value.length,
                    );
                  },
                ),
              ),
            ),
            //bottons
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: RaisedButton(
                      padding: const EdgeInsets.all(4),
                      color: Colors.purple,
                      onPressed: () async {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: RaisedButton(
                      padding: const EdgeInsets.all(4),
                      color: Colors.lightBlue,
                      onPressed: () async {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
                      },
                      child: const Text(
                        'Lap',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: RaisedButton(
                      padding: const EdgeInsets.all(4),
                      color: globals.bestRunGreen,
                      onPressed: () async {
                        getCurrentLocation();
                        _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                      },
                      child: const Text(
                        'Start',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: RaisedButton(
                      padding: const EdgeInsets.all(4),
                      color: Colors.red,
                      onPressed: () async {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                      },
                      child: const Text(
                        'Stop',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

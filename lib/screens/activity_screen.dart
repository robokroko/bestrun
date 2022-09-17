import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'package:bestrun/components/BR_loading_modal.dart';
import 'package:bestrun/components/appbar.dart';
import 'package:bestrun/components/br_popup_dialogs.dart';
import 'package:bestrun/models/lap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bestrun/components/menu.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:collection/collection.dart';

class ActivityScreen extends StatefulWidget {
  final String title = 'messageList.screenTitle'.tr();
  final user = FirebaseAuth.instance.currentUser;

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  //map variable
  StreamSubscription? _locationSubscription;
  Location? _locationTracker = Location();
  Marker? runnerMarker;
  List<Marker> _markers = <Marker>[];
  GoogleMapController? _controller;
  Set<Polyline>? _polylines = {};
  LocationData? lastLocation;
  // double distance = 0;
  ValueNotifier<double> distance = ValueNotifier<double>(0);
  bool isActivityInProgress = false;
  ValueNotifier<dynamic> nfcResult = ValueNotifier(null);
  List<int> rawTimes = [];
  List<Lap> laps = [];
  List<double> distances = [];

  final _isHours = true;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,

    /* onChange: (value) => print('onChange $value'),
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),*/
  );
  final _scrollController = ScrollController();

  //void _onMapCreated(GoogleMapController _cntlr) {}

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(46.23872780172595, 20.140179885694906),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarkerRunnerMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/images/logo_small.png");
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> getCheckpointMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/person.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarker(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    this.setState(() {
      runnerMarker = Marker(
        markerId: MarkerId("runnerMarker"),
        position: latlng,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData),
      );
    });
  }

  void addCheckPointMarker(String markedIdText) async {
    if (await checkTagIsInTheMarkerList(markedIdText)) {
      await BRPopUpDialogs.openAlertDialog(
          context: context, message: 'Már járt ezen az elenőrző ponton!');
    } else {
      Uint8List imageData = await getCheckpointMarker();
      var location = await _locationTracker?.getLocation();

      LatLng latlng = LatLng(location!.latitude!, location.longitude!);
      _markers.add(
        Marker(
          markerId: MarkerId(markedIdText),
          position: latlng,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData),
          infoWindow: InfoWindow(title: 'The title of the checkpoint'),
        ),
      );
      _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
      rawTimes.add(_stopWatchTimer.rawTime.value);
      distances.add(distance.value);
    }
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarkerRunnerMarker();
      var location = await _locationTracker?.getLocation();

      updateMarker(location!, imageData);

      if (_locationSubscription != null) {
        _locationSubscription?.cancel();
      }

      _locationSubscription =
          _locationTracker?.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller?.animateCamera(
            CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 0.0,
                  target:
                      LatLng(newLocalData.latitude!, newLocalData.longitude!),
                  tilt: 0,
                  zoom: 18.00),
            ),
          );
          updateMarker(newLocalData, imageData);

          if (lastLocation != null && isActivityInProgress == true) {
            createPolyline(newLocalData);

            distance.value = distance.value +
                calculateDistance(
                    lastLocation?.latitude,
                    lastLocation?.longitude,
                    newLocalData.latitude,
                    newLocalData.longitude);
          }
          lastLocation = newLocalData;
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  createPolyline(LocationData newLocalData) {
    setState(() {
      _polylines?.add(
        Polyline(
          color: Color(0xFF69FF03),
          endCap: Cap.roundCap,
          polylineId: PolylineId(UniqueKey().toString()),
          points: [
            LatLng(lastLocation!.latitude!, lastLocation!.longitude!),
            LatLng(newLocalData.latitude!, newLocalData.longitude!),
          ],
        ),
      );
    });
  }

  void removePolylines() {
    _polylines?.clear();
  }

  void removeCheckPointMarkers() {
    _markers.removeWhere(
        (element) => element.markerId.toString() != 'runnerMarker');
  }

  Future checkTagIsInTheMarkerList(String tagRecord) async {
    var marker = _markers
        .firstWhereOrNull((element) => element.markerId.value == tagRecord);

    if (marker != null && marker.markerId.value == tagRecord) {
      return true;
    } else {
      return false;
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _startTagReadSession() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      final ndef = Ndef.from(tag);

      if (ndef!.cachedMessage!.records.isEmpty ||
          ndef.cachedMessage!.records[0].payload.length == 0) {
        await BRPopUpDialogs.openAlertDialog(
            context: context,
            message: 'A tag nem tartalmaz kiolvasható adatot!');
      } else {
        Uint8List payload =
            Uint8List.fromList(ndef.cachedMessage!.records[0].payload);
        Uint8List sub = payload.sublist(payload[0] + 1);

        String tagRecordText = String.fromCharCodes(sub);
        debugPrint('---------TAGRECORD-------------');
        debugPrint(tagRecordText);
        addCheckPointMarker(tagRecordText);
      }
    });
  }

  void makeLapsList() {
    for (var i = 0; i < distances.length; i++) {
      laps.add(new Lap(
        distance: distances[i],
        time: rawTimes[i],
      ));
    }
    debugPrint(laps.toString());
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
    //  _stopWatchTimer.rawTime.listen((value) =>
    //     print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    //  _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    ////  _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    //  _stopWatchTimer.records.listen((value) => print('records $value'));
  }

  @override
  void dispose() async {
    if (_locationSubscription != null) {
      _locationSubscription?.cancel(); //TODO - nullcheck is good?
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
                  markers: Set.of(
                      (runnerMarker != null) ? [runnerMarker!] + _markers : []),
                  polylines: _polylines!,
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snap) {
                final value = snap.data;
                final displayTime =
                    StopWatchTimer.getDisplayTime(value!, hours: _isHours);
                return Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: StatefulBuilder(builder: (context, setState) {
                            return Text(
                              displayTime,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            );
                          }),
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
                  ],
                );
              },
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: ValueListenableBuilder(
                    builder: (BuildContext context, value, Widget? child) {
                      return Text(
                        distance.value.toStringAsFixed(2),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold),
                      );
                    },
                    valueListenable: distance,
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
          ]),
          //laps
          Container(
            height: 100.0,
            child: StreamBuilder<List<StopWatchRecord>>(
              stream: _stopWatchTimer.records,
              initialData: _stopWatchTimer.records.value,
              builder: (context, snap) {
                final value = snap.data;
                if (value!.isEmpty) {
                  //TODO - nullcheck is good?
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
                  itemCount: value.length,
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    final data = value[index];
                    final data2 = distances[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            '${index + 1} ${data.displayTime}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            data2.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
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
                );
              },
            ),
          ),

          //bottons

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () async {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                    setState(() {
                      isActivityInProgress = true;
                    });
                    _startTagReadSession();
                  },
                  child: const Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () async {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    setState(() {
                      isActivityInProgress = false;
                    });
                    NfcManager.instance.stopSession();
                  },
                  child: const Text(
                    'Pause',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          if (isActivityInProgress == false)
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () async {},
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void saveSassion() async {
    var result = await BRPopUpDialogs.openConfirmDialog(
        context: context, message: 'Biztos, hogy elmenti a ');
    NfcManager.instance.stopSession();
    if (result) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);

      removePolylines();
      removeCheckPointMarkers();
      makeLapsList();
      setState(() {
        isActivityInProgress = false;
        distance.value = 0;
        distances.clear();
      });
      
    }
  }
}

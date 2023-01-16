import 'dart:async';
import 'dart:math';
import 'package:bestrun/components/BR_loading_modal.dart';
import 'package:bestrun/components/appbar.dart';
import 'package:bestrun/components/br_button.dart';
import 'package:bestrun/components/br_popup_dialogs.dart';
import 'package:bestrun/models/acvtivity_model.dart';
import 'package:bestrun/models/lap.dart';
import 'package:bestrun/utils/authentication.dart';
import 'package:bestrun/utils/date_time_formatter.dart';
import 'package:bestrun/utils/ecryption.dart';
import 'package:bestrun/utils/weather.dart';
import 'package:encrypt/encrypt.dart';
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
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class ActivityScreen extends StatefulWidget {
  final String title = 'messageList.screenTitle'.tr();
  final user = FirebaseAuth.instance.currentUser;

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  StreamSubscription? _locationSubscription;
  Location? _locationTracker = Location();
  Marker? runnerMarker;
  List<Marker> _markers = <Marker>[];
  GoogleMapController? _mapController;
  Set<Polyline>? _polylines = {};
  LocationData? lastLocation;
  ValueNotifier<double> distance = ValueNotifier<double>(0);
  bool isActivityInProgress = false;
  bool isActivityIsPaused = false;
  bool isRaceStarted = false;
  bool isSaveButtonVisible = false;
  ValueNotifier<dynamic> nfcResult = ValueNotifier(null);
  List<int> rawTimes = [];
  List<String> lapStringTimes = [];
  List<Lap> laps = [];
  List<double> distances = [];
  final User? user = Authentication().currentUser;
  final fb = FirebaseDatabase.instance;
  DateTime now = DateTime.now();
  Activity _activity = Activity(checkpoints: []);
  var _activityJson;
  String raceName = '';
  List<String> tagList = [];
  final _isHours = true;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
  );
  final _scrollController = ScrollController();
  Weather weather = Weather();
  int temperature = 0;
  String weatherIcon = 'sun';
  String weatherCondition = '';
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

  void updateRunnerMarker(LocationData newLocalData, Uint8List imageData) {
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
      lapStringTimes
          .add(StopWatchTimer.getDisplayTime(_stopWatchTimer.rawTime.value));
      rawTimes.add(_stopWatchTimer.rawTime.value);
      distances.add(distance.value);
    }
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarkerRunnerMarker();
      var location = await _locationTracker?.getLocation();

      var weatherData = await weather.getWeatherFromLocation(location!);
      updateWeather(weatherData);

      updateRunnerMarker(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription?.cancel();
      }

      _locationSubscription =
          _locationTracker?.onLocationChanged.listen((newLocalData) {
        if (_mapController != null) {
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 0.0,
                  target:
                      LatLng(newLocalData.latitude!, newLocalData.longitude!),
                  tilt: 0,
                  zoom: 18.00),
            ),
          );
          updateRunnerMarker(newLocalData, imageData);

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

  void updateWeather(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'No info';
        weatherCondition = '';
        return;
      }

      var temp = weatherData['main']['temp'];
      temperature = temp.toInt();

      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);

      weatherCondition = weatherData['weather'][0]['main'];
    });
  }

  void createPolyline(LocationData newLocalData) {
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
    double toRadians(double degree) {
      return degree * pi / 180;
    }

    final r = 6372.8;
    lat1 = toRadians(lat1);
    lat2 = toRadians(lat2);
    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(lon2 - lon1);
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    return r * c;
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

        var decryptedTagrecordtext =
            decrypt(Encrypted.fromBase64(tagRecordText));
        debugPrint(decryptedTagrecordtext);
        String? result = tagList
            .firstWhereOrNull((element) => element == decryptedTagrecordtext);
        if (result == null) {
          await BRPopUpDialogs.openAlertDialog(
              context: context,
              message:
                  'Such a TAG is not among those registered or has already been registered before');
        } else {
          tagList.remove(result);
          addCheckPointMarker(tagRecordText);
          if (tagList.isEmpty) {
            saveSassion();
          }
        }
      }
    });
  }

  void _startTagReadSessionForAddNewRace() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
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
          var decryptedTagrecordtext =
              decrypt(Encrypted.fromBase64(tagRecordText));
          debugPrint(decrypt(Encrypted.fromBase64(tagRecordText)));
          final splitted = decryptedTagrecordtext.split('#');
          debugPrint(splitted.toString());
          if (splitted.length != 4 || splitted[0] != 'start') {
            await BRPopUpDialogs.openAlertDialog(
                context: context, message: 'This is not a race info tag!');
          } else {
            int? tagNumber = int.tryParse(splitted[1]);
            for (int i = 1; i < tagNumber! + 1; i++) {
              tagList.add(i.toString() + '#' + splitted[2]);
            }
            debugPrint(tagList.toString());
            await BRPopUpDialogs.openAlertDialog(
                context: context, message: 'Race added successfully');
            NfcManager.instance.stopSession();
            setState(() {
              isRaceStarted = true;
              raceName = splitted[3];
            });
          }
        }
      },
    );
  }

  void makeLapList() {
    for (var i = 0; i < distances.length; i++) {
      laps.add(new Lap(
        distance: distances[i],
        time: lapStringTimes[i],
      ));
    }
    debugPrint(laps.toString());
  }

  @override
  void initState() {
    getCurrentLocation();
    BRLoadingDialog.hide(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BestRunAppBar(),
      drawerEdgeDragWidth: 0,
      endDrawer: Menu(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 220,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: initialLocation,
                  markers: Set.of(
                      (runnerMarker != null) ? [runnerMarker!] + _markers : []),
                  polylines: _polylines!,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                ),
              ),
              FloatingActionButton(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.location_searching, color: Colors.black),
                  mini: true,
                  onPressed: () {
                    getCurrentLocation();
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  raceName + ' - ',
                  style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 17,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                child: Image.asset(
                  'assets/images/$weatherIcon.png',
                  height: 25,
                  color: Colors.amber,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  ' $temperature C° $weatherCondition',
                  style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 17,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold),
                ),
              ),
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
                          padding: const EdgeInsets.only(top: 10),
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
          if (!isRaceStarted)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: BRButton(
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      _startTagReadSessionForAddNewRace();
                    },
                    child: const Text(
                      'Add New Race',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          if (isRaceStarted)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: BRButton(
                        backgroundColor: Colors.green,
                        onPressed: () async {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                          setState(() {
                            isActivityInProgress = true;
                            isActivityIsPaused = false;
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
                      child: BRButton(
                        onPressed: () async {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                          setState(() {
                            isActivityInProgress = false;
                            isActivityIsPaused = true;
                            isSaveButtonVisible = true;
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (isActivityIsPaused)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: BRButton(
                            backgroundColor: Colors.red.shade400,
                            onPressed: () async {
                              cancelActivity();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      if (isActivityInProgress == false && isSaveButtonVisible)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: BRButton(
                            backgroundColor: Colors.blue.shade300,
                            onPressed: () async {
                              saveSassion();
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }

  void saveSassion() async {
    makeLapList();
    if (laps.isNotEmpty) {
      final ref =
          fb.ref().child('activities').child(Authentication().currentUser!.uid);
      var result = await BRPopUpDialogs.openConfirmDialog(
          context: context, message: 'Are you sure to finish this activity?');
      NfcManager.instance.stopSession();
      if (result) {
        //BRLoadingDialog.show(context: context, title: 'Loading');
        var result1 = await BRPopUpDialogs.openConfirmDialog(
            context: context, message: 'Are you sure to finish this activity?');
        if (result) {}
        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        await ref.push().set(await addDataToActivity());
        removePolylines();
        removeCheckPointMarkers();
        setState(() {
          isActivityInProgress = false;
          isActivityIsPaused = false;
          isSaveButtonVisible = false;
          raceName = '';
          isRaceStarted = false;
          laps = [];
          distance.value = 0;
          distances.clear();
        });
        BRLoadingDialog.hide(context);
      }
    } else {
      BRPopUpDialogs.openConfirmDialog(
          context: context,
          message:
              'You can not save activity, because you havent reach any checkpoint yet!');
    }
  }

  dynamic addDataToActivity() async {
    final uin8list = await _mapController!.takeSnapshot();
    String snap = base64Encode(uin8list!);
    _activity.date =
        DateTimeFormatter.formatDateTime(DateTime.now()).toString();
    _activity.time = laps.last.time!.toString();
    _activity.distance = distances.last;
    _activity.checkpoints = laps;
    _activity.average = (distances.last % (rawTimes.last * 3600000)).toString();
    _activity.activityName = raceName;
    _activity.temperature = temperature;
    _activity.weatherCondition = weatherCondition;
    _activity.imageCode = snap;
    _activityJson = _activity.toJson();
    return _activityJson;
  }

  void cancelActivity() async {
    var result = await BRPopUpDialogs.openConfirmDialog(
        context: context, message: 'Are you sure to cancel this activity?');
    NfcManager.instance.stopSession();
    if (result) {
      BRLoadingDialog.show(context: context, title: 'Loadin');
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      removePolylines();
      removeCheckPointMarkers();
      setState(() {
        isActivityInProgress = false;
        isActivityIsPaused = false;
        isSaveButtonVisible = false;
        laps = [];
        distance.value = 0;
        distances.clear();
        isRaceStarted = false;
        raceName = '';
      });
      BRLoadingDialog.hide(context);
    }
  }

  @override
  void dispose() async {
    if (_locationSubscription != null) {
      _locationSubscription?.cancel(); //TODO - nullcheck is good?
    }
    super.dispose();
    await _stopWatchTimer.dispose();
  }
}

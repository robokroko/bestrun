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
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'dart:async';
import 'dart:io';

class RecordEditor {
  TextEditingController mediaTypeController;
  TextEditingController payloadController;

  RecordEditor() {
    mediaTypeController = TextEditingController();
  }
}

class TagWriteScreen extends StatefulWidget {
  @override
  _TagWriteScreenState createState() => _TagWriteScreenState();
}

class _TagWriteScreenState extends State<TagWriteScreen> {
  StreamSubscription<NDEFMessage> _stream;
  List<RecordEditor> _records = [];
  bool _hasClosedWriteDialog = false;

  void _addRecord() {
    setState(() {
      _records.add(RecordEditor());
    });
  }

  void _write(BuildContext context) async {
    List<NDEFRecord> records = _records.map((record) {
      return NDEFRecord.type(
        record.mediaTypeController.text,
        record.payloadController.text,
      );
    }).toList();
    NDEFMessage message = NDEFMessage.withRecords(records);
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Scan the tag you want to write to"),
          actions: <Widget>[
            FlatButton(
              child: const Text("Cancel"),
              onPressed: () {
                _hasClosedWriteDialog = true;
                _stream?.cancel();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    await NFC.writeNDEF(message).first;
    if (!_hasClosedWriteDialog) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BestRunAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Center(
            child: OutlineButton(
              child: const Text(
                "Add record",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _addRecord,
            ),
          ),
          for (var record in _records)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Record", style: TextStyle(color: Colors.white)),
                  TextFormField(
                    controller: record.mediaTypeController,
                    decoration: InputDecoration(
                      hintText: "Media type",
                    ),
                  ),
                  TextFormField(
                    controller: record.payloadController,
                    decoration: InputDecoration(
                      hintText: "Payload",
                    ),
                  )
                ],
              ),
            ),
          Center(
            child: RaisedButton(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Write to tag",
                      style: TextStyle(
                        fontSize: 20,
                        color: globals.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
              color: globals.bestRunGreen,
              textColor: globals.unreadMessageWhiteTextColor,
              onPressed: _records.length > 0 ? () => _write(context) : null,
            ),
          ),
        ],
      ),
    );
  }
}

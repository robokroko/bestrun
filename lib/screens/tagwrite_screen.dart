import 'package:bestrun/components/appbar.dart';
import 'package:bestrun/components/br_button.dart';
import 'package:bestrun/components/br_popup_dialogs.dart';
import 'package:bestrun/utils/ecryption.dart';
import 'package:bestrun/utils/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class TagWriteScreen extends StatefulWidget {
  @override
  _TagWriteScreenState createState() => _TagWriteScreenState();
}

bool isRaceInfoTag = true;
bool isCheckpointTag = false;
bool isFinishTag = false;

class _TagWriteScreenState extends State<TagWriteScreen> {
  List<String?> list = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25'
  ];
  TextEditingController? keyontroller = TextEditingController();
  TextEditingController? raceNameController = TextEditingController();

  void _ndefWrite(String text) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        BRPopUpDialogs.openAlertDialog(
            context: context, message: 'Tag is not ndef writable');
        NfcManager.instance.stopSession();
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(text),
      ]);

      try {
        await ndef.write(message);
        debugPrint('-----------------------------');
        debugPrint(
            'üzenet: ' + String.fromCharCodes(message.records.first.payload));
        BRPopUpDialogs.openAlertDialog(
            context: context, message: 'Successful tagwrite!');
        NfcManager.instance.stopSession();
      } catch (e) {
        BRPopUpDialogs.openAlertDialog(
            context: context, message: 'Unsuccess writing to tag!');
        NfcManager.instance.stopSession(errorMessage: e.toString());
        return;
      }
    });
  }

  String dropdownValue = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BestRunAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: isRaceInfoTag
                        ? Text("Number of checkpoints",
                            style: TextStyle(color: Colors.white))
                        : Text("Tag number",
                            style: TextStyle(color: Colors.white)),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.amber),
                    dropdownColor: Colors.black,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String? items) {
                      return DropdownMenuItem<String>(
                        value: items!,
                        child: Text(items),
                      );
                    }).toList(),
                  ),
                  if (isRaceInfoTag)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Name of the race",
                          style: TextStyle(color: Colors.white)),
                    ),
                  if (isRaceInfoTag)
                    TextFormField(
                      controller: raceNameController,
                      style: TextStyle(
                        color: globals.unreadMessageWhiteTextColor,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          borderSide: BorderSide(
                              width: 0.4,
                              color: globals.unreadMessageGreyTextColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          borderSide:
                              BorderSide(width: 0.4, color: Colors.amber),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          borderSide:
                              BorderSide(width: 0.4, color: Colors.amber),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("Key", style: TextStyle(color: Colors.white)),
                  ),
                  TextFormField(
                    controller: keyontroller,
                    style: TextStyle(
                      color: globals.unreadMessageWhiteTextColor,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                        borderSide: BorderSide(
                            width: 0.4,
                            color: globals.unreadMessageGreyTextColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                        borderSide: BorderSide(width: 0.4, color: Colors.amber),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                        borderSide: BorderSide(width: 0.4, color: Colors.amber),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isRaceInfoTag = !isRaceInfoTag;
                          });
                        },
                        child: Text(
                          isRaceInfoTag ? 'Checkpoint tag' : 'Race info tag',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: BRButton(
                width: 80.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Write to tag",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  if (keyontroller?.text != null) {
                    if (isRaceInfoTag) {
                      _ndefWrite(encrypt('start' +
                              '#' +
                              dropdownValue +
                              '#' +
                              keyontroller!.text +
                              '#' +
                              raceNameController!.text)
                          .base64);
                    } else {
                      _ndefWrite(
                          encrypt(dropdownValue + '#' + keyontroller!.text)
                              .base64);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

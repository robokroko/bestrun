import 'package:bestrun/components/appbar.dart';
import 'package:bestrun/components/br_button.dart';
import 'package:bestrun/components/br_popup_dialogs.dart';
import 'package:bestrun/utils/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class TagWriteScreen extends StatefulWidget {
  @override
  _TagWriteScreenState createState() => _TagWriteScreenState();
}

class _TagWriteScreenState extends State<TagWriteScreen> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  TextEditingController? recordController = TextEditingController();

  void _ndefWrite(String text) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(text),
      ]);

      try {
        await ndef.write(message);
        result.value = 'Success to "Ndef Write"';
        debugPrint('-----------------------------');
        debugPrint(
            'üzenet: ' + String.fromCharCodes(message.records.first.payload));
        BRPopUpDialogs.openAlertDialog(
            context: context, message: 'Successful tagwrite!');
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        BRPopUpDialogs.openAlertDialog(
            context: context, message: 'Unsuccess writing to tag!');
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BestRunAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Record", style: TextStyle(color: Colors.white)),
                TextFormField(
                  controller: recordController,
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
              ],
            ),
          ),
          Center(
            child: BRButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Write to tag",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                if (recordController?.text != null)
                  _ndefWrite(recordController!.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}

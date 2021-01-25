import 'package:flutter/material.dart';
import 'package:bestrun/utils/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class BestRunAlertDialog extends StatelessWidget {
  BestRunAlertDialog(this.message);

  final String message;

  final Color primaryColor = globals.primaryColor;
  final Color bestRunGreen = globals.bestRunGreen;
  final Color defaultTextColor = Colors.white;
  final String okButtonText = 'common.okButtonText'.tr();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Color(0xFF292929), width: 1.0)),
      backgroundColor: Theme.of(context).primaryColor,
      actionsPadding: EdgeInsets.only(right: 10.0),
      title: Text(
        'errors.error'.tr(),
        style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.headline5.fontSize),
      ),
      content: Text(this.message, style: TextStyle(color: Colors.white)),
      actions: [
        RaisedButton(
          padding: EdgeInsets.only(right: 12.0, left: 5.0),
          color: this.bestRunGreen,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(
                Icons.keyboard_arrow_right,
                color: this.defaultTextColor,
              ),
              Text(
                this.okButtonText,
                style: TextStyle(
                  color: this.defaultTextColor,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

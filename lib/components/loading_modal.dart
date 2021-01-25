import 'package:flutter/material.dart';
import 'package:bestrun/utils/globals.dart' as globals;

class LoadingModal {
  static show(BuildContext context) {
    const Color loadingCircleColor = globals.bestRunGreen;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Theme(
                data:
                    Theme.of(context).copyWith(accentColor: loadingCircleColor),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        );
      },
    );
  }

  static hide(BuildContext context) {
    Navigator.pop(context);
  }
}

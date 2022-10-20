import 'package:bestrun/components/br_button.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

class BRPopUpDialogs {
  static bool isDialogOpen = false;
  static EdgeInsets insetPadding = const EdgeInsets.all(20.0);

  /// Opens an error alert dialog , one button with "back" text and
  /// [message] as the content text.
  static Future<bool> openAlertDialog({
    required BuildContext context,
    required String message,
    double? height,
  }) async {
    BRPopUpDialogs.isDialogOpen = true;

    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: const BorderSide(color: Colors.transparent, width: 1.0)),
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.all(0.0),
            insetPadding: insetPadding,
            content: SizedBox(
              height: height ?? 250.0,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            height: 26.0,
                            width: 40.0,
                            child: const Image(
                              image: AssetImage('assets/images/X_close.png'),
                              height: 15.0,
                              width: 15.0,
                            ),
                          ),
                          onTap: () => Navigator.pop(context, false),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Transform.scale(
                      scale: 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BRButton.backButton(context: context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    BRPopUpDialogs.isDialogOpen = false;
    if (result != null) {
      return result;
    } else {
      return false;
    }
  }

  static Future<bool> openDialog({
    required BuildContext context,
    required Widget content,
    required List<Widget> actionButtons,
    double? height,
    bool scrollable = false,
    Function? beforeCancel,
  }) async {
    BRPopUpDialogs.isDialogOpen = true;

    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: scrollable,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: const BorderSide(color: Colors.transparent, width: 1.0)),
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.all(0.0),
            insetPadding: insetPadding,
            content: SizedBox(
              height: height ?? 250.0,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: InkWell(
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  height: 26.0,
                                  width: 40.0,
                                  child: const Image(
                                    image:
                                        AssetImage('assets/images/X_close.png'),
                                    height: 15.0,
                                    width: 15.0,
                                  ),
                                ),
                                onTap: () {
                                  if (beforeCancel != null) beforeCancel();
                                  Navigator.pop(context, false);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  content,
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 14.0, left: 14.0, right: 14.0),
                    child: Transform.scale(
                      scale: 0.9,
                      child: Row(
                        mainAxisAlignment: actionButtons.length == 1
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: actionButtons,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    BRPopUpDialogs.isDialogOpen = false;
    if (result != null) {
      return result;
    } else {
      return false;
    }
  }

  static Future<void> openErrorDialog({
    required BuildContext context,
    required String message,
    double? height,
    bool scrollable = false,
  }) async {
    BRPopUpDialogs.isDialogOpen = true;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: scrollable,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: const BorderSide(color: Colors.transparent, width: 1.0)),
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.all(0.0),
            insetPadding: insetPadding,
            content: SizedBox(
              height: height ?? 280.0,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: InkWell(
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  height: 26.0,
                                  width: 40.0,
                                  child: const Image(
                                    image:
                                        AssetImage('assets/images/X_close.png'),
                                    height: 15.0,
                                    width: 15.0,
                                  ),
                                ),
                                onTap: () => Navigator.pop(context, false),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            'server.errorTitle'.tr().toUpperCase(),
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: Transform.scale(
                      scale: 0.9,
                      child: Center(
                        child: BRButton(
                          child: Text(
                            'OK'.tr().toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    BRPopUpDialogs.isDialogOpen = false;
  }

  static Future<bool> openConfirmDialog({
    required BuildContext context,
    required String message,
    double? height,
    bool scrollable = false,
  }) async {
    BRPopUpDialogs.isDialogOpen = true;
    var result = await BRPopUpDialogs.openDialog(
      context: context,
      height: height,
      scrollable: scrollable,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15.0),
        ),
      ),
      actionButtons: [
        BRButton.cancelButton(context: context),
        BRButton(
          child: Text(
            'OK'.tr().toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
    BRPopUpDialogs.isDialogOpen = false;
    return result;
  }

  static Future<bool> openLoadingDialog({
    required BuildContext context,
    required String message,
    double? height,
  }) async {
    BRPopUpDialogs.isDialogOpen = true;

    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: const BorderSide(color: Colors.transparent, width: 1.0)),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(0.0),
          insetPadding: insetPadding,
          content: SizedBox(
            height: height ?? 250.0,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    BRPopUpDialogs.isDialogOpen = false;
    if (result != null) {
      return result;
    } else {
      return false;
    }
  }
}

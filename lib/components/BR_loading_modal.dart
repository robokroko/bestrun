import 'package:flutter/material.dart';

class BRLoadingDialog {
  static bool isShown = false;

  /// Opens a loading dialog with [title] if it is not already opened.
  /// Use BRLoadingDialog.hide() to dismiss it.
  static void show({required BuildContext context, required String title}) {
    if (!BRLoadingDialog.isShown) {
      final Color loadingCircleColor = Colors.amber;
      const Color barrierColor = Colors.black54;
      const Color headerBackgroundColor = Color(0xFFE7EDF4);
      const Color dividerColor = Color(0xFFF4F7FA);

      BRLoadingDialog.isShown = true;

      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: barrierColor,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            content: SizedBox(
              height: 120.0,
              width: 120.0,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: headerBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        )),
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 13.0, bottom: 8.0),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .fontSize,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 7.0,
                          color: dividerColor,
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                loadingCircleColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  static void hide(BuildContext context) {
    if (BRLoadingDialog.isShown) {
      Navigator.pop(context, false);
      BRLoadingDialog.isShown = false;
    }
  }

  static void hideWithNavigator(NavigatorState navigatorState) {
    if (BRLoadingDialog.isShown) {
      navigatorState.pop(false);
      BRLoadingDialog.isShown = false;
    }
  }
}

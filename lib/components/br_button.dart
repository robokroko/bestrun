import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BRButton extends StatefulWidget {
  const BRButton({
    Key? key,
    this.child,
    this.borderColor,
    this.backgroundColor,
    this.onPressed,
    this.isEnabled = true,
    this.width,
    this.height,
    this.elevation = 3.0,
    this.contentPadding,
    this.padding,
    this.shadowColor,
  }) : super(key: key);

  final Widget? child;
  final Color? borderColor;
  final Color? shadowColor;
  final Color? backgroundColor;
  final Function? onPressed;
  final bool isEnabled;
  final double? width;
  final double? height;
  final double? elevation;
  final EdgeInsets? contentPadding;
  final EdgeInsets? padding;

  /// Creates a Button with white color, cancel text and runs [onPressed] on tap.
  /// If [onPressed] is not given navigates back on tap.
  factory BRButton.cancelButton(
      {required BuildContext context, Function? beforeCancel}) {
    return BRButton(
      child: Text(
        'Cancel'.tr().toUpperCase(),
        style: const TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        if (beforeCancel != null) beforeCancel();
        Navigator.pop(context, false);
      },
      borderColor: Colors.grey,
      backgroundColor: Colors.grey,
      elevation: 0.0,
    );
  }

  /// Creates a BRButton with white color, back text and navigates back on press.
  factory BRButton.backButton(
      {required BuildContext context, Function? beforeCancel}) {
    return BRButton(
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.arrow_back_sharp, color: Colors.black),
          ),
          Text(
            'Back'.tr().toUpperCase(),
            style: const TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onPressed: () {
        if (beforeCancel != null) beforeCancel();
        Navigator.pop(context, false);
      },
      borderColor: Colors.grey,
      backgroundColor: Colors.grey,
      elevation: 3.0,
    );
  }

  /// Creates a BRButton with green color, next text and [onPressed] on tap.
  factory BRButton.nextButton({required Function onPressed}) {
    return BRButton(
      shadowColor: const Color.fromRGBO(10, 196, 112, 0.30),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Next'.tr().toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.arrow_forward_sharp, color: Colors.white),
          ),
        ],
      ),
      onPressed: onPressed,
      backgroundColor: Colors.amber,
      elevation: 3.0,
    );
  }

  @override
  _BRButtonState createState() => _BRButtonState();
}

class _BRButtonState extends State<BRButton> {
  Color disabledColor = Colors.grey;
  bool _isTappable = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(0.5),
        ),
      ),
      child: MaterialButton(
        child: widget.child,
        padding: widget.padding ??
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        minWidth: widget.width ?? 135.0,
        height: widget.height ?? 55.0,
        color: widget.backgroundColor ?? Colors.amber,
        disabledTextColor: disabledColor,
        elevation: widget.elevation,
        textColor: Colors.white,
        splashColor: widget.backgroundColor != null
            ? Theme.of(context).colorScheme.primary
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: BorderSide(
              width: 1.0,
              color: widget.isEnabled
                  ? (widget.borderColor ??
                      Theme.of(context).colorScheme.primary)
                  : disabledColor),
        ),
        onPressed: widget.isEnabled
            ? () {
                if (_isTappable) {
                  _isTappable = false;
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      widget.onPressed!();
                      _isTappable = true;
                    });
                  });
                }
              }
            : null,
      ),
    );
  }
}

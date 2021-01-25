import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  BackgroundContainer(
      {@required this.imagePath, this.child, this.boxFit = BoxFit.fill});

  final String imagePath;
  final Widget child;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(this.imagePath),
          fit: this.boxFit,
        ),
      ),
      child: this.child,
    );
  }
}

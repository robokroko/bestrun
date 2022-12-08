import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  BackgroundContainer({
    required this.imagePath,
    required this.child,
  });

  final String imagePath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(this.imagePath),
          fit: BoxFit.fill,
        ),
      ),
      child: this.child,
    );
  }
}

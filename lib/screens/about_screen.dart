import 'package:flutter/material.dart';
import 'package:bestrun/utils/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen({Key? key}) : super(key: key);

  final String versionTitle = 'about.version'.tr();
  final String screenTitle = 'menu.about'.tr();
  final String versionNumber = '1.0.0';
  final String imagePath = 'assets/images/logo.png';
  final TextStyle aboutTextStyle = globals.menuTextStyle;
  final TextStyle screenTextStyle = globals.titleTextStyle;

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(
                this.widget.screenTitle,
                style: this.widget.screenTextStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: SizedBox(
                width: 150.0,
                height: 150.0,
                child: Image(
                  image: AssetImage(this.widget.imagePath),
                ),
              ),
            ),
            Center(
              child: Text(
                this.widget.versionTitle,
                style: this.widget.aboutTextStyle,
              ),
            ),
            Center(
              child: Text(
                this.widget.versionNumber,
                style: this.widget.aboutTextStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}

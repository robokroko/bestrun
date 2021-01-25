import 'dart:io';
import 'package:bestrun/components/background_container.dart';
import 'package:bestrun/components/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bestrun/components/form.dart';
import 'package:bestrun/utils/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  final String title = 'login.title'.tr();
  final String imagePath = 'assets/images/logo.png';
  final TextStyle titleTextStyle = globals.loginTitleTextStyle;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundContainer(
          imagePath: 'assets/images/runner_back.jpg',
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: 80.0, left: 80.0, bottom: 60.0),
                      child: Image(
                        image: AssetImage(this.widget.imagePath),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    BabilonForm(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:bestrun/screens/activity_screen.dart';
import 'package:bestrun/screens/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'screens/activity_screen.dart';
import 'screens/about_screen.dart';
import 'screens/myActivity_screen.dart';
import 'screens/tagwrite_screen.dart';

void main() {
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('hu')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.grey[900],
        fontFamily: 'NotoSans',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        '/activity': (BuildContext context) => ActivityScreen(),
        '/login': (BuildContext context) => LoginScreen(),
        '/about': (BuildContext context) => AboutScreen(),
        '/myActivity': (BuildContext context) => MyActivityScreen(),
        '/profile': (BuildContext context) => AboutScreen(),
        '/tagwrite': (BuildContext context) => TagWriteScreen(),
      },
      home: LoginScreen(),
    );
  }
}

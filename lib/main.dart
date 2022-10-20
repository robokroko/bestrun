import 'package:bestrun/firebase_options.dart';
import 'package:bestrun/screens/activity_screen.dart';
import 'package:bestrun/screens/login_screen.dart';
import 'package:bestrun/utils/authentication.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/about_screen.dart';
import 'screens/my_activity_screen.dart';
import 'screens/tagwrite_screen.dart';
import 'screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('hu')],
      path: 'assets/translations',
      fallbackLocale: Locale('hu'),
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
        fontFamily: 'NotoSans',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        '/activity': (BuildContext context) => ActivityScreen(),
        '/login': (BuildContext context) => LoginScreen(),
        '/about': (BuildContext context) => AboutScreen(),
        '/myActivity': (BuildContext context) => MyActivityScreen(),
        '/profile': (BuildContext context) => UserProfileScreen(),
        '/tagwrite': (BuildContext context) => TagWriteScreen(),
      },
      home: WidgetTree(),
    );
  }
}

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Authentication().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Valami eltört..'));
        } else if (snapshot.hasData) {
          return ActivityScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Valami eltört..'));
            } else if (snapshot.hasData) {
              return ActivityScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
      );
}

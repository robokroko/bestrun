import 'package:bestrun/components/background_container.dart';
import 'package:bestrun/components/br_button.dart';
import 'package:bestrun/components/BR_loading_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();

  @override
  void initState() {
    usernameInputController.text = 'user';
    passwordInputController.text = 'password';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BackgroundContainer(
          imagePath: 'assets/images/runner_back.jpg',
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'login.usernameLabelNew'.tr(),
                          style: const TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(6.0),
                        child: TextFormField(
                          controller: usernameInputController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 0.6,
                                  style: BorderStyle.solid),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 0.6,
                                  style: BorderStyle.solid),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 0.5,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'login.passwordLabelNew'.tr(),
                          style: const TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(6.0),
                        child: TextFormField(
                          controller: passwordInputController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 0.6,
                                  style: BorderStyle.solid),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 0.6,
                                  style: BorderStyle.solid),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 0.5,
                                  style: BorderStyle.solid),
                            ),
                          ),
                          cursorColor: Colors.black,
                          obscureText: true,
                          textInputAction: TextInputAction.go,
                          onEditingComplete: _login,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 30.0, top: 15.0, left: 30.0, right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BRButton(
                        shadowColor: const Color.fromRGBO(10, 196, 112, 0.25),
                        elevation: 0,
                        child: Text(
                          'login.loginBtn'.tr().toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: _login,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    BRLoadingDialog.show(context: context, title: 'betöltés');
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameInputController.text.trim(),
          password: passwordInputController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    BRLoadingDialog.hide(context);
    Navigator.pushReplacementNamed(context, '/activity');
  }

  @override
  void dispose() {
    usernameInputController.dispose();
    passwordInputController.dispose();
    super.dispose();
  }
}

/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works/components/av_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:works/components/av_popup_dialogs.dart';
import 'package:works/models/av_exception.dart';
import 'package:works/screens/main_screen.dart';
import 'package:works/utils/api_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();

  @override
  void initState() {
    if (!kReleaseMode) {
      usernameInputController.text = 'csihakft';
      passwordInputController.text = 'csihakft';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F5),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Column(
                  children: const [
                    Image(image: AssetImage('assets/images/runner_back.jpg')),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                        width: 150.0,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'login.usernameLabelNew'.tr(),
                              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.circular(6.0),
                            child: TextFormField(
                              controller: usernameInputController,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide:
                                      const BorderSide(color: Colors.black, width: 0.6, style: BorderStyle.solid),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide:
                                      const BorderSide(color: Colors.black, width: 0.6, style: BorderStyle.solid),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 0.5,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'login.passwordLabelNew'.tr(),
                              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Material(
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(6.0),
                            child: TextFormField(
                              controller: passwordInputController,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide:
                                      const BorderSide(color: Colors.black, width: 0.6, style: BorderStyle.solid),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide:
                                      const BorderSide(color: Colors.black, width: 0.6, style: BorderStyle.solid),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 0.5,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              cursorColor: Colors.black,
                              obscureText: true,
                              textInputAction: TextInputAction.go,
                              onEditingComplete: _login,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AVButton.backButton(
                            context: context,
                          ),
                          AVButton(
                            shadowColor: const Color.fromRGBO(10, 196, 112, 0.25),
                            elevation: 0,
                            child: Text(
                              'login.loginBtn'.tr().toUpperCase(),
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                            onPressed: _login,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    AVPopUpDialogs.openLoadingDialog(context: context, message: 'server.loadingLogin'.tr());
    try {
      await Provider.of<ApiProvider>(context, listen: false)
          .login(usernameInputController.text, passwordInputController.text);
      AVPopUpDialogs.hideDialog(context);
      Navigator.pushNamed(context, MainScreen.routeName);
    } on AVException catch (e) {
      AVPopUpDialogs.hideDialog(context);
      await AVPopUpDialogs.openErrorDialog(context: context, message: e.message);
      if (e.code != null && e.code == 1004) {
        await Provider.of<ApiProvider>(context, listen: false).clearAuth();
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      AVPopUpDialogs.hideDialog(context);
      AVPopUpDialogs.openErrorDialog(context: context, message: 'server.unknownError'.tr());
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    usernameInputController.dispose();
    passwordInputController.dispose();
    super.dispose();
  }
}


*/

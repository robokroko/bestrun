import 'package:bestrun/components/background_container.dart';
import 'package:bestrun/components/br_button.dart';
import 'package:bestrun/components/BR_loading_modal.dart';
import 'package:bestrun/components/br_popup_dialogs.dart';
import 'package:bestrun/utils/authentication.dart';
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
  final TextEditingController password2InputController =
      TextEditingController();
  bool isLogin = true;

  @override
  void initState() {
    usernameInputController.text = 'robokroko@gmail.com';
    passwordInputController.text = 'rb1234';
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Email'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
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
                          'Password'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLogin == false)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Password again'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      if (isLogin == false)
                        Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(6.0),
                          child: TextFormField(
                            controller: password2InputController,
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(
                    isLogin
                        ? 'Registration'.tr().toUpperCase()
                        : 'Login'.tr().toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                    ),
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
                            'Login'.tr().toUpperCase(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (isLogin) {
                              _login();
                            } else {
                              createUserWithEmailAndPassword();
                            }
                          }),
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
    try {
      BRLoadingDialog.show(context: context, title: 'Loadings');
      await Authentication().signInWithEmailAndPassword(
          email: usernameInputController.text,
          password: passwordInputController.text);
    } on FirebaseAuthException catch (e) {
      BRLoadingDialog.hide(context);
      BRPopUpDialogs.openConfirmDialog(
          context: context,
          message: e.message! /*getFirestoreErrorMessage(e.code)*/);
      print(e);
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (passwordInputController.text != password2InputController.text) {
      BRPopUpDialogs.openConfirmDialog(
          context: context, message: 'A megadott két jelszó nem egyezik!');
    } else {
      try {
        BRLoadingDialog.show(context: context, title: 'betöltés');
        await Authentication().createUserWithEmailAndPassword(
          email: usernameInputController.text,
          password: passwordInputController.text,
        );
      } on FirebaseAuthException catch (e) {
        BRLoadingDialog.hide(context);
        BRPopUpDialogs.openConfirmDialog(
            context: context,
            message: e.message! /*getFirestoreErrorMessage(e.code)*/);
        print(e);
      }
    }
  }

  String getFirestoreErrorMessage(String error) {
    String errorMessage;
    switch (error) {
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Anonymous accounts are not enabled";
        break;
      case "ERROR_WEAK_PASSWORD":
        errorMessage = "Your password is too weak";
        break;
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email is invalid";
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        errorMessage = "Email is already in use on different account";
        break;
      case "ERROR_INVALID_CREDENTIAL":
        errorMessage = "Your email is invalid";
        break;
      case "wrong-password":
        errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;

      default:
        errorMessage = "An undefined Error happened.";
    }
    return errorMessage;
  }
}

/*l
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
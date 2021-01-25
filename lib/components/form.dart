import 'package:flutter/material.dart';
import 'package:bestrun/utils/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class BabilonForm extends StatefulWidget {
  BabilonForm({this.onPressed});

  final Function onPressed;

  @override
  BabilonFormState createState() {
    return BabilonFormState();
  }
}

class BabilonFormState extends State<BabilonForm> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final FocusNode form1Focus = FocusNode();
  final FocusNode form2Focus = FocusNode();
  final String formTitle1 = 'login.username'.tr();
  final String formTitle2 = 'login.password'.tr();
  final String formAlertText1 = 'login.requiredFieldError'.tr();
  final String formAlertText2 = 'login.requiredFieldError'.tr();
  final String formButtonText = 'login.login'.tr();
  final TextStyle formTextStyle = globals.formTextStyle;

  final form1Controller = TextEditingController();
  final form2Controller = TextEditingController();

  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 600.0,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 40.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  this.formTitle1,
                  style: this.formTextStyle,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: Container(
              height: 50.0,
              child: Form(
                key: formKey1,
                child: TextFormField(
                  controller: this.form1Controller,
                  validator: (value) {
                    if (value.isEmpty) {
                      return formAlertText1;
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: globals.unreadMessageWhiteTextColor,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(
                          width: 0.4,
                          color: globals.unreadMessageGreyTextColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide:
                          BorderSide(width: 0.4, color: globals.bestRunGreen),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide:
                          BorderSide(width: 0.4, color: globals.bestRunGreen),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: form1Focus,
                  onFieldSubmitted: (term) {
                    fieldFocusChange(context, form1Focus, form2Focus);
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 40.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  this.formTitle2,
                  style: this.formTextStyle,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0),
            child: Container(
              height: 50.0,
              child: Form(
                key: formKey2,
                child: TextFormField(
                  controller: this.form2Controller,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return formAlertText2;
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: globals.unreadMessageWhiteTextColor,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(
                          width: 0.4,
                          color: globals.unreadMessageGreyTextColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide:
                          BorderSide(width: 0.4, color: globals.bestRunGreen),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide:
                          BorderSide(width: 0.4, color: globals.bestRunGreen),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  focusNode: form2Focus,
                  onFieldSubmitted: (value) {
                    form2Focus.unfocus();
                    if (formKey1.currentState.validate() &&
                        formKey2.currentState.validate()) {
                      this.widget.onPressed(
                          this.form1Controller.text, this.form2Controller.text);
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Container(
              width: 160.0,
              height: 55.0,
              child: RaisedButton(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        formButtonText,
                        style: TextStyle(
                          fontSize: 20,
                          color: globals.primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
                color: globals.bestRunGreen,
                textColor: globals.unreadMessageWhiteTextColor,
                onPressed: () {
                  if (formKey1.currentState.validate() &&
                      formKey2.currentState.validate()) {
                    goToRunActivity();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  goToRunActivity() {
    Navigator.pushReplacementNamed(context, '/activity');
  }
}

import 'package:bestrun/utils/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bestrun/utils/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  final TextStyle menuHeaderTextStyle = globals.menuHeaderTextStyle;
  final TextStyle menuHeaderUnderTextStyle = globals.menuHeaderUnderTextStyle;
  final TextStyle menuTextStyle = globals.menuTextStyle;

  final String imagePathMember = 'assets/images/person.png';
  final Color languageTrailingIconColor = Colors.white;
  final Color defaultTextColor = Colors.white;
  final Color selectedLangBackgroundColor = Colors.amber;
  final Color splashColor = Colors.amber;
  final User? user = Authentication().currentUser;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Drawer(
        child: Container(
          color: globals.primaryColor,
          child: Column(
            children: <Widget>[
              Container(
                height: 120,
                child: DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: 80.0,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.amber, width: 2.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                            height: 25.0,
                            width: 25.0,
                            child: Image(
                              image: AssetImage(this.widget.imagePathMember),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    this.widget.user!.email!,
                                    style: this.widget.menuHeaderTextStyle,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  this.widget.user!.email!,
                                  style: this.widget.menuHeaderUnderTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.amber,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor:
                              this.widget.languageTrailingIconColor,
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Activities',
                                style: this.widget.menuTextStyle,
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 14.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: this.goToMyActivityScreen,
                  ),
                ),
              ),
              ListTile(
                title: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.amber,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor:
                              this.widget.languageTrailingIconColor,
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Write to tag',
                                style: this.widget.menuTextStyle,
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 14.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: this.goToTagWriteScreen,
                  ),
                ),
              ),
              ListTile(
                title: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.amber,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor:
                              this.widget.languageTrailingIconColor,
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                'About',
                                style: this.widget.menuTextStyle,
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 14.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: this.goToAboutScreen,
                  ),
                ),
              ),
              Spacer(),
              ListTile(
                title: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.amber,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor:
                              this.widget.languageTrailingIconColor,
                        ),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(
                                'Log out',
                                style: this.widget.menuTextStyle,
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 14.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () => signOut(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getSupportedLocales(BuildContext context) {
    List<Widget> list = [];
    context.supportedLocales.forEach((locale) {
      list.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: this.widget.splashColor,
            child: ListTileTheme(
              selectedTileColor: this.widget.selectedLangBackgroundColor,
              child: ListTile(
                title: Center(
                  child: Text(
                    ('menu.' + locale.languageCode).tr(),
                    style: TextStyle(color: this.widget.defaultTextColor),
                  ),
                ),
                selected: context.locale == locale,
              ),
            ),
            onTap: () {
              Future.delayed(Duration(milliseconds: 150), () {
                context.locale = locale;
              });
            },
          ),
        ),
      );
    });
    return list;
  }

  Future<void> signOut() async {
    await Authentication().signOut();
  }

  void goToAboutScreen() {
    Navigator.pushNamed(context, '/about');
  }

  void goToMyActivityScreen() {
    Navigator.pushNamed(context, '/myActivity');
  }

  void goToTagWriteScreen() {
    Navigator.pushNamed(context, '/tagwrite');
  }
}

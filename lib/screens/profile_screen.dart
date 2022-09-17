import 'package:flutter/material.dart';
import 'package:bestrun/models/profile_model.dart';
import 'package:bestrun/utils/globals.dart' as globals;

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Profile? profile;

  @override
  void initState() {
    //profile = Globals.profiles[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 750),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                SlideTransition(
              child: child,
              position:
                  Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                      .animate(animation),
            ),
            child: HeaderSection(
              profile: profile!,
            ),
          ),
          SizedBox(height: 40),
          Container(
            child: Wrap(
              children: <Widget>[
                for (int i = 0; i < globals.ProfileData.profiles.length; i++)
                  GestureDetector(
                    onTap: () {
                      profile = globals.ProfileData.profiles[i];
                      setState(() {});
                    },
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final Profile? profile;
  HeaderSection({
    this.profile,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: Text(
              this.profile?.name ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Text(
              this.profile?.email ?? '',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

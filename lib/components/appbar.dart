import 'package:flutter/material.dart';
import 'package:bestrun/utils/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class BestRunAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color _backgroundColor = globals.appbarColor;
  final String _appBarTitle = 'title'.tr();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: this._backgroundColor,
      centerTitle: true,
      title: Container(
        child: Text(
          this._appBarTitle,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40.0);
}

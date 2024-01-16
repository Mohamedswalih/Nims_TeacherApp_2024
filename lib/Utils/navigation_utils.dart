import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationUtils {
  static Future<dynamic> goNext(BuildContext context, Widget screen,
      {bool isFinish = false}) async {
    if (isFinish) {
      return await Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => screen));
    } else {
      return await Navigator.push(
          context, CupertinoPageRoute(builder: (context) => screen));
    }
  }

  static goNextFinishAll(
      BuildContext context,
      Widget screen,
      ) {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => screen),
            (Route<dynamic> route) => false);
  }

  static goBack(BuildContext context, {dynamic data}) {
    Navigator.pop(context, data);
  }
}
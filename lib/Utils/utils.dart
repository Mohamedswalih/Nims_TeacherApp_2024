import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'color_utils.dart';

class Utils{
  static  getWidth(double width) {
    return width.w;
  }

  static  getHeight(double height) {
    return height.h;
  }

  static  getFontSize(double size) {
    return size.sp;
  }
  static void call(String number) {
    UrlLauncher.launch('tel:+$number');
  }
  static Flushbar showToastError(String message) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 2),
      backgroundColor: ColorUtils.RED_DARK,
      borderRadius: BorderRadius.circular(5.r),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ColorUtils.WHITE,
          fontFamily: "mont",
        ),
      ),
      padding: EdgeInsets.symmetric(
          vertical: 20.h, horizontal: 20.w),
      forwardAnimationCurve: Curves.linear,
      message: message,
    );
  }

  static showToastSuccess(String message) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 3),
      backgroundColor: ColorUtils.GREEN_DARK,
      borderRadius: BorderRadius.circular(5.r),
      margin: EdgeInsets.symmetric(horizontal: 10),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ColorUtils.WHITE,
          fontFamily: "mont",
        ),
      ),
      padding: EdgeInsets.symmetric(
          vertical: 30.h, horizontal: 20.w),
      forwardAnimationCurve: Curves.linear,
      message: message,
    );
  }

}
SizedBox verticalSpace(double space) => SizedBox(
  height: space,
);

SizedBox horizontalSpace(double space) => SizedBox(
  width: space,
);

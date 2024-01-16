
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/utils.dart';
import '../LoginPage/google_signin_api.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final forgotPasswordController = TextEditingController();

  bool spinner = false;

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue : Colors.lightBlueAccent,
        ),
      );
    },
  );

  submitForgotRequest() async {
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.FORGOT_PASSWORD));
    request.body =
        '''{\n    "username": "${forgotPasswordController.text.toString()}"\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Utils.showToastSuccess(
              "We have emailed you the instructions to reset the password")
          .show(context);
      setState(() {
        spinner = false;
        forgotPasswordController.clear();
      });
    } else {
      print(response.reasonPhrase);
      Utils.showToastError("This Email Id is not registered").show(context);
      setState(() {
        spinner = false;
      });
    }
  }

  final spinkitNew = SpinKitWave(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
          decoration: BoxDecoration(
        color: index.isEven ? Colors.blue : Colors.lightBlueAccent,
      ));
    },
  );

  @override
  void initState() {
    super.initState();
    // _progressDialog = ProgressDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorUtils.BACKGROUND,
        body: ListView(
          children: [
            Stack(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/images/header.png",
                      fit: BoxFit.fill,
                    )),
                Container(
                  margin: EdgeInsets.only(left: 30.w, top: 100.h, right: 30.w),
                  width: 500.w,
                  height: 650.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.r))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // width: 200.w,
                        // height: 200.h,
                        margin: EdgeInsets.only(top: 60.h, bottom: 10.h),
                        child: Center(
                            child: Lottie.asset("assets/images/forgot.json")),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 38.w),
                            child: Text("Forgot",
                                style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorUtils.BLACK_GREY,
                                    fontFamily: "WorkSans")),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 38.w),
                            child: Text("Password",
                                style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorUtils.BLACK_GREY,
                                    fontFamily: "WorkSans")),
                          ),
                        ],
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(top: 20.h, left: 38.w, bottom: 5.h),
                        child: Text(
                          "Enter Your Email ID",
                          style: TextStyle(
                              color: ColorUtils.TEXT_COLOR, fontSize: 11.sp),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 38.w, right: 30.w),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.h, vertical: 5.w),
                          child: TextFormField(
                            controller: forgotPasswordController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: spinner
                              ? Container(
                                  margin: EdgeInsets.only(top: 100.h),
                                  child: Center(child: spinkitNew))
                              : GestureDetector(
                                  onTap: () {
                                    print("button pressed");
                                    if (forgotPasswordController.text
                                        .toString()
                                        .isEmpty) {
                                      print("empty");
                                      Utils.showToastError(
                                              "Please fill the username to continue")
                                          .show(context);
                                    } else {
                                      print("submit");
                                      setState(() {
                                        spinner = true;
                                      });
                                      submitForgotRequest();
                                    }
                                  },
                                  child: Container(
                                      width: 287.w,
                                      height: 48.h,
                                      margin: EdgeInsets.only(top: 100.h),
                                      child: Image.asset(
                                          "assets/images/submitbutton.png")))),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  _checkInternet(context) {
    return Alert(
      onWillPopActive: true,
      context: context,
      type: AlertType.warning,
      title: "Please Check Your Internet Connection",
      style: AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          // print(widget.academicyear);
          //width: 120,
        )
      ],
    ).show();
  }

  _submitFailed(context) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "Invalid Username/password! Please try Again",
      style: AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          child: Text(
            "Try again",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.pop(context);
            await GoogleSignInApi.logout();
          },
          // print(widget.academicyear);
          //width: 120,
        )
      ],
    ).show();
  }
}

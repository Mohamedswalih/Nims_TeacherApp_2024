import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import '../../Database/time_table_database_helper.dart';
import '../../Network/api_constants.dart';
import '../../Notification/notification.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/utils.dart';
import '../LoginPage/login.dart';

class HistoryOfStudentActivity extends StatefulWidget {
  String? studentName;
  String? parentName;
  String? mobileNumber;
  String? classOfStudent;
  String? loginUserName;
  String? studentFees;
  String? admissionNumber;
  String? logedinEmployeecode;
  String? loginTeacherName;
  String? TeacherProfile;
  String? StudentImage;
  String? motherName;
  String? motherPhone;

  HistoryOfStudentActivity(
      {this.parentName,
      this.studentName,
      this.classOfStudent,
      this.mobileNumber,
      this.loginUserName,
      this.studentFees,
      this.admissionNumber,
      this.logedinEmployeecode,
      this.loginTeacherName,
      this.TeacherProfile,
      this.StudentImage,
      this.motherPhone,
      this.motherName});

  @override
  _HistoryOfStudentActivityState createState() =>
      _HistoryOfStudentActivityState();
}

class _HistoryOfStudentActivityState extends State<HistoryOfStudentActivity> {
  Map<String, dynamic>? studentFeebackList;

  List newList = [];
  List reversedFeedbackList = [];

  studentActivities() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_token = preferences.getString("school_token");
    var headers = {
      'API-Key': '525-777-777',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.DOCME_URL));
    request.body = json.encode({
      "action": "getStudentFeedbackData",
      "token": school_token,
      "admn_no": "${widget.admissionNumber}"
    });
    log("studentActivitiesrequest.body-----${request.body}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var responseJson = await response.stream.bytesToString();
      setState(() {
        studentFeebackList = json.decode(responseJson);
      });

      getString() {
        if (studentFeebackList!.containsKey("data_status") == 1) {
          print("shshshshsh");
          for (var index = 0;
              index < studentFeebackList!["data"].length;
              index++) {
            if (studentFeebackList!["data"][index]["Feeback_type"] == 1) {
              return "Committed Date";
            } else if (studentFeebackList!["data"][index]["Feeback_type"] ==
                    2 ||
                studentFeebackList!["data"][index]["Feeback_type"] == 3) {
              return "Wrong or Invalid";
            } else if (studentFeebackList!["data"][index]["Feeback_type"] ==
                4) {
              return "Call Not Answered";
            } else if (studentFeebackList!["data"][index]["Feeback_type"] ==
                    5 ||
                studentFeebackList!["data"][index]["Feeback_type"] == 6 ||
                studentFeebackList!["data"][index]["Feeback_type"] == 7) {
              return "Misbehavior";
            }
          }
        }
        return "";
      }

      log("the reveresed list is $studentFeebackList");
      newList.add(studentFeebackList!["data"]);

      setState(() {
        reversedFeedbackList = newList[0].reversed.toList();
      });

      print(request.body);
      log("the reveresed list is $reversedFeedbackList");
    } else {
      print(response.reasonPhrase);
    }
  }

  Map<String, dynamic>? notificationResult;
  int Count = 0;

  getNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');

    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${ApiConstants.Notification}$userID${ApiConstants.NotificationEnd}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var responseJson = await response.stream.bytesToString();
      setState(() {
        notificationResult = json.decode(responseJson);
      });

      for (var index = 0;
          index <
              notificationResult!["data"]["details"]["recentNotifications"]
                  .length;
          index++) {
        if (notificationResult!["data"]["details"]["recentNotifications"][index]
                ["status"] ==
            "active") {
          Count += 1;
        }
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt("count", Count);

      print(Count);
    } else {
      print(response.reasonPhrase);
    }
  }

  var count;

  getCount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      count = preferences.get("count");
    });
  }

  Timer? timer;

  @override
  void initState() {
    studentActivities();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    print(">>>>studentFeesstudentFees>>>>>>widgetwidget>>>>>>>>>${widget.studentFees}");
    print(">>>>loginTeacherName>>>>>>>>>${widget.loginTeacherName}");
    getNotification();
    //print(getString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.BACKGROUND,
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Stack(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/images/header.png",
                    fit: BoxFit.fill,
                  )),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => NavigationUtils.goBack(context),
                    child: Container(
                        margin: const EdgeInsets.all(6),
                        child: Image.asset("assets/images/goback.png")),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Hello,",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 15.sp,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          width: 150.w,
                          height: 40.h,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              widget.loginUserName.toString(),
                              style: TextStyle(
                                  fontFamily: "WorkSans",
                                  fontSize: 15.sp,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  GestureDetector(
                    onTap: () => NavigationUtils.goNext(
                        context,
                        NotificationPage(
                          name: widget.loginUserName,
                          image: widget.TeacherProfile,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: badges.Badge(
                          position: badges.BadgePosition.bottomEnd(end: -7, bottom: 12),
                          badgeContent: count == null
                              ? Text("")
                              : Text(
                                  count.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                          child: SvgPicture.asset("assets/images/bell.svg")),
                    ),
                  ),
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFD6E4FA)),
                      image: DecorationImage(
                          image: NetworkImage(widget.TeacherProfile == ""
                              ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                              : ApiConstants.IMAGE_BASE_URL +
                                  "${widget.TeacherProfile}"),
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                width: 500.w,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "assets/images/icon.svg",
                                color: ColorUtils.SEARCH_TEXT_COLOR,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "History",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: ColorUtils.SEARCH_TEXT_COLOR),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30.w, right: 30.w),
                      child: Column(
                        // shrinkWrap: true,
                        // scrollDirection: Axis.vertical,
                        children: [
                          SizedBox(
                            height: 25.h,
                          ),
                          Row(
                            children: [
                              widget.StudentImage == " "
                                  ? Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFEEF1FF)),
                                      child: Image.asset(
                                          "assets/images/profile.png"),
                                    )
                                  : Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                widget.StudentImage.toString()),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 200.w,
                                      child: Text(
                                          toBeginningOfSentenceCase(widget
                                                  .studentName
                                                  .toString()
                                                  .toLowerCase())
                                              .toString(),
                                          style: GoogleFonts.spaceGrotesk(
                                              textStyle: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: ColorUtils.BLACK,
                                                  fontWeight:
                                                      FontWeight.bold)))),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  (widget.studentFees) == null
                                      ? Text("")
                                      : Row(
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                "AED :",
                                                style:
                                                    TextStyle(fontSize: 14.sp),
                                              ),
                                            ),
                                            SizedBox(
                                              child: Text(
                                                widget.studentFees.toString(),
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color:
                                                        ColorUtils.MAIN_COLOR,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(
                            indent: 20,
                            endIndent: 20,
                            height: 20,
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 50.w,
                                      height: 50.h,
                                      child: SvgPicture.asset(
                                        "assets/images/profileOne.svg",
                                        color: ColorUtils.PROFILE_COLOR,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: 150.w,
                                            child: Text(
                                                widget.parentName.toString(),
                                                style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                        fontSize: 16.sp,
                                                        color: ColorUtils.BLACK,
                                                        fontWeight:
                                                            FontWeight.bold)))),
                                        SizedBox(
                                          height: 6.h,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            widget.mobileNumber.toString(),
                                            style: TextStyle(fontSize: 14.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Utils.call(
                                      widget.mobileNumber.toString()),
                                  child: Container(
                                    width: 50.w,
                                    height: 50.h,
                                    child: SvgPicture.asset(
                                      "assets/images/callButtonTwo.svg",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          widget.motherName == null
                              ? Text("")
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 50.w,
                                          height: 50.h,
                                          child: SvgPicture.asset(
                                            "assets/images/profileTwo.svg",
                                            color: ColorUtils.MAIN_COLOR,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                // width: 150.w,
                                                child: Text(
                                                    widget.motherName
                                                        .toString(),
                                                    style: GoogleFonts.roboto(
                                                        textStyle: TextStyle(
                                                            fontSize: 16.sp,
                                                            color: ColorUtils
                                                                .BLACK,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)))),
                                            SizedBox(
                                              height: 6.h,
                                            ),
                                            SizedBox(
                                              child: Text(
                                                widget.motherPhone.toString(),
                                                style:
                                                    TextStyle(fontSize: 14.sp),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () => Utils.call(
                                          widget.motherPhone.toString()),
                                      child: Container(
                                        width: 50.w,
                                        height: 50.h,
                                        child: SvgPicture.asset(
                                          "assets/images/callButtonOne.svg",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          studentFeebackList == null
                              ? CircularProgressIndicator()
                              : studentFeebackList!["data_status"] == 0
                                  ? Text("No Data")
                                  : SizedBox(
                                      height: 350.h,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              reversedFeedbackList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        reversedFeedbackList[
                                                                        index][
                                                                    "Feeback_type"] ==
                                                                1
                                                            ? "Committed Date"
                                                            : reversedFeedbackList[index]
                                                                            [
                                                                            "Feeback_type"] ==
                                                                        2 ||
                                                                    reversedFeedbackList[index]
                                                                            [
                                                                            "Feeback_type"] ==
                                                                        3
                                                                ? "Invalid or Wrong Number"
                                                                : reversedFeedbackList[index]
                                                                            [
                                                                            "Feeback_type"] ==
                                                                        4
                                                                    ? "Call Not Answered"
                                                                    : "Misbehaved",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueGrey)),
                                                    Image.asset(
                                                      reversedFeedbackList[
                                                                      index][
                                                                  "Feeback_type"] ==
                                                              1
                                                          ? "assets/images/committed.png"
                                                          : reversedFeedbackList[
                                                                              index]
                                                                          [
                                                                          "Feeback_type"] ==
                                                                      2 ||
                                                                  reversedFeedbackList[
                                                                              index]
                                                                          [
                                                                          "Feeback_type"] ==
                                                                      3
                                                              ? "assets/images/invalidcall.png"
                                                              : reversedFeedbackList[
                                                                              index]
                                                                          [
                                                                          "Feeback_type"] ==
                                                                      4
                                                                  ? "assets/images/callnotanswered.png"
                                                                  : "assets/images/mis.png",
                                                      height: 50.h,
                                                      width: 50.h,
                                                    )
                                                  ],
                                                ),
                                                // SizedBox(height: 5.h,),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  //margin: EdgeInsets.only(left: 20.w, right: 20.w),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFECF1FF),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFFCAD3FF)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.r))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Remarks",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueGrey),
                                                            ),
                                                            Text(
                                                              "${reversedFeedbackList[index]["Feeback_committed_date"]}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueGrey),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                            reversedFeedbackList[
                                                                            index]
                                                                        [
                                                                        "Feeback_type"] ==
                                                                    5
                                                                ? "Abusive Language"
                                                                : reversedFeedbackList[index]
                                                                            [
                                                                            "Feeback_type"] ==
                                                                        6
                                                                    ? "Did not agree to pay fees"
                                                                    : reversedFeedbackList[index]["Feeback_type"] ==
                                                                            7
                                                                        ? "Advised a call from higher authority"
                                                                        : "",
                                                            style: TextStyle(
                                                                color: ColorUtils
                                                                    .SEARCH_TEXT_COLOR),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: Text(
                                                              reversedFeedbackList[
                                                                      index][
                                                                  "Feeback_comment"]),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.person,
                                                                color: Color(
                                                                    0xFFA2ACDE),
                                                              ),
                                                              SizedBox(
                                                                  width: 200.w,
                                                                  child: Text(
                                                                    reversedFeedbackList[index]
                                                                            [
                                                                            "Employee_name"]
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFFA2ACDE),
                                                                        overflow:
                                                                            TextOverflow.fade),
                                                                  )),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 130.h,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _logout(context) {
    return Alert(
      context: context,
      type: AlertType.info,
      title: "Are you sure you want to logout",
      style: const AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          color: ColorUtils.BLUE,
          child: const Text(
            "yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            await TimeTableDatabase.instance.delete();
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.remove("email");
            preferences.remove('userID');
            preferences.remove('employeeNumber');
            preferences.remove('name');
            preferences.remove('designation');
            preferences.remove("classData");
            preferences.remove("employeeData");
            preferences.remove("teacherData");
            preferences.remove("school_id");
            preferences.remove("images");
            preferences.remove("teacher");
            preferences.remove("hos");
            NavigationUtils.goNextFinishAll(context, LoginPage());
          },
          // print(widget.academicyear);
          //width: 120,
        ),
        DialogButton(
          color: ColorUtils.BLUE,
          child: const Text(
            "No",
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

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
}

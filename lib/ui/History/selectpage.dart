import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/time_table_database_helper.dart';
import '../../Network/api_constants.dart';
import '../../Notification/notification.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../LoginPage/login.dart';
import 'callnotansweres.dart';
import 'commited_date.dart';
import 'constant.dart';
import 'invalid.dart';
import 'missbehaviour.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
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
  Widget? studentImageWidget;

  HistoryPage(
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
      this.studentImageWidget});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

final ValueNotifier<DateTime?> dateSub = ValueNotifier(null);

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  bool calender = true;
  bool call = false;
  bool invalid = false;
  bool misbe = false;

  double height(BuildContext context) => MediaQuery.of(context).size.height;

  double width(BuildContext context) => MediaQuery.of(context).size.width;

  var _ebiTextController = new TextEditingController();

  String? admissionNum;
  String? empCode;
  String? teacherName;

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
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    print("dddggdgd ${widget.StudentImage}");
    print("dddggdgd ${widget.loginTeacherName}");
    print("dddgwidget.logedinEmployeecodegdgd ${widget.logedinEmployeecode}");
    getNotification();
    selectedbutton = 0;
    admissionNum = widget.admissionNumber;
    empCode = widget.logedinEmployeecode;
    teacherName = widget.loginTeacherName;
  }

  Widget _getMenuItem() {

    if (selectedbutton == 0)
      return CommittedPage(
        admissionNumber: widget.admissionNumber,
        employeeCode: widget.logedinEmployeecode,
        nameOfLoginTeacher: widget.loginUserName.toString(),
        fees: widget.studentFees,
      );
    else if (selectedbutton == 1)
      return CallNotAnswered(
        admissionNumber: widget.admissionNumber,
        employeeCode: widget.logedinEmployeecode,
        nameOfLoginTeacher: widget.loginUserName.toString(),
        fees: widget.studentFees,
      );
    else if (selectedbutton == 2)
      return WrongOrInvalid(
        admissionNumber: widget.admissionNumber,
        employeeCode: widget.logedinEmployeecode,
        nameOfLoginTeacher: widget.loginUserName.toString(),
        fees: widget.studentFees,
      );
    else if (selectedbutton == 3)
      return misbehav(
        admissionNumber: widget.admissionNumber,
        employeeCode: widget.logedinEmployeecode,
        nameOfLoginTeacher: widget.loginUserName.toString(),
        fees: widget.studentFees,
      );
    return Container();
  }

  int? selectedbutton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.BACKGROUND,
      body: ListView(
        //physics: NeverScrollableScrollPhysics(),
        children: [
          Stack(children: [
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
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 100.h, left: 12.w, right: 15.w),
              child: Card(
                child: Container(
                    // margin:
                    //     EdgeInsets.only(left: 50.w, top:100.h, right: 50.w),
                    width: 376.w,
                    decoration: BoxDecoration(
                      //border: Border.all(color: ColorUtils.BLUE),
                      color: Colors.white54,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.r),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 14.h, left: 20.w),
                          child: Text(
                            "Call Status Update",
                            style: TextStyle(
                                color: Color(0xFF6B79C1), fontSize: 15.sp),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.r)),
                                  side: BorderSide(
                                      width: 2.w, color: Colors.white)),
                              margin: EdgeInsets.all(10),
                              child: widget.StudentImage == " "
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
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Container(
                              margin: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 240.w,
                                    child: Text(
                                      widget.studentName.toString(),
                                      style: GoogleFonts.spaceGrotesk(
                                          textStyle: TextStyle(
                                              fontSize: 20.sp,
                                              color: ColorUtils.BLACK,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  widget.studentFees == null
                                      ? Text("")
                                      : Row(
                                          children: [
                                            const Text(
                                              "Pending Fees:",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                              widget.studentFees.toString(),
                                              style: TextStyle(
                                                  color: ColorUtils.RED),
                                            )
                                          ],
                                        ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Text(
                                        "Class:",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        widget.classOfStudent.toString(),
                                        style:
                                            TextStyle(color: Color(0xFF587298)),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Text(
                                        "Parent Name:",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Container(
                                        width: 155.w,
                                        child: Text(
                                          widget.parentName.toString(),
                                          style: TextStyle(
                                              color: Color(0xFF587298)),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Text(
                                        "Mobile No:",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Text(
                                        widget.mobileNumber.toString(),
                                        style:
                                            TextStyle(color: Color(0xFF587298)),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          ]),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SizedBox(width:15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: calender ? Colors.blueAccent : Colors.white,
                ),
                child: Container(
                    width: 50.w,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: Image.asset(
                        "assets/images/vectorthree.png",
                      ),
                    )),
                onPressed: () {
                  setState(() {
                    call = false;
                    invalid = false;
                    misbe = false;
                    if (calender == false) {
                      calender = true;
                    }
                    selectedbutton = 0;
                  });
                },
              ),
              //SizedBox(width:10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: call ? Colors.blueAccent : Colors.white,
                ),
                child: Container(
                    width: 50.w,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/images/vectortwo.png",
                      ),
                    )),
                onPressed: () {
                  setState(() {
                    calender = false;
                    invalid = false;
                    misbe = false;
                    if (call == false) {
                      call = true;
                    }
                    selectedbutton = 1;
                  });
                },
              ),
              //SizedBox(width:10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: invalid ? Colors.blueAccent : Colors.white,
                ),
                child: Container(
                    width: 50.w,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: Image.asset(
                        "assets/images/vectorfour.png",
                      ),
                    )),
                onPressed: () {
                  setState(() {
                    call = false;
                    calender = false;
                    misbe = false;
                    if (invalid == false) {
                      invalid = true;
                    }
                    selectedbutton = 2;
                  });
                },
              ),
              //SizedBox(width:10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  primary: misbe ? Colors.blueAccent : Colors.white,
                ),
                child: Container(
                    width: 50.w,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: Image.asset(
                        "assets/images/vectorone.png",
                      ),
                    )),
                onPressed: () {
                  setState(() {
                    call = false;
                    invalid = false;
                    calender = false;
                    if (misbe == false) {
                      misbe = true;
                    }
                    selectedbutton = 3;
                  });
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _getMenuItem(),
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

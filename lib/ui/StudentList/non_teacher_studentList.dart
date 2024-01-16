import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../Network/api_constants.dart';
import '../../Notification/notification.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/utils.dart';
import '../../Widgets/flutter_switch.dart';

class NonTeacherStudentList extends StatefulWidget {
  String? name;
  String? ClassAndBatch;
  String? LoginedUserEmployeeCode;
  var LoginedUserDesignation;
  String? subjectName;
  bool? isTeacher;
  bool? isAClassTeacher;
  String? images;
  String? school_id;
  String? academic_year;
  String? session_id;
  String? curriculam_id;
  String? class_id;
  String? batch_id;
  String? selectedDate;
  String? className;
  String? batchName;
  String? userId;
  String? timeString;

  NonTeacherStudentList(
      {Key? key,
      this.name,
      this.isAClassTeacher,
      this.isTeacher,
      this.subjectName,
      this.ClassAndBatch,
      this.LoginedUserDesignation,
      this.LoginedUserEmployeeCode,
      this.images,
      this.school_id,
      this.userId,
      this.batchName,
      this.academic_year,
      this.batch_id,
      this.class_id,
      this.className,
      this.curriculam_id,
      this.selectedDate,
      this.session_id,
      this.timeString})
      : super(key: key);

  @override
  _NonTeacherStudentListState createState() => _NonTeacherStudentListState();
}

class _NonTeacherStudentListState extends State<NonTeacherStudentList> {
  bool currentState = true;
  bool isSpinner = false;
  bool newSpinner = false;
  bool disableKey = false;
  var _searchController = TextEditingController();
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String? _textSpeech = "Search Here";
  bool attendance_flag = false;

  void onListen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          debugLogging: true,
          onStatus: (val) => print("the onStatus $val"),
          onError: (val) => print("onerror $val"));
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
            onResult: (val) => setState(() {
                  _textSpeech = val.recognizedWords;
                  _searchController.text = _textSpeech!;
                  newResult = isStudentListnull
                      .where((element) => element["username"]
                          .contains("${_textSpeech!.toUpperCase()}"))
                      .toList();
                }));
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  List searchedStudentName = [];
  List newResult = [];
  var newStudentList = [];
  Timer? timer;
  List forSearch = [];
  var absenties = [];
  var StudentIds = [];
  var ourStudentList;
  var newStudendList;
  var modifiedStudentList = [];
  var isStudentListnull = [];
  var afterAttendanceTaken;

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue : Colors.lightBlueAccent,
        ),
      );
    },
  );

  var SubjectIds = [
    "subject123456",
    "subjectArtEdu6",
    "765d8gfheHJNt",
    "subjectDesc",
    "subject123",
    "subjectGenKnwi",
    "5d08b782035c5c68be840d43",
    "subject1234",
    "3h2S6noQZiAkP",
    "subject12345",
    "765d8gfhNVVert",
    "yj6wZhLmLWAtb",
    "subjectHealthAndPE",
    "5d0f0eb1a0a6ad1dc97a61d0",
    "c4A25ahdFonzb",
    "hnAttZHatyQRA",
    "7658gfhNNBVVert"
  ];

  Map<String, dynamic>? StudentList;

  Future getStudentAttendanceList() async {
    setState(() {
      isSpinner = true;
    });
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.STUDENTLIST_URL));
    request.body = json.encode({
      "school_id": widget.school_id,
      "academic_year": widget.academic_year,
      "session_id": widget.session_id,
      "curriculum_id": widget.curriculam_id,
      "class_id": widget.class_id,
      "batch_id": widget.batch_id,
      "for_attendance": true,
      "selected_date":
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
      "att_type": "once",
      "fileServerUrl": "https://teamsqa4000.educore.guru",
      "xclass": widget.className.toString().split(" ")[0],
      "batch": widget.className.toString().split(" ")[1],
      "is_report": false,
      "date": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
      "user_id": widget.userId,
      "selected_period": {
        "_id": "once",
        "name": "Full Day - Lite",
        "period_number": false,
        "lite": true
      }
    });
    request.headers.addAll(headers);

    print('-----------------sssssss${request.body}');

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var jsonResponse = await response.stream.bytesToString();
      print('std list-------->$jsonResponse');
      setState(() {
        StudentList = json.decode(jsonResponse);
      });
      for (var i = 0;
          i < StudentList!["data"]["attendance_settings"].length;
          i++) {
        if (StudentList!["data"]["attendance_settings"][i]["taken_status"] ==
            false) {
          newStudentList.add(
              StudentList!["data"]["attendance_settings"][i]["full_students"]);
          if (newStudentList != null && newStudentList.length != 0) {
            ourStudentList = newStudentList[0]
                ["feeDetails"]; // You can safely access the element here.
            // modifiedStudentList = newStudentList[0]['feeDetails'];
          }
          for (var index = 0; index < ourStudentList.length; index++) {
            ourStudentList[index].addAll({"is_present": true});
          }
          setState(() {
            isStudentListnull = ourStudentList;
            newResult = isStudentListnull;

          });
          for (var ind = 0; ind < ourStudentList.length; ind++) {
            modifiedStudentList.add({
              "_id": ourStudentList[ind]["_id"],
              "user_id": ourStudentList[ind]["user_id"],
              "roll_number": ourStudentList[ind]["roll_number"],
              "subjects": json.encode(SubjectIds),
              "user_name": ourStudentList[ind]["username"],
              "admission_number": ourStudentList[ind]["admission_number"],
              "gender": ourStudentList[ind]["gender"],
              "birth_date": ourStudentList[ind]["birth_date"]
            });
          }
        } else {
          print("attendance taken");
          Utils.showToastSuccess("Attendance Taken").show(context);
          newStudentList.add(
              StudentList!["data"]["attendance_settings"][i]["full_students"]);
          if (newStudentList != null && newStudentList.length != 0) {
            afterAttendanceTaken =
                newStudentList[0]; // You can safely access the element here.
            // modifiedStudentList = newStudentList[0]['feeDetails'];
          }
          for (var index = 0; index < afterAttendanceTaken.length; index++) {
            afterAttendanceTaken[index].addAll({"is_present": true});
          }
          log("the after taken $afterAttendanceTaken");
          setState(() {
            newResult = afterAttendanceTaken;
          });
          log("the after takennnn $isStudentListnull");
          for (var ind = 0; ind < afterAttendanceTaken.length; ind++) {
            modifiedStudentList.add({
              "_id": afterAttendanceTaken[ind]["_id"],
              "user_id": afterAttendanceTaken[ind]["user_id"],
              "roll_number": afterAttendanceTaken[ind]["roll_number"],
              "subjects": json.encode(SubjectIds),
              "user_name": afterAttendanceTaken[ind]["username"],
              "admission_number": afterAttendanceTaken[ind]["admission_number"],
              "gender": afterAttendanceTaken[ind]["gender"],
              "birth_date": afterAttendanceTaken[ind]["birth_date"]
            });
          }
          setState(() {
            isStudentListnull = afterAttendanceTaken;
            for (var j = 0; j < isStudentListnull.length; j++) {
              if (isStudentListnull[j]["feeDetails"]
                  .containsKey("roll_number")) {
                isStudentListnull.sort((a, b) => a["feeDetails"]["roll_number"]
                    .compareTo(b["feeDetails"]["roll_number"]));
              }
            }
            log("the after taken $isStudentListnull");
            newResult = afterAttendanceTaken;
          });
        }
      }

      log("the modified list is $modifiedStudentList");

      print("the student list is $ourStudentList");
    } else {
      print(response.reasonPhrase);
    }
    setState(() {
      isSpinner = false;
    });
  }

  var StudentListOnAttendance;

  Future SubmitAttendance() async {
    attendance_flag = true;
    for (var i = 0;
        i < StudentList!["data"]["attendance_settings"].length;
        i++) {
      if (StudentList!["data"]["attendance_settings"][i]["taken_status"] ==
          false) {
        for (var index = 0; index < ourStudentList.length; index++) {
          if (ourStudentList[index]["is_present"] == true) {
            StudentIds.add(ourStudentList[index]["user_id"]);
          }
          if (ourStudentList[index]["is_present"] == false) {
            absenties.add({
              "_id": ourStudentList[index]["_id"],
              "user_id": ourStudentList[index]["user_id"],
              "username": ourStudentList[index]["username"],
              "user_name": ourStudentList[index]["username"],
              "contact_no": ourStudentList[index]["contact_no"],
              "admission_number": ourStudentList[index]["admission_number"],
              "image": ourStudentList[index]["image"],
              "joined_date": ourStudentList[index]["joined_date"],
              "selected": ourStudentList[index]["selected"],
              "parent_name": ourStudentList[index]["parent_name"],
              "parent_email": ourStudentList[index]["parent_email"],
              "parent_phone": ourStudentList[index]["parent_phone"],
              "fee_arrear": ourStudentList[index]["fee_arrear"],
              "fee_amount": ourStudentList[index]["fee_amount"],
              "roll_number": ourStudentList[index]["roll_number"],
              "reason": "absent"
            });
          }
        }
      } else {
        for (var index = 0; index < afterAttendanceTaken.length; index++) {
          if (afterAttendanceTaken[index]["selected"] == true) {
            StudentIds.add(afterAttendanceTaken[index]["user_id"]);
          }
          if (afterAttendanceTaken[index]["selected"] == false) {
            absenties.add({
              "_id": afterAttendanceTaken[index]["feeDetails"]["_id"],
              "user_id": afterAttendanceTaken[index]["feeDetails"]["user_id"],
              "username": afterAttendanceTaken[index]["feeDetails"]["username"],
              "user_name": afterAttendanceTaken[index]["feeDetails"]
                  ["username"],
              "contact_no": afterAttendanceTaken[index]["feeDetails"]
                  ["contact_no"],
              "admission_number": afterAttendanceTaken[index]["feeDetails"]
                  ["admission_number"],
              "image": afterAttendanceTaken[index]["feeDetails"]["image"],
              "joined_date": afterAttendanceTaken[index]["feeDetails"]
                  ["joined_date"],
              "selected": afterAttendanceTaken[index]["feeDetails"]["selected"],
              "parent_name": afterAttendanceTaken[index]["feeDetails"]
                  ["parent_name"],
              "parent_email": afterAttendanceTaken[index]["feeDetails"]
                  ["parent_email"],
              "parent_phone": afterAttendanceTaken[index]["feeDetails"]
                  ["parent_phone"],
              "fee_arrear": afterAttendanceTaken[index]["feeDetails"]
                  ["fee_arrear"],
              "fee_amount": afterAttendanceTaken[index]["feeDetails"]
                  ["fee_amount"],
              "roll_number": afterAttendanceTaken[index]["feeDetails"]
                  ["roll_number"],
              "reason": "absent"
            });
          }
        }
      }
    }

    log('-------StudentIds--------${StudentIds}');
    log('-------absenties--------${absenties}');

    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };

    var request =
        http.Request('POST', Uri.parse(ApiConstants.ATTENDANCE_SUBMIT));
    request.body = json.encode({
      "selections": {
        "school_id": widget.school_id,
        "academic_year": widget.academic_year,
        "user_id": widget.userId,
        "user_role_id": "role12123rqwer",
        "date":
            DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
        "is_attendance": "attendance",
        "class_batch_obj": {
          "class_id": widget.class_id,
          "batch_id": widget.batch_id,
          "class_name": widget.batchName,
          "class_batch_name": widget.batchName,
          "curriculum_id": widget.curriculam_id,
          "session_id": widget.session_id,
          "batch": widget.className.toString().split(" ")[1],
          "xclass": widget.className.toString().split(" ")[0],
        },
        "students": StudentIds,
        "absentees": absenties,
        "att_type": "once",
        "session": widget.session_id,
        "curriculum": widget.curriculam_id,
        "selected_period": {
          "_id": "once",
          "name": "Full Day - Lite",
          "period_number": false,
          "lite": true
        }
      },
      "att_setttings": {
        "periods_to_client": [
          {
            "_id": "once",
            "name": "Full Day - Lite",
            "period_number": false,
            "lite": true
          }
        ],
        "attendance_colln_id": "61ef791f88fd93072241ded5"
      },
      "students": modifiedStudentList,
      "student_attendence": []
    });
    log("the result of attendance is ${request.body}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Successfully submitted");
      Utils.showToastSuccess("Attendance Submitted Successfully")
          .show(context)
          .then((_) {
        NavigationUtils.goBack(context);
      });
      setState(() {
        newSpinner = false;
      });
      log(await response.stream.bytesToString());
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

  @override
  void initState() {
    getStudentAttendanceList();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    print(count);
    getNotification();
    _speech = stt.SpeechToText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.BACKGROUND,
      body: LoadingOverlay(
        opacity: 0,
        isLoading: isSpinner,
        progressIndicator: Container(
          width: 250.w,
          height: 250.h,
          child: Image.asset("assets/images/Loading.gif"),
        ),
        child: ListView(
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
                      onTap: () async {
                        NavigationUtils.goBack(context);
                      },
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
                                widget.name.toString(),
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
                            name: widget.name,
                            image: widget.images,
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
                            image: NetworkImage(widget.images == ""
                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                : ApiConstants.IMAGE_BASE_URL +
                                    "${widget.images}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              widget.className.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            width: 90.w,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: Image.asset(
                                    "assets/images/studentCalender.png"),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                widget.selectedDate.toString(),
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              widget.timeString == null
                                  ? Text(" ")
                                  : Text(
                                      widget.timeString
                                          .toString()
                                          .split("-")[0],
                                      style: TextStyle(fontSize: 12.sp))
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: TextFormField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              print('isStudentListnull.....--------$isStudentListnull');
                              print('afterAttendanceTaken.....--------$afterAttendanceTaken');
                              print(isStudentListnull);
                              newResult = isStudentListnull
                                  .where((element) => element["username"]
                                      .toString()
                                      .toLowerCase()
                                      .contains("${value}"))
                                  .toList();
                              print('NON_TEACHER_STUDENTLIST____newResult$newResult');
                              print(_searchController.text);
                            });
                          },
                          validator: (val) =>
                              val!.isEmpty ? 'Enter the Topic' : null,
                          cursorColor: Colors.grey,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText:
                                  _isListening ? "Listening..." : "Search Here",
                              prefixIcon: Icon(
                                Icons.search,
                                color: ColorUtils.SEARCH_TEXT_COLOR,
                              ),
                              // suffixIcon: GestureDetector(
                              //   onTap: () => onListen(),
                              //   child: AvatarGlow(
                              //     animate: _isListening,
                              //     glowColor: Colors.blue,
                              //     endRadius: 20.0,
                              //     duration: Duration(milliseconds: 2000),
                              //     repeat: true,
                              //     showTwoGlows: true,
                              //     repeatPauseDuration:
                              //         Duration(milliseconds: 100),
                              //     child: Icon(
                              //       _isListening == false
                              //           ? Icons.keyboard_voice_outlined
                              //           : Icons.keyboard_voice_sharp,
                              //       color: ColorUtils.SEARCH_TEXT_COLOR,
                              //     ),
                              //   ),
                              // ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(2.0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(230, 236, 254, 8),
                                    width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(230, 236, 254, 8),
                                    width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              fillColor: Color.fromRGBO(230, 236, 254, 8),
                              filled: true),
                        ),
                      ),
                      afterAttendanceTaken == null
                          ? Text("")
                          : Center(
                              child: Container(
                                  margin: EdgeInsets.all(8),
                                  child: Text(
                                    "Attendance Taken",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: ColorUtils.RED),
                                  ))),
                      SizedBox(
                        height: 8.h,
                      ),
                      isSpinner
                          ?Expanded(
                              child: CardListSkeleton(
                                isCircularImage: true,
                                isBottomLinesActive: true,
                                length: 10,
                              ),
                            ): newResult.isEmpty ? Center(child: Image.asset("assets/images/nodata.gif"))
                          : Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: _searchController.text
                                          .toString()
                                          .isNotEmpty
                                      ? newResult.length
                                      : afterAttendanceTaken == null
                                          ? ourStudentList.length
                                          : afterAttendanceTaken.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                        margin: EdgeInsets.only(left: 10.w),
                                        child: Column(
                                          children: [
                                            Theme(
                                              data: ThemeData().copyWith(
                                                  dividerColor:
                                                      Colors.transparent),
                                              child: Row(
                                                children: [
                                                  badges.Badge(
                                                    position: badges.BadgePosition.bottomEnd(end: 0, bottom: -12),
                                                    badgeContent: Text(
                                                      "${index + 1}",
                                                      style: TextStyle(
                                                          color: ColorUtils
                                                              .TEXT_COLOR),
                                                    ),badgeStyle: badges.BadgeStyle(elevation: 0,badgeColor:Colors.white, ),
                                                    child: Container(
                                                      width: 50.w,
                                                      height: 50.h,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Color(
                                                                0xFFD6E4FA)),
                                                        // image: DecorationImage(
                                                        //     image: NetworkImage(afterAttendanceTaken !=
                                                        //             null
                                                        //         ? (afterAttendanceTaken[index]["feeDetails"]["image"] ==
                                                        //                 "avathar"
                                                        //             ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                        //             : _searchController
                                                        //                     .text
                                                        //                     .isNotEmpty
                                                        //                 ? ApiConstants.IMAGE_BASE_URL +
                                                        //                     newResult[index]["feeDetails"]["image"].replaceAll(
                                                        //                         '"', '')
                                                        //                 : ApiConstants.IMAGE_BASE_URL +
                                                        //                     afterAttendanceTaken[index]["feeDetails"]["image"].replaceAll(
                                                        //                         '"', ''))
                                                        //         : (ourStudentList[index]["image"].replaceAll(
                                                        //                     '"',
                                                        //                     '') ==
                                                        //                 null
                                                        //             ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                                        //             : _searchController
                                                        //                     .text
                                                        //                     .isNotEmpty
                                                        //                 ? ApiConstants.IMAGE_BASE_URL + newResult[index]["image"].replaceAll('"', '')
                                                        //                 : ApiConstants.IMAGE_BASE_URL + ourStudentList[index]["image"].replaceAll('"', ''))),
                                                        //     fit: BoxFit.fill),
                                                      ),
                                                      child:
                                                          afterAttendanceTaken ==
                                                                  null
                                                              ? ClipRRect(
                                                            borderRadius: BorderRadius.circular(100),
                                                            child: CachedNetworkImage(
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit.fill,
                                                                    imageUrl: ApiConstants
                                                                            .IMAGE_BASE_URL +
                                                                        "${ourStudentList[index]["image"]}",
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Center(
                                                                              child: Text(
                                                                      '${ourStudentList[index]["username"]!.split(' ')[0].toString()[0]}'
                                                                          // '${ourStudentList[index]["username"].split(' ')[1].toString()[0]}'
                                                                                ,
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                                0xFFB1BFFF),
                                                                          fontWeight: FontWeight
                                                                                .bold,
                                                                          fontSize:
                                                                                20),
                                                                    ),
                                                                            ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Center(
                                                                          child: Text(
                                                                      '${ourStudentList[index]["username"]!.split(' ')[0].toString()[0]}'
                                                                          // '${ourStudentList[index]["username"].split(' ')[1].toString()[0]}'
                                                                            ,
                                                                      style: TextStyle(
                                                                            color: Color(
                                                                                0xFFB1BFFF),
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                20),
                                                                    ),
                                                                        ),
                                                                  ),
                                                                )
                                                              : ClipRRect(
                                                            borderRadius: BorderRadius.circular(100),
                                                            child: CachedNetworkImage(
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit.fill,
                                                                    imageUrl: ApiConstants
                                                                            .IMAGE_BASE_URL +
                                                                        "${afterAttendanceTaken[index]["image"]}",
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Center(
                                                                              child: Text(
                                                                      '${afterAttendanceTaken[index]["username"]!.split(' ')[0].toString()[0]}'
                                                                          // '${afterAttendanceTaken[index]["username"].split(' ')[1].toString()[0]}'
                                                                                ,
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                                0xFFB1BFFF),
                                                                          fontWeight: FontWeight
                                                                                .bold,
                                                                          fontSize:
                                                                                20),
                                                                    ),
                                                                            ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Center(
                                                                          child: Text(
                                                                      '${afterAttendanceTaken[index]["username"]!.split(' ')[0].toString()[0]}'
                                                                          // '${afterAttendanceTaken[index]["username"].split(' ')[1].toString()[0]}'
                                                                            ,
                                                                      style: TextStyle(
                                                                            color: Color(
                                                                                0xFFB1BFFF),
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                20),
                                                                    ),
                                                                        ),
                                                                  ),
                                                                ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                              width: 150.w,
                                                              child:
                                                                  SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Text(
                                                                    _searchController
                                                                            .text
                                                                            .toString()
                                                                            .isNotEmpty
                                                                        ? toBeginningOfSentenceCase(newResult[index]["username"]
                                                                                .toString()
                                                                                .toLowerCase())
                                                                            .toString()
                                                                        : afterAttendanceTaken ==
                                                                                    null ||
                                                                                afterAttendanceTaken
                                                                                    .isEmpty
                                                                            ? toBeginningOfSentenceCase(ourStudentList[index]["username"].toString().toLowerCase())
                                                                                .toString()
                                                                                .toCapitalCase()
                                                                            : toBeginningOfSentenceCase(afterAttendanceTaken[index]["username"].toString().toLowerCase())
                                                                                .toString()
                                                                                .toCapitalCase(),
                                                                    style: GoogleFonts.spaceGrotesk(
                                                                        textStyle: TextStyle(
                                                                            fontSize: 16
                                                                                .sp,
                                                                            color: ColorUtils
                                                                                .BLACK,
                                                                            fontWeight:
                                                                                FontWeight.bold))),
                                                              )),

                                                        ],
                                                      ),

                                                      SizedBox(
                                                        width: 40.w,
                                                      ),
                                                      Container(
                                                        child: FlutterSwitch(
                                                          width: 80.w,
                                                          height: 35.h,
                                                          valueFontSize: 16.sp,
                                                          toggleSize: 35.h,
                                                          toggleBorder:
                                                              Border.all(
                                                                  color: Color(
                                                                      0xFFD6E4FA),
                                                                  width: 2),
                                                          value: afterAttendanceTaken ==
                                                                      null ||
                                                                  afterAttendanceTaken
                                                                      .isEmpty
                                                              ? _searchController
                                                                      .text
                                                                      .isNotEmpty
                                                                  ? newResult[
                                                                          index][
                                                                      "is_present"]
                                                                  : ourStudentList[
                                                                          index][
                                                                      "is_present"]
                                                              : _searchController
                                                                      .text
                                                                      .isNotEmpty
                                                                  ? newResult[
                                                                          index]
                                                                      [
                                                                      "selected"]
                                                                  : afterAttendanceTaken[
                                                                          index]
                                                                      [
                                                                      "selected"],
                                                          borderRadius: 30.0,
                                                          padding: 0,
                                                          activeColor:
                                                              ColorUtils
                                                                  .ACTIVE_COLOR,
                                                          inactiveColor: ColorUtils
                                                              .NON_ACTIVE_COLOR,
                                                          activeText: "P",
                                                          inactiveText: "A",
                                                          inactiveTextColor:
                                                              Colors.white,
                                                          activeTextColor:
                                                              Colors.white,
                                                          showOnOff: true,
                                                          onToggle: (val) {
                                                            setState(() {
                                                              afterAttendanceTaken ==
                                                                          null ||
                                                                      afterAttendanceTaken
                                                                          .isEmpty
                                                                  ? _searchController
                                                                          .text
                                                                          .isNotEmpty
                                                                      ? newResult[index]
                                                                              [
                                                                              "is_present"] =
                                                                          val
                                                                      : ourStudentList[index]
                                                                              [
                                                                              "is_present"] =
                                                                          val
                                                                  : _searchController
                                                                          .text
                                                                          .isNotEmpty
                                                                      ? newResult[index]
                                                                              [
                                                                              "selected"] =
                                                                          val
                                                                      : afterAttendanceTaken[
                                                                              index]
                                                                          [
                                                                          "selected"] = val;

                                                              if (attendance_flag ==
                                                                  true) {
                                                                attendance_flag =
                                                                    false;
                                                              }
                                                            });

                                                            print(
                                                                "the selected value is $ourStudentList");
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              indent: 20,
                                              endIndent: 20,
                                              height: 20,
                                            )
                                          ],
                                        ));
                                  }),
                            ),
                      SizedBox(
                        height: 210.h,
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton: button(),
      floatingActionButton: newSpinner == true
          ? FloatingActionButton.extended(
              elevation: 0,
              onPressed: () {},
              backgroundColor: Colors.white,
              label: CircularProgressIndicator(
                color: ColorUtils.BLUE,
              ))
          : FloatingActionButton.extended(
              elevation:
                  isStudentListnull.isEmpty || disableKey || newSpinner ? 0 : 8,
              onPressed: isStudentListnull.isEmpty || disableKey
                  ? () {}
                  : () {
                      if (_searchController.text.isNotEmpty &&
                          newResult.isEmpty) {
                        Utils.showToastError("No Data Available to Submit")
                            .show(context);
                      } else {
                        setState(() {
                          newSpinner = true;
                          disableKey = true;
                        });
                        if (attendance_flag == true) {
                          print("kckkckckckkkckc");
                          Utils.showToastError(
                                  "Please wait the data is uploading")
                              .show(context);
                        } else {
                          SubmitAttendance();
                        }
                      }
                    },
              backgroundColor: isStudentListnull.isEmpty || disableKey
                  ? Colors.transparent
                  : ColorUtils.BLUE,
              label: const Text("SUBMIT"),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget NonTeacherStudentList(
          String images, String nameOfStudent, var attendanceArray) =>
      Column(
        children: [
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:
                            NetworkImage(ApiConstants.IMAGE_BASE_URL + images),
                        fit: BoxFit.fill),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Row(
                  children: [
                    Container(
                        width: 150.w,
                        child: Text(nameOfStudent,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: ColorUtils.BLACK,
                                    fontWeight: FontWeight.bold)))),
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                      child: FlutterSwitch(
                        width: 80.w,
                        height: 34.h,
                        valueFontSize: 16.sp,
                        toggleSize: 30.h,
                        value: ourStudentList[0]["fee_arrear"],
                        borderRadius: 30.0,
                        padding: 8.0,
                        activeColor: ColorUtils.ACTIVE_COLOR,
                        inactiveColor: ColorUtils.NON_ACTIVE_COLOR,
                        activeText: "P",
                        inactiveText: "A",
                        inactiveTextColor: Colors.white,
                        activeTextColor: Colors.white,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            ourStudentList[0]["fee_arrear"] = val;
                          });
                          print("the selected value is $attendanceArray");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            height: 20,
          )
        ],
      );

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  Widget button() {
    if (isStudentListnull.isEmpty || disableKey || newSpinner) {
      // return FloatingActionButton.extended(
      //     elevation: 0,
      //     onPressed: () {},
      //     backgroundColor: Colors.white,
      //     label: CircularProgressIndicator(color: ColorUtils.BLUE,));
      return SizedBox();
    } else {
      return FloatingActionButton.extended(
        elevation:
            isStudentListnull.isEmpty || disableKey || newSpinner ? 0 : 8,
        onPressed: isStudentListnull.isEmpty || disableKey
            ? () {}
            : () {
                if (_searchController.text.isNotEmpty && newResult.isEmpty) {
                  Utils.showToastError("No Data Available to Submit")
                      .show(context);
                } else {
                  setState(() {
                    newSpinner = true;
                    disableKey = true;
                  });
                  if (attendance_flag == true) {
                    print("kckkckckckkkckc");
                    Utils.showToastError("Please wait the data is uploading")
                        .show(context);
                  } else {
                    SubmitAttendance();
                  }
                }
              },
        backgroundColor: isStudentListnull.isEmpty || disableKey
            ? Colors.transparent
            : ColorUtils.BLUE,
        label: const Text("SUBMIT"),
      );
    }
  }
}

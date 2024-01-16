import 'dart:async';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:change_case/change_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loader_skeleton/loader_skeleton.dart';
import 'dart:convert';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../Network/api_constants.dart';
import '../../Notification/notification.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/utils.dart';
import '../History/selectpage.dart';
import '../LoginPage/login.dart';
import '../Student_Activity/history_list.dart';

class StudentListForHOS extends StatefulWidget {
  String? name;
  String? ClassAndBatch;
  String? LoginedUserEmployeeCode;
  var LoginedUserDesignation;
  String? subjectName;
  bool? isTeacher;
  bool? isAClassTeacher;
  String? totalProcessed;
  String? image;
  String? classTeacherName;
  Widget? CustomeImageContainer;

  StudentListForHOS(
      {this.name,
      this.ClassAndBatch,
      this.LoginedUserEmployeeCode,
      this.LoginedUserDesignation,
      this.subjectName,
      this.isTeacher,
      this.isAClassTeacher,
      this.totalProcessed,
      this.image,
      this.classTeacherName,
      this.CustomeImageContainer});

  @override
  _StudentListForHOSState createState() => _StudentListForHOSState();
}

class _StudentListForHOSState extends State<StudentListForHOS> {
  bool currentState = true;
  bool isSpinner = false;
  var _searchController = TextEditingController();
  var className;
  var batchName;
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String? _textSpeech = "Search Here";

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
                  newResult = uniqueList
                      .where((element) =>
                          element["student_name"]
                              .contains("${_textSpeech!.toUpperCase()}") ||
                          element["Admn_no"]
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
  Timer? timer;
  List forSearch = [];
  List uniqueList = [];
  List orderedList = [];
  var ClassesOfTeachers;
  var employeeid;

  Map<String, dynamic>? historyOfStudentFees;

  Future<void> getStudentFeeList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_token = preferences.getString("school_token");
    employeeid = preferences.getString("employeeNumber");
    var header = {"API-Key": "525-777-777", "Content-Type": "application/json"};
    var request = http.Request('POST', Uri.parse(ApiConstants.DOCME_URL));
    request.body = json.encode({
      "action": "getEmployeeFeedbackById",
      "token": school_token,
      "employee_code": widget.LoginedUserEmployeeCode,
      "feedback_type_id": [1, 2, 3, 4, 5, 6, 7]
    });

    request.headers.addAll(header);

    http.StreamedResponse response = await request.send();

    log("${response.statusCode}");
    log("bodyrequest${request.body}");

    if (response.statusCode == 200) {
      var responseJson = await response.stream.bytesToString();
      print('std list-------->$responseJson');
      var studentList = json.decode(responseJson);

      setState(() {
        historyOfStudentFees = studentList;
        orderedList = historyOfStudentFees!["data"];
        print('historyyyyyy-----$historyOfStudentFees');
      });
      var seen = Set<dynamic>();
      uniqueList = orderedList
          .where((element) => seen.add(element["student_name"]))
          .toList();
      log("the student list is $uniqueList");

      var classData = [];
      for (var index = 0;
          index < historyOfStudentFees!["data"].length;
          index++) {
        classData.add({
          "class": historyOfStudentFees!["data"][index]["Class"],
          "batch": historyOfStudentFees!["data"][index]["Division"].trim()
        });
      }

      final jsonList = classData.map((item) => jsonEncode(item)).toList();
      final uniqueJsonList = jsonList.toSet().toList();
      ClassesOfTeachers =
          uniqueJsonList.map((item) => jsonDecode(item)).toList();

      log("hdhdhdh  ${ClassesOfTeachers}");
      log("employeeidemployeeid${employeeid}");
      // log("${classData}");
      //
      // var removeDuplicates = classData.toSet().toList();
      // var newClassTeacherCLass = removeDuplicates.where((element) => element.contansKey("class")).toSet().toList();
      //
      // log(" the class is $newClassTeacherCLass");

      className = historyOfStudentFees!["data"][0]["Class"];
      batchName = historyOfStudentFees!["data"][0]["Division"];

      log('claclassNamessName$className');
      log('batchbatchNameName$batchName');
    } else {
      log("response.reasonPhrasestudentlisthos${response.reasonPhrase}");
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
    getStudentFeeList().then((value) {
      print('historyOfStudentFees${historyOfStudentFees}');
      print('LoginedUserEmployeeCode${widget.LoginedUserEmployeeCode}');
      print('orderedList${orderedList}');
    });
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    // print('countcountcount${count}');
    print('classTeacherName${widget.classTeacherName}');
    print('namename${widget.name}');

    getNotification();
    log("LoginedUserEmployeeCodeLoginedUserEmployeeCode${widget.LoginedUserEmployeeCode}");

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
                            image: NetworkImage(widget.image == ""
                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                : ApiConstants.IMAGE_BASE_URL +
                                    "${widget.image}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Theme(
                            data: ThemeData()
                                .copyWith(dividerColor: Colors.transparent),
                            child: Container(
                              margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                              child: Column(
                                children: [
                                  Container(
                                    width: 50.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Color(0xFFEEF1FF)),
                                        color: Color(0xFFEEF1FF)),
                                    child: widget.CustomeImageContainer,
                                  ),
                                  SizedBox(
                                    height: 10.w,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                          child: Text(
                                              toBeginningOfSentenceCase(widget
                                                      .classTeacherName
                                                      .toString()
                                                      .toLowerCase())
                                                  .toString(),
                                              style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: ColorUtils.BLACK,
                                                      fontWeight:
                                                          FontWeight.w600)))),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                "Total Processed :",
                                                style:
                                                    TextStyle(fontSize: 14.sp),
                                              ),
                                            ),
                                            SizedBox(
                                              child: Text(
                                                widget.totalProcessed
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color:
                                                        ColorUtils.MAIN_COLOR,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            ClassesOfTeachers == []
                                                ? const Text("")
                                                : const VerticalDivider(
                                                    thickness: 1,
                                                    width: 10,
                                                    color: Colors.blueGrey,
                                                  ),
                                            ClassesOfTeachers == null
                                                ? Text("")
                                                : ClassesOfTeachers.length > 1
                                                    ? Row(
                                                        children: [
                                                          for (var i = 0;
                                                              i <
                                                                  ClassesOfTeachers
                                                                      .length;
                                                              i++)
                                                            SizedBox(
                                                              child:
                                                                  ClassesOfTeachers ==
                                                                          []
                                                                      ? const Text(
                                                                          "")
                                                                      : Text(
                                                                          ClassesOfTeachers[i]["class"] +
                                                                              "" +
                                                                              ClassesOfTeachers[i]["batch"] +
                                                                              " ",
                                                                          style: TextStyle(
                                                                              fontSize: 14.sp,
                                                                              color: ColorUtils.GREEN,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                            ),
                                                        ],
                                                      )
                                                    : SizedBox(
                                                        child: className == null
                                                            ? const Text("")
                                                            : Text(
                                                                className +
                                                                    " " +
                                                                    batchName,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: ColorUtils
                                                                        .GREEN,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                      ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          )
                          // const Divider(
                          //   indent: 20,
                          //   endIndent: 20,
                          //   height: 20,
                          // )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: TextFormField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              newResult = uniqueList
                                  .where((element) =>
                                      element["student_name"]
                                          .contains("${value.toUpperCase()}") ||
                                      element["Admn_no"]
                                          .contains("${value.toUpperCase()}"))
                                  .toList();
                              print(newResult);
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
                      SizedBox(
                        height: 10.h,
                      ),
                      historyOfStudentFees == null
                          ? Expanded(
                              child: CardListSkeleton(
                                isCircularImage: true,
                                isBottomLinesActive: true,
                                length: 10,
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                              itemCount:
                                  _searchController.text.toString().isNotEmpty
                                      ? newResult.length
                                      : uniqueList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SwipeTo(
                                  rightSwipeWidget: Container(
                                    padding: const EdgeInsets.all(30),
                                    color: ColorUtils.LOGIN_BUTTON,
                                    child: const Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onRightSwipe: () {
                                    showDialog(
                                      context,
                                      _searchController.text
                                              .toString()
                                              .isNotEmpty
                                          ? toBeginningOfSentenceCase(
                                                  newResult[index]
                                                          ["student_name"]
                                                      .toString()
                                                      .toLowerCase())
                                              .toString()
                                          : toBeginningOfSentenceCase(
                                                  uniqueList[index]
                                                          ["student_name"]
                                                      .toString()
                                                      .toLowerCase())
                                              .toString(),
                                      " ",
                                      true,
                                      _searchController.text
                                              .toString()
                                              .isNotEmpty
                                          ? newResult[index]["Parent_name"]
                                              .toString()
                                          : uniqueList[index]["Parent_name"],
                                      _searchController.text
                                              .toString()
                                              .isNotEmpty
                                          ? newResult[index]["Parent_contact"]
                                              .toString()
                                          : uniqueList[index]["Parent_contact"],
                                      _searchController.text
                                              .toString()
                                              .isNotEmpty
                                          ? newResult[index]["Admn_no"]
                                          : uniqueList[index]["Admn_no"],
                                      _searchController.text
                                              .toString()
                                              .isNotEmpty
                                          ? newResult[index]
                                              ["Followup_fee_amount"]
                                          : uniqueList[index]
                                              ["Followup_fee_amount"],
                                    );
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10.w),
                                      child: Column(
                                        children: [
                                          Theme(
                                            data: ThemeData().copyWith(
                                                dividerColor:
                                                    Colors.transparent),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 50.w,
                                                  height: 50.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Color(
                                                              0xFFEEF1FF)),
                                                  child: Image.asset(
                                                      "assets/images/profile.png"),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        width: 220.w,
                                                        child: Text(
                                                            _searchController
                                                                    .text
                                                                    .toString()
                                                                    .isNotEmpty
                                                                ? toBeginningOfSentenceCase(newResult[index]["student_name"]
                                                                        .toString()
                                                                        .toLowerCase())
                                                                    .toString()
                                                                    .toCapitalCase()
                                                                : toBeginningOfSentenceCase(uniqueList[index]["student_name"]
                                                                        .toString()
                                                                        .toLowerCase())
                                                                    .toString()
                                                                    .toCapitalCase(),
                                                            style: GoogleFonts.spaceGrotesk(
                                                                textStyle: TextStyle(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: ColorUtils
                                                                        .BLACK,
                                                                    fontWeight:
                                                                        FontWeight.bold)))),
                                                    SizedBox(
                                                      height: 3.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              child: Text(
                                                                "AED :",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.sp),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Text(
                                                                _searchController
                                                                        .text
                                                                        .toString()
                                                                        .isNotEmpty
                                                                    ? newResult[
                                                                            index]
                                                                        [
                                                                        "Followup_fee_amount"]
                                                                    : uniqueList[
                                                                            index]
                                                                        [
                                                                        "Followup_fee_amount"],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: ColorUtils
                                                                        .MAIN_COLOR,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        VerticalDivider(
                                                          thickness: 1,
                                                          width: 10,
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                        SizedBox(
                                                          child: Text(
                                                            _searchController
                                                                    .text
                                                                    .toString()
                                                                    .isNotEmpty
                                                                ? newResult[index]
                                                                        [
                                                                        "Class"] +
                                                                    newResult[
                                                                            index]
                                                                        [
                                                                        "Division"]
                                                                : uniqueList[
                                                                            index]
                                                                        [
                                                                        "Class"] +
                                                                    uniqueList[
                                                                            index]
                                                                        [
                                                                        "Division"],
                                                            style: TextStyle(
                                                                fontSize: 14.sp,
                                                                color:
                                                                    ColorUtils
                                                                        .GREEN,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
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
                                      )),
                                );
                              },
                            )),
                      SizedBox(
                        height: 210.h,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future showDialog(
      BuildContext context,
      String studentName,
      String image,
      bool is_fees_paid,
      String parentName,
      String ParentContact,
      String AdmissionNumber,
      String fees) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
        ),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2.5,
            margin: EdgeInsets.all(30),
            child: ListView(
              children: [
                SizedBox(
                  height: 25.h,
                ),
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFEEF1FF)),
                      child: Image.asset("assets/images/profile.png"),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 200.w,
                            child: Text(studentName,
                                style: GoogleFonts.spaceGrotesk(
                                    textStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: ColorUtils.BLACK,
                                        fontWeight: FontWeight.bold)))),
                        SizedBox(
                          height: 6.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              child: Text(
                                "AED :",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                fees,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorUtils.MAIN_COLOR,
                                    fontWeight: FontWeight.bold),
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
                Row(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 150.w,
                                child: Text(parentName,
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: ColorUtils.BLACK,
                                            fontWeight: FontWeight.bold)))),
                            SizedBox(
                              height: 6.h,
                            ),
                            SizedBox(
                              child: Text(
                                ParentContact,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Utils.call(ParentContact),
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
                SizedBox(
                  height: 20.h,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       children: [
                //         Container(
                //           width: 50.w,
                //           height: 50.h,
                //           child: SvgPicture.asset(
                //             "assets/images/profileTwo.svg",
                //             color: ColorUtils.MAIN_COLOR,
                //           ),
                //         ),
                //         SizedBox(
                //           width: 10.w,
                //         ),
                //         Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Container(
                //                 // width: 150.w,
                //                 child: Text("Jane Cooper",
                //                     style: GoogleFonts.roboto(
                //                         textStyle: TextStyle(
                //                             fontSize: 16.sp,
                //                             color: ColorUtils.BLACK,
                //                             fontWeight: FontWeight.bold)))),
                //             SizedBox(
                //               height: 6.h,
                //             ),
                //             SizedBox(
                //               child: Text(
                //                 "9373633636367",
                //                 style: TextStyle(fontSize: 14.sp),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //     GestureDetector(
                //       onTap: () => Utils.call("64664"),
                //       child: Container(
                //         width: 50.w,
                //         height: 50.h,
                //         child: SvgPicture.asset(
                //           "assets/images/callButtonOne.svg",
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 25.h,
                ),
                // result == null || result["data"] == null ? Center(child: CircularProgressIndicator(),) : result["data_status"] == 0 ? Center(child: Text("No Feedback Available")) : SizedBox(
                //   height: 150.h,
                //   child: ListView.builder(
                //       shrinkWrap: true,
                //       scrollDirection: Axis.vertical,
                //       itemCount: result!["data"].length,
                //       itemBuilder: (BuildContext context, int index) {
                //         return Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             SizedBox(height: 15.h,),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Text(result!["data"][index]["Feeback_type"] == 1 ? "Committed Calls" : result!["data"][index]["Feeback_type"] == 2 || result!["data"][index]["Feeback_type"] == 3 ? "Invalid or Wrong Number" : result!["data"][index]["Feeback_type"] == 4 ? "Call Not Answered" : "Misbehaved",style: TextStyle(color: Colors.blueGrey)),
                //                 Image.asset(result!["data"][index]["Feeback_type"] == 1 ? "assets/images/committed.png" : result!["data"][index]["Feeback_type"] == 2 || result!["data"][index]["Feeback_type"] == 3 ? "assets/images/invalidcall.png" : result!["data"][index]["Feeback_type"] == 4 ? "assets/images/callnotanswered.png" : "assets/images/mis.png",height: 50.h,width: 50.h,)
                //               ],
                //             ),
                //             SizedBox(height: 5.h,),
                //             Container(
                //               width: MediaQuery.of(context).size.width,
                //               //margin: EdgeInsets.only(left: 20.w, right: 20.w),
                //               decoration: BoxDecoration(
                //                   color: ColorUtils.TEXTFIELD,
                //                   border: Border.all(color: ColorUtils.BLUE),
                //                   borderRadius: BorderRadius.all(Radius.circular(10.r))),
                //               child: Padding(
                //                 padding: const EdgeInsets.all(10.0),
                //                 child: Column(
                //                   mainAxisAlignment: MainAxisAlignment.start,
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     const Text(
                //                       "Remark",
                //                       style: TextStyle(color: Colors.blueGrey),
                //                     ),
                //                     Container(
                //                       margin: const EdgeInsets.all(20),
                //                       child: Text(result!["data"][index]["Feeback_comment"]),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ],
                //         );
                //       }
                //   ),
                // ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150.w,
                      height: 38.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: ColorUtils.CALL_STATUS, elevation: 2),
                        onPressed: () {
                          print("thee  ddd ${parentName}");
                          NavigationUtils.goNext(
                              context,
                              HistoryOfStudentActivity(
                                mobileNumber: ParentContact,
                                loginUserName: widget.name,
                                classOfStudent: className + " " + batchName,
                                parentName: parentName,
                                TeacherProfile: widget.image,
                                studentName: studentName,
                                logedinEmployeecode: employeeid,
                                admissionNumber: AdmissionNumber,
                                StudentImage: image,
                                studentFees: fees,
                              ));
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/icon.svg",
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "History",
                              style: TextStyle(fontSize: 19.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    is_fees_paid == false
                        ? Text("")
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white, elevation: 0),
                            onPressed: () => NavigationUtils.goNext(
                                context,
                                HistoryPage(
                                  mobileNumber: ParentContact,
                                  loginUserName: widget.name,
                                  classOfStudent: className + " " + batchName,
                                  parentName: parentName,
                                  TeacherProfile: widget.image,
                                  studentName: studentName,
                                  logedinEmployeecode: employeeid,
                                  admissionNumber: AdmissionNumber,
                                  StudentImage: image,
                                  studentFees: fees,
                                )),
                            child: SvgPicture.asset(
                              "assets/images/Add.svg",
                            ),
                          ),
                  ],
                )
              ],
            ),
          );
        });
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

  Widget _getCallButton(String phoneNumber) => GestureDetector(
        onTap: () {
          Utils.call(phoneNumber);
          print("button presses");
        },
        child: Container(
          child: Image.asset("assets/images/callbutton.png"),
        ),
      );
}

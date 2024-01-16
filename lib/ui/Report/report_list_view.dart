import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../Network/api_constants.dart';
import '../../Notification/notification.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../StudentList/student_list_for_hos.dart';

class ReportListView extends StatefulWidget {
  var Empcodee;
  String? teacherName;
  String? image;
  String? HOSID;
  var HOSNAME;
  var loginname;
  ReportListView(
      {Key? key,
      this.Empcodee,
      this.loginname,
      this.HOSID,
      this.HOSNAME,
      this.teacherName,
      this.image,})
      : super(key: key);

  @override
  _ReportListViewState createState() => _ReportListViewState();
}

class _ReportListViewState extends State<ReportListView> {
  var committed;
  var callnotAnswred;
  var Invalid;
  var wrong;
  bool isSpinner = false;
  int selected = 0;
  Map<String, dynamic>? loginCredential;
  String? img;
  var duplicateTeacherData = [];
  var teacherData = [];
  var newTeacherData;
  var classB = [];
  var employeeUnderHOS= [];
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
                  newReport = newTeacherList
                      .where((element) => element["employee_name"]
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

  List newTeacherList = [];
  List newReport = [];
  var _searchController = TextEditingController();
  var employeeid;
  var loginname;
  Map<String, dynamic>? notificationResult;
  int Count = 0;

  getNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    loginname = preferences.getString('name');
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    //for test teamsqa3000 and for live nims3000
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

  void initState() {
    print('Empcodee-----__________________');
    // teacherData();
    // _speech = stt.SpeechToText();
    initialize();
    super.initState();
  }
  Future initialize() async{
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
   await getUserLoginCredentials();
    print('Empcodee--${widget.Empcodee}');
    print('teacherName${widget.teacherName}');
    print('teacherName${employeeid}');
    // print('teacherName${widget.teacherName}');
    print(count);
    await getNotification();
    await getTeacherList();
  }

  Map<String, dynamic>? teacherList;

  Future getTeacherList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_token = preferences.getString("school_token");
    employeeid = preferences.getString('employeeNumber');
    print('--widget-----${widget.Empcodee}');
    //isSpinner=true;
    Map<String, String> headers = {
      'API-Key': '525-777-777',
      'Content-Type': 'application/json'
    };

    final bdy = {
      "action": "getFeedbackTotalSummaryData",
      "token": "$school_token",
      "employee_code": employeeUnderHOS.isEmpty ? widget.Empcodee : employeeUnderHOS
    };

    log("the >>>>>>>>>>>>>>>>>>>>> $bdy");

    final response = await http.post(Uri.parse(ApiConstants.DOCME_URL),
        headers: headers, body: json.encode(bdy));

    //final responseJson = json.decode(response.body);
    print('responserbodybodyesponse${response.body}');
    print(response.statusCode);
    if (response.statusCode == 200) {
      teacherList = json.decode(response.body);
      print('teachteacherListerList$teacherList');

      newTeacherList = teacherList!["data"];
      print("newTeacherList--${newTeacherList}");
    } else {
      setState(() {
        // isSpinner=false;
      });
    }
  }
  Future getUserLoginCredentials() async {
    // var result = await Connectivity().checkConnectivity();
    // if (result == ConnectivityResult.none) {
    //   _checkInternet(context);
    // } else {
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.WORKLOAD_API));
    request.body = json.encode({"user_id": widget.HOSID});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    print('----rrreeeqqq${request.body}');
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      setState(() {
        isSpinner = false;
      });
      loginCredential = json.decode(responseData);
      SharedPreferences preference = await SharedPreferences.getInstance();
      preference.setString('loginCredential', json.encode(loginCredential));
      log("api resss-----$loginCredential");
      print('-------------------role ids-----------------');
      print('array--${loginCredential!["data"]["data"][0]["all_roles_array"]}');

      print('---------------end of----role ids-----------------');
      // print(loginCredential!["data"]["data"][0]["faculty_data"]
      // ["teacherComponent"]["is_class_teacher"]);

      img = loginCredential!["data"]["data"][0]["image"];

      print(">>>>>>>$img<<<<<<<");
      Map<String, dynamic> faculty_data =
      loginCredential!["data"]["data"][0]["faculty_data"];
      if (faculty_data.containsKey("teacherComponent") ||
          faculty_data.containsKey("supervisorComponent") ||
          faculty_data.containsKey("hosComponent") ||
          faculty_data.containsKey("hodComponent")) {
        if (faculty_data.containsKey("teacherComponent")) {
          if (loginCredential!["data"]["data"][0]["faculty_data"]
          ["teacherComponent"]["is_class_teacher"] ==
              true ||
              loginCredential!["data"]["data"][0]["faculty_data"]
              ["teacherComponent"]["is_class_teacher"] ==
                  false) {
            print("-----------------------------------teacher");

            for (var index = 0;
            index <
                loginCredential!["data"]["data"][0]["faculty_data"]
                ["teacherComponent"]["own_list"]
                    .length;
            index++) {
              var classBatch = loginCredential!["data"]["data"][0]
              ["faculty_data"]["teacherComponent"]["own_list"][index]
              ["academic"];

              var sessionId = loginCredential!["data"]["data"][0]
              ["faculty_data"]["teacherComponent"]["own_list"][index]
              ["session"]["_id"];

              var curriculumId = loginCredential!["data"]["data"][0]
              ["faculty_data"]["teacherComponent"]["own_list"][index]
              ["curriculum"]["_id"];

              var batchID = loginCredential!["data"]["data"][0]["faculty_data"]
              ["teacherComponent"]["own_list"][index]["batch"]["_id"];

              var classID = loginCredential!["data"]["data"][0]["faculty_data"]
              ["teacherComponent"]["own_list"][index]["class"]["_id"];

              duplicateTeacherData.add({
                "class": classBatch.split("/")[2].toString() +
                    " " +
                    classBatch.split("/")[3].toString(),
                "session_id": sessionId,
                "curriculumId": curriculumId,
                "batch_id": batchID,
                "class_id": classID,
                "is_Class_teacher": loginCredential!["data"]["data"][0]
                ["faculty_data"]["teacherComponent"]["own_list"][index]
                ["is_class_teacher"]
              });
              print(
                  '${loginCredential!["data"]["data"][0]["faculty_data"]["teacherComponent"]["own_list"][0]["subjects"]}');
              for (var ind = 0;
              ind <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["teacherComponent"]["own_list"][index]
                  ["subjects"]
                      .length;
              ind++) {
                var subjects = loginCredential!["data"]["data"][0]
                ["faculty_data"]["teacherComponent"]["own_list"][index]
                ["subjects"][ind]["name"];

                teacherData.add({
                  "class": classBatch.split("/")[2].toString() +
                      " " +
                      classBatch.split("/")[3].toString(),
                  "subjects": subjects,
                  "session_id": sessionId,
                  "curriculumId": curriculumId,
                  "batch_id": batchID,
                  "class_id": classID,
                  "is_Class_teacher": loginCredential!["data"]["data"][0]
                  ["faculty_data"]["teacherComponent"]["own_list"]
                  [index]["is_class_teacher"]
                });
              }
            }

            var removeDuplicates = duplicateTeacherData.toSet().toList();
            var newClassTeacherCLass = removeDuplicates
                .where((element) => element.containsValue(true))
                .toSet()
                .toList();

            newTeacherData = newClassTeacherCLass;
            log("tdhdhdhdhdhdbhdhd ${newTeacherData.length}");

            log(">>>>>>>>hoslistingteacherData>>>>>>>>$teacherData");
            // print(" the length of class_group $employeeUnderHOS");

            print(classB);

            print(loginCredential);

            setState(() {
              isSpinner = false;
            });
          }
        }
        if (faculty_data.containsKey("supervisorComponent")) {
          if (loginCredential!["data"]["data"][0]["faculty_data"]
          ["supervisorComponent"]["is_hos"] ==
              true) {
            for (var ind = 0;
            ind <
                loginCredential!["data"]["data"][0]["faculty_data"]
                ["supervisorComponent"]["own_list_groups"]
                    .length;
            ind++) {
              for (var index = 0;
              index <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["supervisorComponent"]["own_list_groups"]
                  [ind]["class_group"]
                      .length;
              index++) {
                if (loginCredential!["data"]["data"][0]["faculty_data"]
                ["supervisorComponent"]["own_list_groups"][ind]
                ["class_group"][index]
                    .containsKey("class_teacher")) {
                  var employeeUnderHod = loginCredential!["data"]["data"][0]
                  ["faculty_data"]["supervisorComponent"]
                  ["own_list_groups"][ind]["class_group"][index]
                  ["class_teacher"]["employee_no"];
                  employeeUnderHOS.add(employeeUnderHod);
                }
              }
            }
            for (var index = 0;
            index <
                loginCredential!["data"]["data"][0]["faculty_data"]
                ["supervisorComponent"]["own_list_groups"]
                    .length;
            index++) {
              for (var ind = 0;
              ind <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["supervisorComponent"]["own_list_groups"]
                  [index]["class_group"]
                      .length;
              ind++) {
                var classBatch = loginCredential!["data"]["data"][0]
                ["faculty_data"]["supervisorComponent"]
                ["own_list_groups"][index]["class_group"][ind]["academic"];
                classB.add(classBatch.split("/")[2].toString() +
                    " " +
                    classBatch.split("/")[3].toString());
              }
            }

            print('employeeUnderHOS__---__$employeeUnderHOS');

            print("???????????????????????????????????????????????????$classB");

            print(loginCredential);

            setState(() {
              isSpinner = false;
            });
          }
        }
        if (faculty_data.containsKey("hosComponent")) {
          print("hos Component");
          if (loginCredential!["data"]["data"][0]["faculty_data"]
          ["hosComponent"]["is_hos"] ==
              true) {
            for (var ind = 0;
            ind <
                loginCredential!["data"]["data"][0]["faculty_data"]
                ["hosComponent"]["own_list_groups"]
                    .length;
            ind++) {
              for (var index = 0;
              index <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["hosComponent"]["own_list_groups"][ind]
                  ["class_group"]
                      .length;
              index++) {
                if (loginCredential!["data"]["data"][0]["faculty_data"]
                ["hosComponent"]["own_list_groups"][ind]
                ["class_group"][index]
                    .containsKey("class_teacher")) {
                  var employeeUnderHod = loginCredential!["data"]["data"][0]
                  ["faculty_data"]["hosComponent"]
                  ["own_list_groups"][ind]["class_group"][index]
                  ["class_teacher"]["employee_no"];

                  print('----empid--$employeeUnderHod');
                  employeeUnderHOS.add(employeeUnderHod);
                }
              }
            }
            for (var index = 0;
            index <
                loginCredential!["data"]["data"][0]["faculty_data"]
                ["hosComponent"]["own_list_groups"]
                    .length;
            index++) {
              for (var ind = 0;
              ind <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["hosComponent"]["own_list_groups"][index]
                  ["class_group"]
                      .length;
              ind++) {
                var classBatch = loginCredential!["data"]["data"][0]
                ["faculty_data"]["hosComponent"]["own_list_groups"]
                [index]["class_group"][ind]["academic"];
                classB.add(classBatch.split("/")[2].toString() +
                    " " +
                    classBatch.split("/")[3].toString());
              }
            }

            log("print HOS EMP$employeeUnderHOS");

            print(classB);

            print(loginCredential);

            setState(() {
              isSpinner = false;
            });
          }
        }

        if (faculty_data.containsKey("hodComponent")) {
          if (loginCredential!["data"]["data"][0]["faculty_data"]
          ["hodComponent"]["is_hod"] ==
              true) {
            for (var ind = 0;
            ind <
                loginCredential!["data"]["data"][0]["faculty_data"]
                ["hodComponent"]["own_list_groups"]
                    .length;
            ind++) {
              for (var index = 0;
              index <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["hodComponent"]["own_list_groups"][ind]
                  ["class_group"]
                      .length;
              index++) {
                if (loginCredential!["data"]["data"][0]["faculty_data"]
                ["hodComponent"]["own_list_groups"][ind]
                ["class_group"][index]
                    .containsKey("class_teacher")) {
                  var employeeUnderHod = loginCredential!["data"]["data"][0]
                  ["faculty_data"]["hodComponent"]
                  ["own_list_groups"][ind]["class_group"][index]
                  ["class_teacher"]["employee_no"];
                  employeeUnderHOS.add(employeeUnderHod);
                }
              }
            }
            for (var index = 0;
            index <
                loginCredential!["data"]["data"][0]["faculty_data"]
                ["hodComponent"]["own_list_groups"]
                    .length;
            index++) {
              for (var ind = 0;
              ind <
                  loginCredential!["data"]["data"][0]["faculty_data"]
                  ["hodComponent"]["own_list_groups"][index]
                  ["class_group"]
                      .length;
              ind++) {
                var classBatch = loginCredential!["data"]["data"][0]
                ["faculty_data"]["hodComponent"]["own_list_groups"]
                [index]["class_group"][ind]["academic"];
                classB.add(classBatch.split("/")[2].toString() +
                    " " +
                    classBatch.split("/")[3].toString());
              }
            }

            print('.....employeeUnderHOS....${employeeUnderHOS}');

            print('.....classB${classB}');

            print('.....${loginCredential}');

            setState(() {
              isSpinner = false;
            });
          }
        }
      }
      //addToLocalDb();
    }
  }

  Map<String, dynamic>? committedCalls;

  Future commitedCallsDetail(String employeeCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_token = preferences.getString("school_token");
    var empid = preferences.getString("employeeNumber");
    print("api worked");
    print("api employeeCode$employeeCode");
    isSpinner = true;
    var headers = {
      'Content-Type': 'application/json',
      'API-Key': '525-777-777'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.DOCME_URL));
    request.body =
        '''{\n  "action" :"getEmployeeFeedbackById",\n  "token":"$school_token",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [1]\n }\n''';
    print("commitedCallsDetailrequest.body${request.body}");

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode);
      // print(await response.stream.bytesToString());
      var responseJson = await response.stream.bytesToString();
      committedCalls = json.decode(responseJson);
      log('committedCallsresponse-----${committedCalls}');
      if (mounted)
        setState(() {
          isSpinner = false;
        });
    } else {
      return Text("Failed to Load Data");
    }
  }

  Map<String, dynamic>? callNotAnswered;

  Future callNotAnswerDetail(String employeeCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_token = preferences.getString("school_token");
    print("api worked");
    isSpinner = true;
    var headers = {
      'Content-Type': 'application/json',
      'API-Key': '525-777-777'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.DOCME_URL));
    request.body =
        '''{\n  "action" :"getEmployeeFeedbackById",\n  "token":"$school_token",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [4]\n }\n''';
    // print(request.body);
    print("callNotAnswerDetailrequest.body${request.body}");

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode);
      // print(await response.stream.bytesToString());
      var responseJson = await response.stream.bytesToString();
      callNotAnswered = json.decode(responseJson);
      log('callNotAnsweredresponse-----${callNotAnswered}');
      if (mounted)
        setState(() {
          isSpinner = false;
        });
    } else {
      return Text("Failed to Load Data");
    }
  }

  Map<String, dynamic>? wrongNumber;

  Future wrongNumberDetails(String employeeCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_token = preferences.getString("school_token");
    print("api worked");
    isSpinner = true;
    var headers = {
      'Content-Type': 'application/json',
      'API-Key': '525-777-777'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.DOCME_URL));
    request.body =
        '''{\n  "action" :"getEmployeeFeedbackById",\n  "token":"$school_token",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [2,3]\n }\n''';
    // print(request.body);
    print("wrongNumberDetailsrequest.body${request.body}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode);
      // print(await response.stream.bytesToString());
      var responseJson = await response.stream.bytesToString();
      wrongNumber = json.decode(responseJson);
      log('wrongNumberresponse-----${wrongNumber}');
      if (mounted)
        setState(() {
          isSpinner = false;
        });
    } else {
      return Text("Failed to Load Data");
    }
  }

  Map<String, dynamic>? misbehave;

  Future misbehaveDetails(String employeeCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_token = preferences.getString("school_token");
    print("api worked");
    isSpinner = true;
    var headers = {
      'Content-Type': 'application/json',
      'API-Key': '525-777-777'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.DOCME_URL));
    request.body =
        '''{\n  "action" :"getEmployeeFeedbackById",\n  "token": "$school_token",\n  "employee_code": "$employeeCode",\n  "feedback_type_id": [5,6,7]\n }\n''';
    // print(request.body);
    print("misbehaveDetailsrequest.body${request.body}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode);
      // print(await response.stream.bytesToString());
      var responseJson = await response.stream.bytesToString();
      misbehave = json.decode(responseJson);
      log('misbehaveresponse-----${misbehave}');
      if (mounted)
        setState(() {
          isSpinner = false;
        });
    } else {
      return Text("Failed to Load Data");
    }
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
                    onTap: () => ZoomDrawer.of(context)!.toggle(),
                    child: Container(
                        margin: const EdgeInsets.all(6),
                        child: Image.asset("assets/images/newmenu.png")),
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              widget.loginname.toString(),
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
                          name: widget.loginname,
                          image: widget.image,
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
                    color: Colors.white,
                    border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Reports",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          widget.HOSNAME != null ?
                          Text(
                            'Hos: ${widget.HOSNAME}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500,color: Colors.blueAccent),
                          ):Container()
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: TextFormField(
                        controller: _searchController,
                        // validator: (val) =>
                        // val!.isEmpty ? 'Enter the Topic' : null,
                        // controller: _textController,
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            newReport = newTeacherList
                                .where((element) => element["employee_name"]
                                    .contains("${value.toUpperCase()}"))
                                .toList();
                            print(newReport);
                          });
                        },
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
                    Expanded(
                        child: teacherList == null
                            ? Center(
                                child: CardListSkeleton(
                                isCircularImage: true,
                                isBottomLinesActive: true,
                                length: 10,
                              ))
                            : teacherList!["data_status"] == 0
                                ? Center(
                                    child:
                                        Image.asset("assets/images/nodata.gif"))
                                : teacherList!["message"] ==
                                        "employee_code Required"
                                    ? Center(
                                        child: Image.asset(
                                            "assets/images/nodata.gif"))
                                    : ListView.builder(
                                        key: Key(
                                            'builder ${selected.toString()}'),
                                        itemCount:
                                            _searchController.text.isNotEmpty
                                                ? newReport.length
                                                : teacherList!["data"].length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _getProfileOfStudents(
                                              "assets/images/nancy.png",
                                              _searchController.text.isNotEmpty
                                                  ? toBeginningOfSentenceCase(
                                                          newReport[index]["employee_name"]
                                                              .toString()
                                                              .toLowerCase())
                                                      .toString()
                                                  : toBeginningOfSentenceCase(
                                                          teacherList!["data"][index]["employee_name"]
                                                              .toString()
                                                              .toLowerCase())
                                                      .toString(),
                                              _searchController.text.isNotEmpty
                                                  ? newReport[index]["total_count"]
                                                      .toString()
                                                  : teacherList!["data"][index]
                                                          ["total_count"]
                                                      .toString(),
                                              _searchController.text.isNotEmpty
                                                  ? newReport[index]["employee_code"]
                                                      .toString()
                                                  : teacherList!["data"][index]
                                                          ["employee_code"]
                                                      .toString(),
                                              index);
                                        },
                                      )),
                    SizedBox(
                      height: 140.h,
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _getProfileOfStudents(String image, String nameOfTeacher,
      String totalProcessed, String employeeCode, int index) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: Key(index.toString()),
        //attention
        initiallyExpanded: false,
        onExpansionChanged: ((newState) {
          print(newState);
          if (newState)
            setState(() {
              Duration(seconds: 20000);
              selected = index;
              commitedCallsDetail(employeeCode);
              wrongNumberDetails(employeeCode);
              misbehaveDetails(employeeCode);
              callNotAnswerDetail(employeeCode);
            });
          else
            setState(() {
              selected = -1;
            });
        }),
        iconColor: ColorUtils.ICON_COLOR,
        leading: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.r)),
          ),
          margin: EdgeInsets.only(top: 5.h),
          child: GestureDetector(
            onTap: () => NavigationUtils.goNext(
                context,
                StudentListForHOS(
                  name: widget.loginname.toString(),
                  image: widget.image.toString(),
                  LoginedUserEmployeeCode: employeeCode,
                  classTeacherName: nameOfTeacher.toString(),
                  totalProcessed: totalProcessed,
                  CustomeImageContainer: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nameOfTeacher.toString()[0],
                          style: TextStyle(
                              color: Color(0xFFB1BFFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          nameOfTeacher.toString()[1].toUpperCase(),
                          style: TextStyle(
                              color: Color(0xFFB1BFFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                )),
            child: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFEEF1FF)),
                  color: Color(0xFFEEF1FF)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nameOfTeacher.toString()[0],
                      style: TextStyle(
                          color: Color(0xFFB1BFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      nameOfTeacher.toString()[1].toUpperCase(),
                      style: TextStyle(
                          color: Color(0xFFB1BFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
                width: 200.w,
                child: Text(nameOfTeacher,
                    style: GoogleFonts.spaceGrotesk(
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            color: ColorUtils.BLACK,
                            fontWeight: FontWeight.bold)))),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              "Total Processed :",
              style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                      fontSize: 12.sp, color: ColorUtils.BLACK_GREY100)),
            ),
            Text(
              totalProcessed,
              style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                      fontSize: 12.sp,
                      color: ColorUtils.RED,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        children: [
          ProfileContainer(
            committedCalls == null || committedCalls!["data"] == false
                ? 0
                : committedCalls!["data"].length,
            callNotAnswered == null || callNotAnswered!["data"] == false
                ? 0
                : callNotAnswered!["data"].length,
            wrongNumber == null || wrongNumber!["data"] == false
                ? 0
                : wrongNumber!["data"].length,
            misbehave == null || misbehave!["data"] == false
                ? 0
                : misbehave!["data"].length,
            widget.teacherName.toString(),
            widget.image.toString(),
            employeeCode,
            nameOfTeacher.toString(),
            totalProcessed,
          ),
        ],
      ),
    );
  }

  Widget ProfileContainer(
      final int committed,
      final int callnot,
      final int wrong,
      final int misbehave,
      var name,
      var image,
      var employeecode,
      var teachername,
      var processed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFFF4F6FB)),
                child: Image.asset("assets/images/vectorthree.png")),
            Text(
              committed.toString(),
              style: TextStyle(
                  color: ColorUtils.COMMIT, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
        SizedBox(
          width: 10.w,
          height: 10.h,
        ),
        Column(
          children: [
            Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFFF4F6FB)),
                child: Image.asset("assets/images/vectortwo.png")),
            Text(
              callnot.toString(),
              style: TextStyle(
                  color: ColorUtils.NOTANSWERED, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(
          width: 20.w,
          height: 10.h,
        ),
        Column(
          children: [
            Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFFF4F6FB)),
                child: Image.asset("assets/images/vectorfour.png")),
            Text(
              wrong.toString(),
              style: TextStyle(
                  color: ColorUtils.WRONG, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(
          width: 20.w,
          height: 10.h,
        ),
        Column(
          children: [
            Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFFF4F6FB)),
                child: Image.asset("assets/images/vectorone.png")),
            Text(
              misbehave.toString(),
              style: TextStyle(
                  color: ColorUtils.MISBEHAVE, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(
          width: 10.w,
          height: 15.h,
        ),
        GestureDetector(
          onTap: () => NavigationUtils.goNext(
              context,
              StudentListForHOS(
                name: widget.loginname.toString(),
                image: widget.image.toString(),
                LoginedUserEmployeeCode: employeecode,
                classTeacherName: teachername,
                totalProcessed: processed,
                CustomeImageContainer: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        teachername.toString()[0],
                        style: TextStyle(
                            color: Color(0xFFB1BFFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        teachername.toString()[1].toUpperCase(),
                        style: TextStyle(
                            color: Color(0xFFB1BFFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              )),
          child: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFFF4F6FB)),
              child: SvgPicture.asset("assets/images/next.svg")),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
}

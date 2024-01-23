import 'dart:developer';
import 'package:bmteacher/Database/database_helper.dart';
import 'package:bmteacher/Network/api_constants.dart';
import 'package:bmteacher/Utils/color_utils.dart';
import 'package:bmteacher/ui/Chat_Screen/chat_List.dart';
import 'package:bmteacher/ui/HomeScreen/Leave_Request/Leave_Request.dart';
import 'package:bmteacher/ui/HomeScreen/class_teacher_menu_page.dart';
import 'package:bmteacher/ui/HomeScreen/home_screen.dart';
import 'package:bmteacher/ui/HomeScreen/menu_model.dart';
import 'package:bmteacher/ui/TimeTableView/time_table_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/database_helper.dart';
import '../../Database/database_model.dart';
import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../LoginPage/login.dart';
import '../TimeTableView/time_table_view.dart';
import 'Leave_Request/Leave_Request.dart';
import 'Observation_Result/Observation_Result.dart';
import 'class_teacher_menu_page.dart';
import 'home_screen.dart';
import 'menu_page.dart';

class DrawerPage extends StatefulWidget{
  String? userId;
  String? loginedUserEmployeeNo;
  String? loginedUserName;
  var designation;
  String? schoolId;
  String? images;
  String? email;
  String? academic_year;
  var teacherData;
  var teacherClasses;
  var roll_id;
  var usermailid;
  bool? isnotaclassteacher;
  // bool? isclassTEACHER;
  DrawerPage(
      {Key? key,
      this.loginedUserName,
      this.designation,
      this.userId,
      this.usermailid,
      this.isnotaclassteacher,
      this.roll_id,
      this.loginedUserEmployeeNo,
      this.schoolId,
      this.images,
      this.email,
      this.academic_year,
      this.teacherData,
      // this.isclassTEACHER,
      this.teacherClasses})
      : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final drawerController = ZoomDrawerController();
  MenuItem currentItem = MenuItems.myClasses;
  MenuItem teacherItems = TeacherItems.myClasses;
  var fcmToken;
  //late List<LoginData> loginData;

  @override
  void initState() {
    MatomoTracker().initialize(
      siteId: 5,
      url: 'https://log.bmark.in/',
      visitorId: widget.email,
    );
    // fbToken();
    getUserLoginCredentials();
    print(widget.teacherData);
    print('22222222');
    // print('isnotaclasstwidgeteacher${widget.isnotaclassteacher}');
    super.initState();
  }
  Future<dynamic> fbToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }
  logData() {
    print("log created");
  }

  // isDataExist(){
  //   if(loginData == null){
  //     print("data not exist");
  //     getUserLoginCredentials();
  //   }else{
  //     print("data exist");
  //   }
  // }

  var classB = [];
  var isclassteacher;
  var teacherData = [];
  var duplicateTeacherData = [];
  var newTeacherData;
  var newTeacherDataDrawerpage;
  var firebase_tockenss;
  String? img;
   // late bool isnotaclassteacher;
  bool isSpinner = false;
  bool isclassTEACHER = true;

  Map<String, dynamic>? loginCredential;

  var employeeUnderHOS = [];

  Future addToLocalDb() async {
    print("database created");

    String newTeacherData = jsonEncode(teacherData);
    String newEmployeeData = jsonEncode(employeeUnderHOS);
    String newOtherTeacherData = jsonEncode(classB);

    final loginData = LoginData(
        onlyTeacherData: newTeacherData,
        otherTeacherData: newOtherTeacherData,
        employeeUnderHead: newEmployeeData);
    await LoginDatabase.instance.create(loginData);
  }

  // Future getLoginDatabase() async {
  //   this.loginData = await LoginDatabase.instance.readAllNotes();
  // }
  getDeviceDetail() async {
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json',
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.DeviceId));
    request.body = json.encode({
      "username": widget.usermailid,
      "device_id": firebase_tockenss
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    print('Deviceid-----request.body${request.body}');
    if (response.statusCode == 200){
      print('Deviceid-----response${response}');
    }
  }
  Future getUserLoginCredentials() async {
    firebase_tockenss  = await fbToken();
    print('tockenss Drawer------${firebase_tockenss}');

    // preferences.setBool('isclassteacher', loginCredential!["data"]["data"][0]["faculty_data"]
    // ["teacherComponent"]['is_class_teacher']);
    // print('qwert${loginCredential!["data"]["data"][0]["faculty_data"]
    // ["teacherComponent"]['is_class_teacher']}');
    getDeviceDetail();
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _checkInternet(context);
    } else if (result == ConnectivityResult.wifi) {
      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.WORKLOAD_API));
      request.body = json.encode({"user_id": widget.userId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        setState(() {
          isSpinner = false;
        });
        loginCredential = json.decode(responseData);
        print(loginCredential!["data"]["data"][0]["faculty_data"]
            ["teacherComponent"]["is_class_teacher"]);

        img = loginCredential!["data"]["data"][0]["image"];

        print(">>>>>>>$img<<<<<<<");
        // log(">>>techerclasss>>>>${loginCredential!["data"]["data"][0]["faculty_data"]
        // ["teacherComponent"]['own_list'][1]['is_class_teacher']}<<<<<<<");
       // isnotaclassteacher = loginCredential!["data"]["data"][0]["faculty_data"]
       //  ["teacherComponent"]['is_class_teacher'];
       // print('-------------$isnotaclassteacher');
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
                    false)
            {
              print("teacher -- teacherrrrr");


              for (var index = 0;
                  index <
                      loginCredential!["data"]["data"][0]["faculty_data"]
                              ["teacherComponent"]["own_list"]
                          .length;
                  index++) {
                var classBatch = loginCredential!["data"]["data"][0]
                        ["faculty_data"]["teacherComponent"]["own_list"][index]
                    ["academic"];

                // isclassteacher = loginCredential!["data"]["data"][0]
                // ["faculty_data"]["teacherComponent"]["own_list"][index]
                // ["is_class_teacher"];

                var sessionId = loginCredential!["data"]["data"][0]
                        ["faculty_data"]["teacherComponent"]["own_list"][index]
                    ["session"]["_id"];

                var curriculumId = loginCredential!["data"]["data"][0]
                        ["faculty_data"]["teacherComponent"]["own_list"][index]
                    ["curriculum"]["_id"];

                var batchID = loginCredential!["data"]["data"][0]
                        ["faculty_data"]["teacherComponent"]["own_list"][index]
                    ["batch"]["_id"];

                var classID = loginCredential!["data"]["data"][0]
                        ["faculty_data"]["teacherComponent"]["own_list"][index]
                    ["class"]["_id"];

                duplicateTeacherData.add({
                  "class": classBatch.split("/")[2].toString() +
                      " " +
                      classBatch.split("/")[3].toString(),
                  "session_id": sessionId,
                  "curriculumId": curriculumId,
                  "batch_id": batchID,
                  "class_id": classID,
                  "is_Class_teacher": loginCredential!["data"]["data"][0]
                          ["faculty_data"]["teacherComponent"]["own_list"]
                      [index]["is_class_teacher"]
                });

                for (var ind = 0;
                    ind <
                        loginCredential!["data"]["data"][0]["faculty_data"]
                                    ["teacherComponent"]["own_list"][index]
                                ["subjects"]
                            .length;
                    ind++) {
                  var subjects = loginCredential!["data"]["data"][0]
                          ["faculty_data"]["teacherComponent"]["own_list"]
                      [index]["subjects"][ind]["name"];

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
              log("newTeacherData ${newTeacherData.length}");
              newTeacherDataDrawerpage = newClassTeacherCLass;
              log("newTeacherDataDrawerpage.length ${newTeacherDataDrawerpage.length}");

              log(">>>>>>>>>>>>>>>homescreen/menupage$teacherData");
              print(" the length of class_group menupage$employeeUnderHOS");
              print(" tnewTeacherDataDrawerpage$newTeacherDataDrawerpage");
              // print(" the isclassteacher of teacherData ${widget.teacherData}");

              // SharedPreferences preferences = await SharedPreferences.getInstance();
              if(newTeacherDataDrawerpage.isEmpty){
                setState(() {
                  isclassTEACHER = false;
                });
              }else{
                setState(() {
                  isclassTEACHER = true;
                });
              }
              log(">>>>>>>>>>>>>>>homescreen/drawer$teacherData");
              print(" the length of class_group $employeeUnderHOS");
              print(" the isclassteacher of isclassteacher $newTeacherData");
              print(" the isclassteacher of teacherData ${widget.teacherData}");

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
                  var employeeUnderHod = loginCredential!["data"]["data"][0]
                              ["faculty_data"]["supervisorComponent"]
                          ["own_list_groups"][ind]["class_group"][index]
                      ["class_teacher"]["employee_no"];
                  employeeUnderHOS.add(employeeUnderHod);
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
                          ["own_list_groups"][index]["class_group"][ind]
                      ["academic"];
                  classB.add(classBatch.split("/")[2].toString() +
                      " " +
                      classBatch.split("/")[3].toString());
                }
              }

              print(employeeUnderHOS);

              print(
                  "???????????????????????????????????????????????????$classB");

              print(loginCredential);

              setState(() {
                isSpinner = false;
              });
            }
          }
          if (faculty_data.containsKey("hosComponent")) {
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
                  var employeeUnderHod = loginCredential!["data"]["data"][0]
                              ["faculty_data"]["hosComponent"]
                          ["own_list_groups"][ind]["class_group"][index]
                      ["class_teacher"]["employee_no"];
                  employeeUnderHOS.add(employeeUnderHod);
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

              print(employeeUnderHOS);

              print(classB);

              print('---loginCredential----${loginCredential}');

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
                  var employeeUnderHod = loginCredential!["data"]["data"][0]
                              ["faculty_data"]["hodComponent"]
                          ["own_list_groups"][ind]["class_group"][index]
                      ["class_teacher"][index]["employee_no"];
                  employeeUnderHOS.add(employeeUnderHod);
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

              print(employeeUnderHOS);

              print(classB);

              print(loginCredential);


              setState(() {
                isSpinner = false;
              });
            }
          }
        }
        addToLocalDb();
      }
      if (response.statusCode == 504) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    title: Text('Warning'),
                    content: Text('Data Not Found'),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.arrow_back),
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
                            NavigationUtils.goNextFinishAll(
                                context, LoginPage());
                          })
                    ],
                  ),
                ));
      }
    } else if (result == ConnectivityResult.mobile) {
      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.WORKLOAD_API));
      request.body = json.encode({"user_id": widget.userId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        setState(() {
          isSpinner = false;
        });
        loginCredential = json.decode(responseData);
        print(loginCredential!["data"]["data"][0]["faculty_data"]
            ["teacherComponent"]["is_class_teacher"]);

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
              print("teacher");

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

                var batchID = loginCredential!["data"]["data"][0]
                        ["faculty_data"]["teacherComponent"]["own_list"][index]
                    ["batch"]["_id"];

                var classID = loginCredential!["data"]["data"][0]
                        ["faculty_data"]["teacherComponent"]["own_list"][index]
                    ["class"]["_id"];

                duplicateTeacherData.add({
                  "class": classBatch.split("/")[2].toString() +
                      " " +
                      classBatch.split("/")[3].toString(),
                  "session_id": sessionId,
                  "curriculumId": curriculumId,
                  "batch_id": batchID,
                  "class_id": classID,
                  "is_Class_teacher": loginCredential!["data"]["data"][0]
                          ["faculty_data"]["teacherComponent"]["own_list"]
                      [index]["is_class_teacher"]
                });

                for (var ind = 0;
                    ind <
                        loginCredential!["data"]["data"][0]["faculty_data"]
                                    ["teacherComponent"]["own_list"][index]
                                ["subjects"]
                            .length;
                    ind++) {
                  var subjects = loginCredential!["data"]["data"][0]
                          ["faculty_data"]["teacherComponent"]["own_list"]
                      [index]["subjects"][ind]["name"];

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
              log("tdhdhdhdhdhdbhdhd $newTeacherData");

              newTeacherDataDrawerpage = newClassTeacherCLass;
              log("tdhdhdhdhdhdbhdhdmenupage ${newTeacherDataDrawerpage.length}");

              log(">>>>>>>>>>>>>>>homescreen/menupage$teacherData");
              print(" the length of class_group menupage$employeeUnderHOS");
              print(" the isclassteacher of isclassteacher menupage$newTeacherDataDrawerpage");
              // print(" the isclassteacher of teacherData ${widget.teacherData}");

              // SharedPreferences preferences = await SharedPreferences.getInstance();
              if(newTeacherDataDrawerpage.isEmpty){
                setState(() {
                  isclassTEACHER = false;
                });
              }else{
                setState(() {
                  isclassTEACHER = true;
                });
              }
              log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>homescreen/drawer>>>>>>>>>>>>>>>>>>>>>>>>>>>>$teacherData");
              print(" the length of class_group $employeeUnderHOS");

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
                  var employeeUnderHod = loginCredential!["data"]["data"][0]
                              ["faculty_data"]["supervisorComponent"]
                          ["own_list_groups"][ind]["class_group"][index]
                      ["class_teacher"]["employee_no"];
                  employeeUnderHOS.add(employeeUnderHod);
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
                          ["own_list_groups"][index]["class_group"][ind]
                      ["academic"];
                  classB.add(classBatch.split("/")[2].toString() +
                      " " +
                      classBatch.split("/")[3].toString());
                }
              }

              print(employeeUnderHOS);

              print(
                  "???????????????????????????????????????????????????$classB");

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
                  var employeeUnderHod = loginCredential!["data"]["data"][0]
                              ["faculty_data"]["hodComponent"]
                          ["own_list_groups"][ind]["class_group"][index]
                      ["class_teacher"]["employee_no"];
                  employeeUnderHOS.add(employeeUnderHod);
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

              print(employeeUnderHOS);

              print(classB);

              print(loginCredential);

              setState(() {
                isSpinner = false;
              });
            }
          }
          if (faculty_data.containsKey("hosComponent")) {
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
                  var employeeUnderHod = loginCredential!["data"]["data"][0]
                              ["faculty_data"]["hosComponent"]
                          ["own_list_groups"][ind]["class_group"][index]
                      ["class_teacher"]["employee_no"];
                  employeeUnderHOS.add(employeeUnderHod);
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

              print(employeeUnderHOS);

              print(classB);

              print(loginCredential);

              setState(() {
                isSpinner = false;
              });
            }
          }
        }
        addToLocalDb();
      }
      if (response.statusCode == 504) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    title: Text('Warning'),
                    content: Text('Data Not Found'),
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.arrow_back),
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
                            NavigationUtils.goNextFinishAll(
                                context, LoginPage());
                          })
                    ],
                  ),
                ));
      }
    }
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue : Colors.lightBlueAccent,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        controller: drawerController,
        style: DrawerStyle.Style1,
        mainScreen: Stack(
          children: [
            getScreen(),
            // Positioned(
            //   bottom: 10,
            //   right: 10,
            //   child: FloatingActionButton(onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => chatList()))
            //     ;
            //   },child: Text('+'),
            //   ),
            // ),
          ],
        ),
        menuScreen: Builder(builder: (context) {
          return MenuPage(
              ptofileImage: img,
              name: widget.loginedUserName,
              currentItem: currentItem,
              isAClassTeacher: widget.teacherData == null
                  ? newTeacherData
                  : widget.teacherData,
              academicYear: widget.academic_year,
              schoolId: widget.schoolId,
              user_id: widget.userId,
              notclassteacher: newTeacherData,
              isclassTEACHER:isclassTEACHER,
              // notclassteacher:isnotaclassteacher,
              onSelected: (item) {
                setState(() {
                  currentItem = item;

                });
                ZoomDrawer.of(context)!.close();
              });
        }),
        borderRadius: 24.r,
        showShadow: true,
        angle: 0.0,
        backgroundColor: ColorUtils.BLUE,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.easeInBack,
      ),
    );
  }

  Widget teacherScreen() {
    switch (currentItem) {
      case TeacherItems.myClasses:
        return HomeScreen(
          images: widget.images,
          name: widget.loginedUserName,
          classAndDivision: classB,
          LogedInUserDesig: widget.designation,
          LogedInUserEmpCode: widget.loginedUserEmployeeNo,
          teacherData:
              widget.teacherData == null ? newTeacherData : widget.teacherData,
          school_id: widget.schoolId,
          user_id: widget.userId,
          teacherClasses: widget.teacherClasses == null
              ? teacherData
              : widget.teacherClasses,
          employeeUnderHos: employeeUnderHOS,
          academic_year: widget.academic_year,
          notclassteacher: newTeacherData,
          // notclassteacher:isnotaclassteacher,
        );
      case TeacherItems.timeTable:
        return TimeTableView(
          images: widget.images,
          name: widget.loginedUserName,
          classAndDivision: classB,
          LogedInUserDesig: widget.designation,
          LogedInUserEmpCode: widget.loginedUserEmployeeNo,
          teacherData:
              widget.teacherData == null ? newTeacherData : widget.teacherData,
          school_id: widget.schoolId,
          user_id: widget.userId,
          teacherClasses: widget.teacherClasses == null
              ? teacherData
              : widget.teacherClasses,
          employeeUnderHos: employeeUnderHOS,
          academic_year: widget.academic_year,

        );

      case TeacherItems.Leave:
        return  leaverequest(
          roleUnderLoginTeacher: employeeUnderHOS,
          loginedUserName: widget.loginedUserName,
          teacherData: newTeacherData,
          // notclassteacher:isnotaclassteacher,
         );
      case TeacherItems.ObservatioResult:
        return  observationResult(
          loginedUserName: widget.loginedUserName,
          images: widget.images,
          name: widget.loginedUserName,

        );
      // case TeacherItems.Chat:
      //   return  chatList(
      //     name: widget.loginedUserName,
      //   );
      // case MenuItems.profile:
      //   return ProfilePage();
      default:
        return HomeScreen(
          images: widget.images,
          name: widget.loginedUserName,
          classAndDivision: classB,
          LogedInUserDesig: widget.designation,
          LogedInUserEmpCode: widget.loginedUserEmployeeNo,
          teacherData:
              widget.teacherData ?? newTeacherData,
          school_id: widget.schoolId,
          user_id: widget.userId,
          teacherClasses: teacherData,
          employeeUnderHos: employeeUnderHOS,
          academic_year: widget.academic_year,
          notclassteacher: newTeacherData,
          // notclassteacher: isnotaclassteacher,
        );
    }
  }

  Widget getScreen() {
    // var newOtherteacherData = loginData != null ? json.decode(loginData![0].otherTeacherData) : classB;
    // var newteacherData = loginData != null ? json.decode(loginData![0].onlyTeacherData) : teacherData;
    // var newEmployeeData = loginData != null ? json.decode(loginData![0].employeeUnderHead) : employeeUnderHOS;
    switch (currentItem) {
      case MenuItems.myClasses:
        return HomeScreen(
          images: widget.images,
          name: widget.loginedUserName,
          classAndDivision: classB,
          LogedInUserDesig: widget.designation,
          LogedInUserEmpCode: widget.loginedUserEmployeeNo,
          teacherData:
              widget.teacherData == null ? newTeacherData : widget.teacherData,
          school_id: widget.schoolId,
          user_id: widget.userId,
          teacherClasses: widget.teacherClasses == null
              ? teacherData
              : widget.teacherClasses,
          employeeUnderHos: employeeUnderHOS,
          academic_year: widget.academic_year,
          notclassteacher: newTeacherData,
          // notclassteacher: isnotaclassteacher,
        );
      case MenuItems.timetable:
        return TimeTableView(
          images: widget.images,
          name: widget.loginedUserName,
          classAndDivision: classB,
          LogedInUserDesig: widget.designation,
          LogedInUserEmpCode: widget.loginedUserEmployeeNo,
          teacherData:
              widget.teacherData == null ? newTeacherData : newTeacherData,
          school_id: widget.schoolId,
          user_id: widget.userId,
          teacherClasses: widget.teacherClasses == null
              ? teacherData
              : widget.teacherClasses,
          employeeUnderHos: employeeUnderHOS,
          academic_year: widget.academic_year,
        );
       case MenuItems.Leave:
        return leaverequest(
          roleUnderLoginTeacher: employeeUnderHOS,
          loginedUserName: widget.loginedUserName,
          school_id: widget.schoolId,
          user_id: widget.userId,
          classAndDivision: classB,
          images: widget.images,
          name: widget.loginedUserName,
          teacherData:
          widget.teacherData == null ? newTeacherData : widget.teacherData,
          teacherClasses: widget.teacherClasses == null
              ? teacherData
              : widget.teacherClasses,

          academic_year: widget.academic_year,
          // notclassteacher:isnotaclassteacher,
        );
      case MenuItems.ObservatioResult:
        return  observationResult(
          loginedUserName: widget.loginedUserName,
          images: widget.images,
          name: widget.loginedUserName,
        );
      // case TeacherItems.Chat:
      //   return  chatList(
      //     name: widget.loginedUserName,
      //   ); // case MenuItems.profile:
      //   return ProfilePage();
      default:
        return HomeScreen(
          images: widget.images,
          name: widget.loginedUserName,
          classAndDivision: classB,
          LogedInUserDesig: widget.designation,
          LogedInUserEmpCode: widget.loginedUserEmployeeNo,
          teacherData: newTeacherData,
          school_id: widget.schoolId,
          user_id: widget.userId,
          teacherClasses: teacherData,
          employeeUnderHos: employeeUnderHOS,
          academic_year: widget.academic_year,
          notclassteacher: newTeacherData,
          // notclassteacher:isnotaclassteacher,
        );
    }
  }

  _checkInternet(context) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "No Internet",
      style: const AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          child: const Text(
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
}

import 'dart:developer';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../DrawerPageHOSLogin/drawer_page.dart';
import '../LoginPage/login.dart';
import 'drawer_page.dart';
import 'home_screen.dart';

class ChoicePage extends StatefulWidget {
  String? userID;
  String? loginEmployeeID;
  var designation;
  String? name;
  String? schoolID;
  String? image;
  String? email;
  String? loginedUserName;
  String? academic_year;
  var role_id;
  var loginname;
  var usermailid;
  ChoicePage(
      {Key? key,
      this.userID,
      this.loginname,
      this.usermailid,
      this.loginedUserName,
      this.designation,
      this.name,
      this.image,
      this.loginEmployeeID,
      this.schoolID,
      this.email,
      this.academic_year,
      this.role_id})
      : super(key: key);

  @override
  _ChoicePageState createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  var classB = [];
  var teacherData = [];
  var duplicateTeacherData = [];
  var newTeacherData;
  var newTeacherDatamenupage;
  String? img;
  bool isSpinner = false;
  bool isclassTEACHER = false;
  var roles;
  var tname;
  var fcmToken;
  var firebase_tockenss;

  Map<String, dynamic>? loginCredential;

  var employeeUnderHOS = [];
  // bool? isnotaclassteacher = false;
  Future<dynamic> fbToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }
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
    firebase_tockenss = await fbToken();
    print('tockenss choice------${firebase_tockenss}');
    print('--userID----userID----${widget.userID}');
    print('---loginEmployeeID----loginEmployeeID---${widget.loginEmployeeID}');
    getDeviceDetail();
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _checkInternet(context);
    } else {
      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.WORKLOAD_API));
      request.body = json.encode({"user_id": widget.userID});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
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
        print(loginCredential!["data"]["data"][0]["all_roles_array"]);
        print('---------------end of----role ids-----------------');
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
                print('${loginCredential!["data"]["data"][0]["faculty_data"]
                ["teacherComponent"]["own_list"][0]
                ["subjects"]}');
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
                            ["faculty_data"]["teacherComponent"]["is_class_teacher"]

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
              newTeacherDatamenupage = newClassTeacherCLass;
            log("tdhdhdhdhdhdbhdhdmenupage ${newTeacherDatamenupage.length}");

            log(">>>>>>>>>>>>>>>homescreen/menupage$teacherData");
            print(" the length of class_group menupage$employeeUnderHOS");
            print(" the isclassteacher of isclassteacher menupage$newTeacherDatamenupage");
            // print(" the isclassteacher of teacherData ${widget.teacherData}");

            // SharedPreferences preferences = await SharedPreferences.getInstance();
            if(newTeacherDatamenupage.isEmpty){
              setState(() {
                isclassTEACHER = false;
              });
            }else{
              setState(() {
                isclassTEACHER = true;
              });
            }
              log(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>choicee>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$teacherData");
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
                          ["own_list_groups"][index]["class_group"][ind]
                      ["academic"];
                  classB.add(classBatch.split("/")[2].toString() +
                      " " +
                      classBatch.split("/")[3].toString());
                }
              }

              print('employeeUnderHOS__---__$employeeUnderHOS');

              print(
                  "???????????????????????????????????????????????????$classB");

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

                    print('------empidddd--$employeeUnderHod');
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

              log("<<<<<<<<<<<<<<<<<<<< $employeeUnderHOS");

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

              print(employeeUnderHOS);

              print(classB);

              print(loginCredential);

              setState(() {
                isSpinner = false;
              });
            }
          }
        }
        //addToLocalDb();
      }
    }
  }
 checkattendance()async{
   final prefs = await SharedPreferences.getInstance();
   await prefs.remove('lateattendance');
 }
  checkCache() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("loginApi");
    print('cache--------------$isCacheExist');
    if (!isCacheExist) {
      return;
    } else {
      var CacheData = await APICacheManager().getCacheData("loginApi");
      var decodedresp = json.decode(CacheData.syncData);
      // print('cache data--------->$decodedresp');
      //print(decodedresp.runtimeType);
      // print('${jsonDecode(decodedresp)!["data"]}');
      roles = jsonDecode(decodedresp)!["data"]["data"][0]["all_roles_array"];
      tname = jsonDecode(decodedresp)!["data"]["data"][0]["name"];
      print('teachernameeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee---------$tname');
      print('roleid inside cache------->$roles');
    }
  }

  @override
  void initState() {
    print('-------all role ids in choice------${widget.role_id}');
    checkCache();
    // checkattendance();
    MatomoTracker().initialize(
       siteId: 5,
      url: 'https://log.bmark.in/',
      visitorId: widget.email,
    );
    getUserLoginCredentials();
    // _checkNewVersion();
    super.initState();
  }

  // void _checkNewVersion() async {
  //   final newVersion = NewVersionPlus(iOSId: "com.educore.bmteacher",androidId: "com.educore.bmteacher");
  //   final status = await newVersion.getVersionStatus();
  //   if (status?.localVersion != status?.storeVersion) {
  //     newVersion.showUpdateDialog(
  //         context: context,
  //         versionStatus: status!,
  //         dialogTitle: 'Update BM Teacher?',
  //         dialogText: 'Latest Version: ${status.storeVersion} \n'
  //             ' \ncurrent version: ${status.localVersion}'
  //             'BM Teacher recommends that you update to the latest version.To get the best from your Device, Please keep your App up to Date.',
  //         updateButtonText: 'UPDATE NOW',dismissButtonText: 'Maybe Later',
  //         allowDismissal: true,dismissAction: () {
  //       Navigator.pop(context);
  //     },launchModeVersion: LaunchModeVersion.normal);
  //   }
  // }

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
                margin: EdgeInsets.only(
                  left: 10.w,
                  top: 100.h,
                  right: 10.w,
                ),
                // width: 550.w,
                height: MediaQuery.of(context).size.height / 1.22,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                    borderRadius: BorderRadius.all(Radius.circular(20.r))),
                child: loginCredential == null
                    ? Center(
                        child: _Loader(),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset("assets/images/select_role.json"),
                          SizedBox(
                            height: 100.h,
                          ),
                          Center(
                            child: SizedBox(
                              child: Text(
                                "Select your role",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ColorUtils.SEARCH_TEXT_COLOR),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          teacherData == null || teacherData.isEmpty
                              ? Text("")
                              : GestureDetector(
                                  onTap: () async {
                                    NavigationUtils.goNext(
                                        context,
                                        DrawerPage(
                                          userId: widget.userID,
                                          loginedUserEmployeeNo:
                                              widget.loginEmployeeID,
                                          designation: widget.designation,
                                          schoolId: widget.schoolID,
                                          loginedUserName: widget.name,
                                          images: widget.image,
                                          academic_year: widget.academic_year,
                                          teacherClasses: teacherData,
                                          teacherData: newTeacherData,
                                          // isclassTEACHER:isclassTEACHER,
                                          // isnotaclassteacher:isnotaclassteacher
                                        ));
                                  },
                                  child: SvgPicture.asset(
                                      "assets/images/hoslogin.svg")),
                          GestureDetector(
                              onTap: () {
                                NavigationUtils.goNext(
                                    context,
                                    DrawerPageForHos(
                                      admin:false,
                                      userId: widget.userID,
                                      loginedUserEmployeeNo:
                                          widget.loginEmployeeID,
                                      designation: widget.designation,
                                      schoolId: widget.schoolID,
                                      loginname:widget.name ?? tname ?? widget.loginname ?? widget.loginedUserName,
                                      images: widget.image,
                                      academic_year: widget.academic_year,
                                      roleUnderHos: employeeUnderHOS,
                                      isAClassTeacher: newTeacherData,
                                      role_id: widget.role_id ?? roles,
                                    ));
                                log(">>>>>>>>>>>>>>>>>>>>> $employeeUnderHOS");
                              },
                              child: SvgPicture.asset(
                                  "assets/images/teacherLogin.svg")),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 0,
          child: Center(
            child: Icon(
              Icons.logout,
              color: ColorUtils.RED_DARK,
            ),
          ),
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => WillPopScope(
                      onWillPop: () async => false,
                      child: AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to Logout?'),
                        actions: <Widget>[
                          IconButton(
                              onPressed: () => NavigationUtils.goBack(context),
                              icon: Icon(Icons.arrow_back_ios_outlined)),
                          IconButton(
                              icon: Icon(Icons.logout),
                              onPressed: () async {
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences.remove("school_token");
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
          },
        ),
      ),
    );
  }

  Widget _Loader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Image.asset("assets/images/loader5.gif"),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          width: 300.w,
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 13.0,
              fontFamily: 'Agne',
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                    'Teaching is a calling too. And I have always thought that teachers in their way are holy-angels leading their flocks out of the darkness. \n :- Jeannette Walls'),
                TypewriterAnimatedText(
                    'Better than a thousand days of diligent study is one day with a great Teacher. \n :- Japanese Proverb'),
                TypewriterAnimatedText(
                    'Education does not mean teaching people what they do not know. It means teaching them to behave as they do not behave. \n :- Abraham Lincoln'),
                TypewriterAnimatedText(
                    'Education is not the filling of a pail, but the lighting of a fire. \n :- William Butler Yeats'),
                TypewriterAnimatedText(
                    'The function of education is to teach one to think intensively and to think critically. Intelligence plus character - that is the goal of true Education. \n :- Martin Luther King Jr'),
                TypewriterAnimatedText(
                    'One child, one teacher, one book, and one pen change the world. \n :- Malala Yousafzai'),
                TypewriterAnimatedText(
                    'The fact that you worry about being a good teacher, means that you already are one. \n :- Jodi Picoult'),
                TypewriterAnimatedText(
                    'A well educated mind will always have more questions than answers. \n :- Helen Keller'),
              ],
              onTap: () {
                print("Tap Event");
              },
            ),
          ),
        )
      ],
    );
  }

  _checkInternet(context) {
    return Alert(
      onWillPopActive: true,
      context: context,
      type: AlertType.warning,
      title: "Please Check Your Internet Connection",
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
              // _goNext();
              Navigator.pop(context);
              getUserLoginCredentials();
              // var result = await Connectivity().checkConnectivity();
              // if (result == ConnectivityResult.none) {
              //   _checkInternet(context);
              // }else{
              //   //_goNext();
              //   getUserLoginCredentials();
              //   Navigator.pop(context);
              //
              // }
            })
      ],
    ).show();
  }

  _submitFailed(context) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "Invalid Username/password! Please try Again",
      style: const AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          child: const Text(
            "Try again",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        )
      ],
    ).show();
  }
}

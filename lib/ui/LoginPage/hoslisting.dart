import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:change_case/change_case.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../../Network/api_constants.dart';
import '../../../Utils/color_utils.dart';
import '../../../exports.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;
import '../DrawerPageHOSLogin/drawer_page.dart';
import '../LessonObservation/lessonobservation.dart';
import 'login.dart';

class hoslisting extends StatefulWidget {
  String? images;
  String? name;
  String? timeString;
  String? selectedDate;
  String? userID;
  String? loginEmployeeID;
  var designation;
  String? schoolID;
  String? email;
  String? academic_year;
  var role_id;
  var loginedUserName;
  var loginname;
  var usermailid;
  hoslisting(
      {this.images,
      this.role_id,
      this.usermailid,
      this.loginedUserName,
      this.loginname,
      this.academic_year,
      this.email,
      this.selectedDate,
      this.schoolID,
      this.designation,
      this.loginEmployeeID,
      this.userID,
      this.timeString,
      this.name,
      Key? key})
      : super(key: key);

  @override
  State<hoslisting> createState() => _hoslistingState();
}

class _hoslistingState extends State<hoslisting> {
  final _formKey = GlobalKey<FormState>();
  int Count = 0;
  bool isSpinner = false;
  Map<String, dynamic>? notificationResult;
  Timer? timer;
  var hosname;
  Map<String, dynamic> loginData = {};
  var hoslist;
  Map<String, dynamic>? hosdata;
  List<dynamic> hoslistdata = [];
  String? _hosnameSelected;
  int? _hosListSelectedIndex;
  String? teacherName;
  String? hosId;
  Map<String, dynamic>? lessonData;
  var employeeUnderHOS= [];
  var employeeUnderHOSs = [];
  var loginname;
  var academicyear;
  var fcmToken;
  getPreferenceData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("count", Count);
    setState(() {
      count = preferences.get("count");
      print('notification count---->${preferences.get("count")}');
    });
  }

  getNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    loginname = preferences.getString('name');
    academicyear = preferences.getString('academic_year');
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

  Map<String, dynamic>? loginCredential;
  String? img;
  var duplicateTeacherData = [];
  var teacherData = [];
  var newTeacherData;
  var classB = [];
  var roles;
  var firebase_tockenss;

  checkCache() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("hoslisting");
    print('cache--------------$isCacheExist');
    if (!isCacheExist) {
      getUserdata();
    } else {
      var CacheData = await APICacheManager().getCacheData("hoslisting");
      var decodedresp = json.decode(CacheData.syncData);
      hosdata = decodedresp['data']['details'];
      hoslistdata = decodedresp['data']['details']["response"]["list"];
      hoslist = decodedresp['data']['details']["response"]["list"];
      // hosname = decodedresp['data']['details']["response"]["list"][0]["hos_name"];
      lessonData = decodedresp['data']['details']["lesson_observations"];
      print('login data type${loginData['response'].runtimeType}');

      print('logggg--------$loginData');
    }
  }

  // Future getUserLoginCredentials() async {
  //   // var result = await Connectivity().checkConnectivity();
  //   // if (result == ConnectivityResult.none) {
  //   //   _checkInternet(context);
  //   // } else {
  //   var headers = {
  //     'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
  //     'Content-Type': 'application/json'
  //   };
  //   var request = http.Request('POST', Uri.parse(ApiConstants.WORKLOAD_API));
  //   request.body = json.encode({"user_id": hosId});
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   print(response.statusCode);
  //   print('----rrreeeqqq${request.body}');
  //   if (response.statusCode == 200) {
  //     var responseData = await response.stream.bytesToString();
  //     setState(() {
  //       isSpinner = false;
  //     });
  //     loginCredential = json.decode(responseData);
  //     SharedPreferences preference = await SharedPreferences.getInstance();
  //     preference.setString('loginCredential', json.encode(loginCredential));
  //     log("api resss-----$loginCredential");
  //     print('-------------------role ids-----------------');
  //     print('array--${loginCredential!["data"]["data"][0]["all_roles_array"]}');
  //     loginCredential!["data"]["data"].forEach((teacher){
  //       employeeUnderHOSs.add(teacher["employee_no"]);
  //     });
  //     // for ( var i=0; i<=loginCredential!["data"]["data"]; i++){
  //        log('empnum--- $employeeUnderHOSs');
  //     // }
  //     print('---------------end of----role ids-----------------');
  //     print(loginCredential!["data"]["data"][0]["faculty_data"]
  //         ["teacherComponent"]["is_class_teacher"]);
  //
  //     img = loginCredential!["data"]["data"][0]["image"];
  //
  //     print(">>>>>>>$img<<<<<<<");
  //     Map<String, dynamic> faculty_data =
  //         loginCredential!["data"]["data"][0]["faculty_data"];
  //     if (faculty_data.containsKey("teacherComponent") ||
  //         faculty_data.containsKey("supervisorComponent") ||
  //         faculty_data.containsKey("hosComponent") ||
  //         faculty_data.containsKey("hodComponent")) {
  //       if (faculty_data.containsKey("teacherComponent")) {
  //         if (loginCredential!["data"]["data"][0]["faculty_data"]
  //                     ["teacherComponent"]["is_class_teacher"] ==
  //                 true ||
  //             loginCredential!["data"]["data"][0]["faculty_data"]
  //                     ["teacherComponent"]["is_class_teacher"] ==
  //                 false) {
  //           print("-----------------------------------teacher");
  //
  //           for (var index = 0;
  //               index <
  //                   loginCredential!["data"]["data"][0]["faculty_data"]
  //                           ["teacherComponent"]["own_list"]
  //                       .length;
  //               index++) {
  //             var classBatch = loginCredential!["data"]["data"][0]
  //                     ["faculty_data"]["teacherComponent"]["own_list"][index]
  //                 ["academic"];
  //
  //             var sessionId = loginCredential!["data"]["data"][0]
  //                     ["faculty_data"]["teacherComponent"]["own_list"][index]
  //                 ["session"]["_id"];
  //
  //             var curriculumId = loginCredential!["data"]["data"][0]
  //                     ["faculty_data"]["teacherComponent"]["own_list"][index]
  //                 ["curriculum"]["_id"];
  //
  //             var batchID = loginCredential!["data"]["data"][0]["faculty_data"]
  //                 ["teacherComponent"]["own_list"][index]["batch"]["_id"];
  //
  //             var classID = loginCredential!["data"]["data"][0]["faculty_data"]
  //                 ["teacherComponent"]["own_list"][index]["class"]["_id"];
  //
  //             duplicateTeacherData.add({
  //               "class": classBatch.split("/")[2].toString() +
  //                   " " +
  //                   classBatch.split("/")[3].toString(),
  //               "session_id": sessionId,
  //               "curriculumId": curriculumId,
  //               "batch_id": batchID,
  //               "class_id": classID,
  //               "is_Class_teacher": loginCredential!["data"]["data"][0]
  //                       ["faculty_data"]["teacherComponent"]["own_list"][index]
  //                   ["is_class_teacher"]
  //             });
  //             print(
  //                 '${loginCredential!["data"]["data"][0]["faculty_data"]["teacherComponent"]["own_list"][0]["subjects"]}');
  //             for (var ind = 0;
  //                 ind <
  //                     loginCredential!["data"]["data"][0]["faculty_data"]
  //                                 ["teacherComponent"]["own_list"][index]
  //                             ["subjects"]
  //                         .length;
  //                 ind++) {
  //               var subjects = loginCredential!["data"]["data"][0]
  //                       ["faculty_data"]["teacherComponent"]["own_list"][index]
  //                   ["subjects"][ind]["name"];
  //
  //               teacherData.add({
  //                 "class": classBatch.split("/")[2].toString() +
  //                     " " +
  //                     classBatch.split("/")[3].toString(),
  //                 "subjects": subjects,
  //                 "session_id": sessionId,
  //                 "curriculumId": curriculumId,
  //                 "batch_id": batchID,
  //                 "class_id": classID,
  //                 "is_Class_teacher": loginCredential!["data"]["data"][0]
  //                         ["faculty_data"]["teacherComponent"]["own_list"]
  //                     [index]["is_class_teacher"]
  //               });
  //             }
  //           }
  //
  //           var removeDuplicates = duplicateTeacherData.toSet().toList();
  //           var newClassTeacherCLass = removeDuplicates
  //               .where((element) => element.containsValue(true))
  //               .toSet()
  //               .toList();
  //
  //           newTeacherData = newClassTeacherCLass;
  //           log("tdhdhdhdhdhdbhdhd ${newTeacherData.length}");
  //
  //           log(">>>>>>>>hoslistingteacherData>>>>>>>>$teacherData");
  //           // print(" the length of class_group $employeeUnderHOS");
  //
  //           print(classB);
  //
  //           print(loginCredential);
  //
  //           setState(() {
  //             isSpinner = false;
  //           });
  //         }
  //       }
  //       if (faculty_data.containsKey("supervisorComponent")) {
  //         if (loginCredential!["data"]["data"][0]["faculty_data"]
  //                 ["supervisorComponent"]["is_hos"] ==
  //             true) {
  //           for (var ind = 0;
  //               ind <
  //                   loginCredential!["data"]["data"][0]["faculty_data"]
  //                           ["supervisorComponent"]["own_list_groups"]
  //                       .length;
  //               ind++) {
  //             for (var index = 0;
  //                 index <
  //                     loginCredential!["data"]["data"][0]["faculty_data"]
  //                                 ["supervisorComponent"]["own_list_groups"]
  //                             [ind]["class_group"]
  //                         .length;
  //                 index++) {
  //               if (loginCredential!["data"]["data"][0]["faculty_data"]
  //                           ["supervisorComponent"]["own_list_groups"][ind]
  //                       ["class_group"][index]
  //                   .containsKey("class_teacher")) {
  //                 var employeeUnderHod = loginCredential!["data"]["data"][0]
  //                             ["faculty_data"]["supervisorComponent"]
  //                         ["own_list_groups"][ind]["class_group"][index]
  //                     ["class_teacher"]["employee_no"];
  //                 employeeUnderHOS.add(employeeUnderHod);
  //               }
  //             }
  //           }
  //           for (var index = 0;
  //               index <
  //                   loginCredential!["data"]["data"][0]["faculty_data"]
  //                           ["supervisorComponent"]["own_list_groups"]
  //                       .length;
  //               index++) {
  //             for (var ind = 0;
  //                 ind <
  //                     loginCredential!["data"]["data"][0]["faculty_data"]
  //                                 ["supervisorComponent"]["own_list_groups"]
  //                             [index]["class_group"]
  //                         .length;
  //                 ind++) {
  //               var classBatch = loginCredential!["data"]["data"][0]
  //                       ["faculty_data"]["supervisorComponent"]
  //                   ["own_list_groups"][index]["class_group"][ind]["academic"];
  //               classB.add(classBatch.split("/")[2].toString() +
  //                   " " +
  //                   classBatch.split("/")[3].toString());
  //             }
  //           }
  //
  //           print('employeeUnderHOS__---__$employeeUnderHOS');
  //
  //           print("???????????????????????????????????????????????????$classB");
  //
  //           print(loginCredential);
  //
  //           setState(() {
  //             isSpinner = false;
  //           });
  //         }
  //       }
  //       if (faculty_data.containsKey("hosComponent")) {
  //         print("hos Component");
  //         if (loginCredential!["data"]["data"][0]["faculty_data"]
  //                 ["hosComponent"]["is_hos"] ==
  //             true) {
  //           for (var ind = 0;
  //               ind <
  //                   loginCredential!["data"]["data"][0]["faculty_data"]
  //                           ["hosComponent"]["own_list_groups"]
  //                       .length;
  //               ind++) {
  //             for (var index = 0;
  //                 index <
  //                     loginCredential!["data"]["data"][0]["faculty_data"]
  //                                 ["hosComponent"]["own_list_groups"][ind]
  //                             ["class_group"]
  //                         .length;
  //                 index++) {
  //               if (loginCredential!["data"]["data"][0]["faculty_data"]
  //                           ["hosComponent"]["own_list_groups"][ind]
  //                       ["class_group"][index]
  //                   .containsKey("class_teacher")) {
  //                 var employeeUnderHod = loginCredential!["data"]["data"][0]
  //                             ["faculty_data"]["hosComponent"]
  //                         ["own_list_groups"][ind]["class_group"][index]
  //                     ["class_teacher"]["employee_no"];
  //
  //                 print('----empid--$employeeUnderHod');
  //                 employeeUnderHOS.add(employeeUnderHod);
  //               }
  //             }
  //           }
  //           for (var index = 0;
  //               index <
  //                   loginCredential!["data"]["data"][0]["faculty_data"]
  //                           ["hosComponent"]["own_list_groups"]
  //                       .length;
  //               index++) {
  //             for (var ind = 0;
  //                 ind <
  //                     loginCredential!["data"]["data"][0]["faculty_data"]
  //                                 ["hosComponent"]["own_list_groups"][index]
  //                             ["class_group"]
  //                         .length;
  //                 ind++) {
  //               var classBatch = loginCredential!["data"]["data"][0]
  //                       ["faculty_data"]["hosComponent"]["own_list_groups"]
  //                   [index]["class_group"][ind]["academic"];
  //               classB.add(classBatch.split("/")[2].toString() +
  //                   " " +
  //                   classBatch.split("/")[3].toString());
  //             }
  //           }
  //
  //           log("print HOS EMP$employeeUnderHOS");
  //
  //           print(classB);
  //
  //           print(loginCredential);
  //
  //           setState(() {
  //             isSpinner = false;
  //           });
  //         }
  //       }
  //
  //       if (faculty_data.containsKey("hodComponent")) {
  //         if (loginCredential!["data"]["data"][0]["faculty_data"]
  //                 ["hodComponent"]["is_hod"] ==
  //             true) {
  //           for (var ind = 0;
  //               ind <
  //                   loginCredential!["data"]["data"][0]["faculty_data"]
  //                           ["hodComponent"]["own_list_groups"]
  //                       .length;
  //               ind++) {
  //             for (var index = 0;
  //                 index <
  //                     loginCredential!["data"]["data"][0]["faculty_data"]
  //                                 ["hodComponent"]["own_list_groups"][ind]
  //                             ["class_group"]
  //                         .length;
  //                 index++) {
  //               if (loginCredential!["data"]["data"][0]["faculty_data"]
  //                           ["hodComponent"]["own_list_groups"][ind]
  //                       ["class_group"][index]
  //                   .containsKey("class_teacher")) {
  //                 var employeeUnderHod = loginCredential!["data"]["data"][0]
  //                             ["faculty_data"]["hodComponent"]
  //                         ["own_list_groups"][ind]["class_group"][index]
  //                     ["class_teacher"]["employee_no"];
  //                 employeeUnderHOS.add(employeeUnderHod);
  //               }
  //             }
  //           }
  //           for (var index = 0;
  //               index <
  //                   loginCredential!["data"]["data"][0]["faculty_data"]
  //                           ["hodComponent"]["own_list_groups"]
  //                       .length;
  //               index++) {
  //             for (var ind = 0;
  //                 ind <
  //                     loginCredential!["data"]["data"][0]["faculty_data"]
  //                                 ["hodComponent"]["own_list_groups"][index]
  //                             ["class_group"]
  //                         .length;
  //                 ind++) {
  //               var classBatch = loginCredential!["data"]["data"][0]
  //                       ["faculty_data"]["hodComponent"]["own_list_groups"]
  //                   [index]["class_group"][ind]["academic"];
  //               classB.add(classBatch.split("/")[2].toString() +
  //                   " " +
  //                   classBatch.split("/")[3].toString());
  //             }
  //           }
  //
  //           print('.....employeeUnderHOS....${employeeUnderHOS}');
  //
  //           print('.....classB${classB}');
  //
  //           print('.....${loginCredential}');
  //
  //           setState(() {
  //             isSpinner = false;
  //           });
  //         }
  //       }
  //     }
  //     //addToLocalDb();
  //   }
  // }

  Future getUserdata() async {
    await APICacheManager().deleteCache("hoslisting");
    setState(() {
      isSpinner = true;
    });

    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      print('no internet');
      // _checkInternet(context);
      setState(() {
        isSpinner = false;
      });
    } else {
      print('user id--------------->${widget.userID}');

      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.Leadership));
      request.body = json
          .encode({"user_id": widget.userID, "academic_year": academicyear,"hos":false});
      request.headers.addAll(headers);

      print("------Hoslistingreq.body${request.body}");

      http.StreamedResponse response = await request.send();

      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          isSpinner = false;
        });
        var resp = await response.stream.bytesToString();
        var decodedresp = json.decode(resp);
        // var isCacheExist = await APICacheManager().isAPICacheKeyExist(
        //     "loginApiResp");
        // print('cache--------------$isCacheExist');

        APICacheDBModel cacheDBModel = APICacheDBModel(
            key: "hoslisting", syncData: json.encode(decodedresp));
        await APICacheManager().addCacheData(cacheDBModel);

        hosdata = decodedresp['data']['details'];
        hoslistdata = decodedresp['data']['details']["response"]["list"];
        hoslist = decodedresp['data']['details']["response"]["list"];
        // hosname = decodedresp['data']['details']["response"]["list"][0]["hos_name"];
        lessonData = decodedresp['data']['details']["lesson_observations"];
        // learningData = decodedresp['data']['details']["learning_walk"];
        // lessonData = decodedresp['data']['details']["lesson_observations"];
        print(hosdata!['response']);
        print('login hosdata----$hosdata');
        print('login hoslist----$hoslist');
        // print('login hosname----$hosname');

        // print(observationData);
        // print(observationData!['list']);
        // print(observationData!['list'].runtimeType);
      } else {
        setState(() {
          isSpinner = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Something went wrong')));
      }
      //print(await response.stream.bytesToString());

    }
  }
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
  getleaderdetails() async {
    firebase_tockenss = await fbToken();
    print('tockenss hoslisting------${firebase_tockenss}');
    getDeviceDetail();
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      print('no internet');
      checkCache();
    } else {
      getUserdata();
    }
  }

  void initState() {
    print('widget.image......${widget.images}');
    // getUserdata();
    // checkCache();
    getleaderdetails();
    // getUserLoginCredentials();
    getNotification();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    super.initState();
  }

  var count;

  @override
  void didUpdateWidget(covariant hoslisting oldWidget) {
    // TODO: implement didUpdateWidget
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.BACKGROUND,
      body: LoadingOverlay(
        opacity: 0,
        isLoading: isSpinner,
        progressIndicator: CircularProgressIndicator(),
        child: Form(
          key: _formKey,
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
                      // GestureDetector(
                      //   onTap: () => ZoomDrawer.of(context)!.toggle(),
                      //   child: Container(
                      //       margin: const EdgeInsets.all(6),
                      //       child: Image.asset("assets/images/newmenu.png")),
                      // ),
                      // SizedBox(
                      //   width: 30,
                      // ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(25, 30, 55, 0),
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
                                  loginname.toString(),
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
                              child:
                                  SvgPicture.asset("assets/images/bell.svg")),
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
                    margin:
                        EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                    height: 660.h,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200.h,
                        ),
                        Center(
                            child: Text(
                          'Select HOS',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w800),
                        )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 20.h),
                          child: DropdownButtonFormField(
                            validator: (dynamic value) =>
                                value == null ? 'Field Required' : null,
                            value: _hosnameSelected,
                            isExpanded: true,
                            onChanged: (dynamic newVal) {
                              setState(() async {
                                _hosnameSelected = newVal;
                                //
                                // _hosListSelectedIndex =
                                //     int.parse(newVal.toString());
                                hosname =
                                    _hosnameSelected.toString().split('-')[0];
                                hosId =
                                    _hosnameSelected.toString().split('-')[1];
                               // await getUserLoginCredentials();
                                // hosId = hosdata![
                                // _hosListSelectedIndex!]['user_id'];
                                // print(teacherName);
                                print(
                                    'hosId---------------------------------->$hosId');
                                print(
                                    'newVal---------------------------------->$newVal');
                                print(
                                    'hosname---------------------------------->$hosname');
                              });
                            },
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.3)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 25.0, horizontal: 20.0),
                                hintText: " Select a HOS ",
                                counterText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(230, 236, 254, 8),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(22)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(230, 236, 254, 8),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                ),
                                fillColor: Color.fromRGBO(230, 236, 254, 8),
                                filled: true),
                            items: hoslistdata
                                .map<DropdownMenuItem<dynamic>>((item) {
                              return DropdownMenuItem<dynamic>(
                                // value: hoslistdata
                                //     .indexOf(item)
                                //     .toString().toCapitalCase(),
                                value:
                                    '${item['hos_name'].toString().toCapitalCase()}-${item['user_id'].toString()}',
                                child: Text(
                                  item['hos_name'].toString().toCapitalCase(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 75, right: 75, top: 20),
                          child: GestureDetector(
                            onTap: () async{
                             // await getUserLoginCredentials();
                              if (_formKey.currentState!.validate()) {
                                print('validation success');
                                // if (_formKey.currentState!.validate()) {
                                //   print('validation success');
                                if (lessonData != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DrawerPageForHos(
                                                admin:true,
                                                loginname: loginname,
                                                userId: hosId,
                                                HOSID: hosId,
                                                HOSNAME: hosname,
                                                loginedUserEmployeeNo:
                                                    widget.loginEmployeeID,
                                                designation: widget.designation,
                                                schoolId: widget.schoolID,
                                                loginedUserName: widget.name,
                                                images: widget.images,
                                                academic_year:
                                                    widget.academic_year,
                                                roleUnderHos: employeeUnderHOS,
                                                Empcodee: employeeUnderHOS,
                                                isAClassTeacher: newTeacherData,
                                                role_id:
                                                    widget.role_id ?? roles,
                                              )));
                                } else {
                                  // setState(() {
                                  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cannot fetch teacher data')));
                                  // });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Cannot fetch teacher data')));
                                }
                                // } else {
                                //   print('validation failed');
                                // }
                              } else {
                                print('validation failed');
                              }
                            },
                            child: Container(
                                height: 60.h,
                                width: 220.w,
                                decoration: BoxDecoration(
                                  color: Color(0xff42C614),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.sp),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
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
              // getUserLoginCredentials();
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
}

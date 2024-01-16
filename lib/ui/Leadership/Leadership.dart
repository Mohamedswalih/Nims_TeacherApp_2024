
import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:bmteacher/exports.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/learningdatabase/learningdbhelper.dart';
import '../../Database/learningdatabase/learningmodel.dart';
import '../../Database/lessondatabase/lessondbhelper.dart';
import '../../Database/lessondatabase/lessonmodel.dart';
import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../LearningWalk/LearningWalk.dart';
import '../LessonObservation/lessonobservation.dart';

class LeadershipListView extends StatefulWidget {
  var roleUnderLoginTeacher;
  String? teachername;
  var HOSNAME;
  String? teacherName;
  String? image;
  String? usrId;
  var role_id;
  var loginname;
  var Empcodee;
  bool? admin;
  LeadershipListView(
      {Key? key,
      this.roleUnderLoginTeacher,
      this.teachername,
      this.admin,
      this.loginname,
      this.role_id,
      this.HOSNAME,
      this.Empcodee,
      this.image,
      this.teacherName,
      this.usrId})
      : super(key: key);

  @override
  State<LeadershipListView> createState() => _LeadershipListViewState();
}

var count;

class _LeadershipListViewState extends State<LeadershipListView> {
  bool isSpinner = false;
  Map<String, dynamic>? loginData;
  Map<String, dynamic>? observationData;
  Map<String, dynamic>? learningData;
  Map<String, dynamic>? lessonData;
  //late List<Note> notes;
  //late List<Lesson> not;
  List<Note>? notes;
  List<Lesson>? not;
  Map<String, dynamic>? notificationResult;
  int Count = 0;
  Timer? timer;
  var pageInit = true;
  final drawerController = ZoomDrawerController();
  var getprefernce;
  var getdata ;
  var academicyear;


  //For Learning Walk Sql
  Future refreshNotes() async {
    this.notes = await NotesDatabase.instance.readAllNotes();
    print('learning walk db length------->${notes!.length}');
    //print(notes!.first.teachername);
  }

  //For Lesson Observation Sql
  Future refreshNote() async {
    this.not = await LessonDatabase.instance.readAllNotes();
    print('lesson obs db length-------${not!.length}');
   // print(not!.first.teachername);
  }

  //Submission for learning_walk
  SubmitRequest() async {
    setState(() {
      isSpinner = true;
    });
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _checkInternet(context);
      setState(() {
        isSpinner = false;
      });
    } else {
      setState(() {
        isSpinner = true;
      });
      for (var learninglist = 0; learninglist < notes!.length; learninglist++) {
        isSpinner = true;
        var url = Uri.parse(ApiConstants.LearningWalkSUbmit);
        var header = {
          "x-auth-token": "tq355lY3MJyd8Uj2ySzm",
          "Content-Type": "application/json",
        };
        //var areaof  = json.decode(notes[learninglist].area);
        //var strenghtof = json.decode(notes[learninglist].strength);
        final bdy = jsonEncode({
          "academic_year": notes![learninglist].academic_year,
          "school_id": notes![learninglist].school_id,
          "added_by": notes![learninglist].added_by,
          "added_date": notes![learninglist].added_date,
          "session_id": notes![learninglist].session_id,
          "curriculum_id": notes![learninglist].curriculum_id,
          "class_id": notes![learninglist].class_id,
          "batch_id": notes![learninglist].batch_id,
          "teacher_id": notes![learninglist].teacher_id,
          "teacher_name": notes![learninglist].teacher_name,
          "lw_focus": notes![learninglist].lw_focus,
          "qs_to_puple": notes![learninglist].qs_to_puple,
          "qs_to_teacher": notes![learninglist].qs_to_teacher,
          "what_went_well": notes![learninglist].what_went_well,
          "even_better_if": notes![learninglist].even_better_if,
          "sender_id": notes![learninglist].sender_id,
          "observation_date": notes![learninglist].observation_date,
          "observer_roles": notes![learninglist].observer_roles,
          "notes": notes![learninglist].notes,
          "app": true,
        });
        var jsonresponse = await http.post(url, headers: header, body: bdy);
        print('-----------------------------learningwalkbodyyyy$bdy');
        if (jsonresponse.statusCode == 200) {
          isSpinner = false;
        } else {
          isSpinner = false;
        }
        print("---------------statuscodelearningwalk${jsonresponse.statusCode}");
      }
      isSpinner = true;
      setState(() {
        isSpinner = false;
        LearningsubmitedSuccessfully(context);
      });
    }
  }

  //Submission for Lesson
  SubmitRequestLesson() async {
    setState(() {
      isSpinner = true;
    });
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _checkInternet(context);
      setState(() {
        isSpinner = false;
      });
    } else {
      isSpinner = true;
      for (var lessonlist = 0; lessonlist < not!.length; lessonlist++) {
        isSpinner = true;
        var url = Uri.parse(ApiConstants.LessonObservationSubmit);
        // var lessonstrengt = json.decode(not[lessonlist].areas_for_improvement);
        // var lessonarea = json.decode(not[lessonlist].strengths);
        final bdy = jsonEncode({
          "school_id": not![lessonlist].schoolid,
          "teacher_id": not![lessonlist].teacherid,
          "teacher_name": not![lessonlist].teachername,
          "observer_id": not![lessonlist].observerid,
          "observer_name": not![lessonlist].observername,
          "subject_id": not![lessonlist].subjectid,
          "class_id": not![lessonlist].classid,
          "class_batch_name": not![lessonlist].classname,
          "batch_id": not![lessonlist].batchid,
          "topic": not![lessonlist].topic,
          "academic_year": not![lessonlist].academicyear,
          "areas_for_improvement": not![lessonlist].areas_for_improvement,
          "subject_name": not![lessonlist].subjectname,
          "remedial_measures": not![lessonlist].remedial_measures,
          "strengths": not![lessonlist].strengths,
          //"roll_ids": jsonDecode(not[lessonlist].role_ids.toString()),
          "roll_ids": not![lessonlist].role_ids,
          "upper_hierarchy": not![lessonlist].upper_hierarchy,
          "session_id": not![lessonlist].session_id,
          "curriculum_id": not![lessonlist].curriculum_id,
          "isJoin": not![lessonlist].isJoin,

          "remarks_data": [
            {"Indicators": jsonDecode(not![lessonlist].tempnam.toString())},
          ]
        });
        var header = {
          "x-auth-token": "tq355lY3MJyd8Uj2ySzm",
          "Content-Type": "application/json",
        };
        print(bdy);
        var jsonresponse = await http.post(
          url,
          headers: header,
          body: bdy,
        );
        print(jsonresponse.body);
        if (jsonresponse.statusCode == 200) {
          isSpinner = false;
          // var response = await SubmitLesson.fromJson(jsonDecode(
          //   jsonresponse.body,
          // ));
        } else {
          isSpinner = false;
        }
      }
      _submitedSuccessfully(context);
      setState(() {
        isSpinner = false;
      });
    }
  }

  Future getUserdata() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    await APICacheManager().deleteCache("loginApiResp");
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
      print('user id--------------->${widget.usrId}');

      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.Leadership));
      request.body =
          json.encode({"user_id": widget.usrId, "academic_year": academicyear,"hos":true});
      request.headers.addAll(headers);

      print('---------Leadership--body--${request.body}');

      http.StreamedResponse response = await request.send();

      print('---------Leadership--statusCode--${response.statusCode}');
      if (response.statusCode == 200) {

        print('load'
            'inggggg');

        var resp = await response.stream.bytesToString();
        var decodedresp = json.decode(resp);
        preference.setString('leadershipAPI', json.encode(decodedresp));
        // var isCacheExist = await APICacheManager().isAPICacheKeyExist(
        //     "loginApiResp");
        // print('cache--------------$isCacheExist');

        // APICacheDBModel cacheDBModel = APICacheDBModel(
        //     key: "loginApiResp", syncData: json.encode(decodedresp));
        // await APICacheManager().addCacheData(cacheDBModel).then((value) {
        //   print('is exxist ---------->$value');
        //  // cacheSecondary = value;
        //
        // });


        // getprefernce = preference.getString('leadershipAPI');
        // getdata = jsonDecode(getprefernce);
        //log("api preferencessss-----$getprefernce");
        // var isCacheExist =
        // await APICacheManager().isAPICacheKeyExist("loginApiResp");
        // print('cache exist111 ---------$isCacheExist');
        loginData = decodedresp['data']['details'];
        observationData = decodedresp['data']['details']["lesson_observations"];
        learningData = decodedresp['data']['details']["learning_walk"];
        lessonData = decodedresp['data']['details']["lesson_observations"];
        // print('run login-------->${getprefernce.runtimeType}');
        // print('run data-------->${getdata.runtimeType}');
        // loginData = getdata['data']['details'];
        // observationData = getdata['data']['details']["lesson_observations"];
        // learningData = getdata['data']['details']["learning_walk"];
        // lessonData = getdata['data']['details']["lesson_observations"];


        print('login data----$loginData');
        print('login lessonData----$lessonData');
        // print(observationData);
        print(observationData!['list']);
        print(observationData!['list'].runtimeType);
        // print('cache exist twi---------$isCacheExist');
        setState(() {
          isSpinner = false;
        });
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

 Future<void> getleaderdetails() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      print('no internet');
      checkCache();
    } else {
      getUserdata();
    }
  }

  checkCache() async {
    // var isCacheExist =
    //     await APICacheManager().isAPICacheKeyExist("loginApiResp");
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      SharedPreferences preferences = await SharedPreferences.getInstance();

     var getrefernce = preferences.getString('leadershipAPI');
     var gedata = jsonDecode(getrefernce!);
      loginData = gedata['data']['details'];
      observationData = gedata['data']['details']["lesson_observations"];
      learningData = gedata['data']['details']["learning_walk"];
      lessonData = gedata['data']['details']["lesson_observations"];
      // print('login data type${loginData!['response'].runtimeType}');
      print('login data loginData$loginData');
      print('observationDatatype$observationData');

    }
    // print('cache------leadership--------$isCacheExist');
    // if (!isCacheExist) {
    //   getUserdata();
    // } else {
      // var CacheData = await APICacheManager().getCacheData("loginApiResp");
      // var decodedresp = json.decode(CacheData.syncData);
      // loginData = decodedresp['data']['details'];
      // observationData = decodedresp['data']['details']["lesson_observations"];
      // learningData = decodedresp['data']['details']["learning_walk"];
      // lessonData = decodedresp['data']['details']["lesson_observations"];
      // print('login data type${loginData!['response'].runtimeType}');

      print('logggg--------$loginData');
      print('learningDatacache--------$learningData');
      print('lessonDatacache--------$lessonData');
    // }
  }

  getPreferenceData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      count = preferences.get("count");
      print('notification count---->${preferences.get("count")}');
    });
  }

  Future<void> getNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    widget.loginname = preferences.getString('name');
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
  void _checkNewVersion() async {
    final newVersion = NewVersionPlus(iOSId: "com.educore.bmteacher",androidId: "com.educore.bmteacher");
    final status = await newVersion.getVersionStatus();
    if (status?.localVersion != status?.storeVersion) {
      newVersion.showUpdateDialog(
          context: context,
          versionStatus: status!,
          dialogTitle: 'Update NIMS Teacher?',
          dialogText: 'Latest Version: ${status.storeVersion} \n'
              ' \nCurrent version: ${status.localVersion} \n'
              ' \nNIMS Teacher recommends that you update to the latest version.To get the best from your Device, Please keep your App up to Date.',
          updateButtonText: 'UPDATE NOW',dismissButtonText: 'Maybe Later',
          allowDismissal: true,dismissAction: () {
        Navigator.pop(context);
      },launchModeVersion: LaunchModeVersion.normal);
    }
  }

  @override
  void initState() {
    print('empid in leadership${widget.roleUnderLoginTeacher}');
    print('usrId in leadership${widget.usrId}');
    // print('-------------------LearningData-----------${learningData}');
    // print('-------------------LessonData-----------${lessonData}');
    // print('-------------------ObservationData-----------${observationData}');
    // TODO: implement initState
    super.initState();
   //refreshNote();
    //refreshNotes();
    _checkNewVersion();
    getleaderdetails();
    //checkCache();
    //getUserdata();
    getNotification();
    //getNotification().then((_) => getleaderdetails());
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
  }

  @override
  void didUpdateWidget(covariant LeadershipListView oldWidget) {
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
            child: ListView(physics: NeverScrollableScrollPhysics(), children: [
              Stack(children: [
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
                      //onTap: () => drawerController.toggle,
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
                  margin: EdgeInsets.only(left: 5.w, top: 100.h, right: 5.w),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Leadership',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                              widget.HOSNAME != null ?
                              Text(
                                'Hos: ${widget.HOSNAME}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500,color: Colors.blueAccent),
                              ):Container()
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 35.w, right: 35.w, top: 20.h),
                          child: GestureDetector(
                            onTap: () {
                              if (lessonData != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => lessonObservation(
                                          roleUnderLoginTeacher: widget.roleUnderLoginTeacher,
                                          loginname:widget.loginname,
                                              teachername: widget.teachername,
                                              image: widget.image,
                                              teacherData:
                                                  loginData!['response'],
                                              observationData:
                                                  lessonData!['list'],
                                              lessonData: lessonData,
                                              role_id: widget.role_id,
                                            )));
                              } else {
                                // setState(() {
                                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cannot fetch teacher data')));
                                // });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Cannot fetch teacher data')));
                              }
                            },
                            child: Container(
                              height: 140.h,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromRGBO(101, 63, 244, 8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.transparent),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/notebook 1.png')),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.w),
                                    child: Container(
                                        // height:0.h,
                                        width: 180.w,
                                        child: Text(
                                          "Lesson Observation",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromRGBO(
                                                  240, 236, 254, 8)),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 35.w, right: 35.w, top: 35.h),
                          child: GestureDetector(
                            onTap: () {
                              if (learningData != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => learningWalk(
                                          roleUnderLoginTeacher: widget.roleUnderLoginTeacher,
                                          loginname:widget.loginname,
                                              teachername: widget.teachername,
                                              image: widget.image,
                                              // teacherData:
                                              //     loginData!['response'],
                                              observationDataa:
                                                  learningData!['list'],
                                              learningData: learningData,
                                              role_id: widget.role_id,
                                              userid: widget.usrId,
                                               admin:widget.admin,
                                            )));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Cannot fetch teacher data')));
                              }
                            },
                            child: Container(
                              height: 140.h,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xff14C6C6),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.transparent),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 25.w),
                                      child: Image(
                                          image: AssetImage(
                                              'assets/images/journalist 1.png')),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.w),
                                    child: Container(
                                        // height: 50.h,
                                        width: 180.w,
                                        child: Text(
                                          "Learning Walk",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromRGBO(
                                                  240, 236, 254, 8)),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: ()
                              {
                                refreshNote().then((_) {
                                  print('-----not$not');
                                  if(not!.length == 0){
                                    _submitedfailed(context);
                                  }else{
                                    //refreshNotes().then((_) {
                                    SubmitRequestLesson();
                                    // });
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color.fromRGBO(0, 136, 170, 8),
                                ),
                                height: 28,
                                width: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/Synclesson.png",
                                      height: 20,
                                      // width: 20,
                                    ),
                                    Text(
                                      "Sync Lesson",
                                      style: TextStyle(color: Colors.white,fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                refreshNotes().then((_) {
                                  // print('-----notes$notes');
                                  if(notes!.length == 0){
                                    print('-----notes1$notes');
                                    _submitedfailed(context);
                                  }else{
                                    print('-----notes$notes');
                                      //refreshNotes().then((_) {
                                        SubmitRequest();
                                     // });
                                  }
                               });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color.fromRGBO(0, 136, 170, 8),
                                ),
                                height: 28,
                                width: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/Synclearning.png",
                                      height: 20,
                                      // width: 20,
                                    ),
                                    Center(
                                        child: Text(
                                      "Sync Learning",
                                      style: TextStyle(color: Colors.white,fontSize: 12),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
              ])
            ])));
  }

  //Internet Checking
  _checkInternet(context) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "No Internet",
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

  //No Data to Upload Pop Up
  _submitedfailed(context) {
    return Alert(
      context: context,
      type: AlertType.info,
      title: "No Data to \nUpload",
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
        )
      ],
    ).show();
  }

  //Lesson Observation Submition Success Pop Up
  _submitedSuccessfully(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Success",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text("Lesson Observation \nSubmitted Successfully"),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DialogButton(
                      width: 120,
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        await LessonDatabase.instance.delete();
                        // getUserdata();
                        checkCache();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  //Learning walk Submition Success Pop Up
  LearningsubmitedSuccessfully(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Success",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text("Learning Walk \nSubmitted Successfully"),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DialogButton(
                      width: 120,
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        await NotesDatabase.instance.delete();
                        // getUserdata();
                        checkCache();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

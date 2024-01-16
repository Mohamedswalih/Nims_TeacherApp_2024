
import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:bmteacher/exports.dart';
import 'package:change_case/change_case.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import 'learningwalk2.dart';

class learningWalk extends StatefulWidget {
  var roleUnderLoginTeacher;
  Map<String, dynamic>? data;
  String? subjectName;
  String? teacherName;
  String? image;
  var OB_Id;
  var role_id;
  var loginname;
  final String? Image;
  String? teachername;
  final String? HOS_ID;
  String? batchname;
  String? class_batchName;
  String? teacherid;
  String? classid;
  String? batchid;
  final String? schoolid;
  final String? userid;
  final String? main_user;
  final String? user_roleid;
  String? Subjectid;
  String? session_id;
  String? curiculam_id;
  // List<dynamic>? teacherData;
  List<dynamic>? observationDataa;
  Map<String, dynamic>? learningData;
  bool? admin;
  learningWalk(
      {Key? key,
      this.role_id,
      this.loginname,
      this.admin,
      this.schoolid,
      this.observationDataa,
      this.user_roleid,
      this.main_user,
      this.learningData,
      this.HOS_ID,
      this.userid,
      this.Image,
      this.OB_Id,
      this.teacherName,
      this.image,
      this.teachername,
      this.class_batchName,
      this.roleUnderLoginTeacher,
      // this.teacherData,
      this.Subjectid})
      : super(key: key);

  @override
  State<learningWalk> createState() => _learningWalkState();
}

class _learningWalkState extends State<learningWalk> {
  String? selectedteacher_Name;
  String? selectedteacher_Id;
  String? division_name;
  String? division_id;
  String? class_id;
  String? class_name;
  String? batchname;
  // String? batchid;
  String? class_batchName;
  String? session_id;
  String? curiculam_id;
  late List<String> className = [];
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? notificationResult;
  int Count = 0;
  Timer? timer;
  String? teacherId;
  var teacherImage;
  var academic_year;
  var school_id;
  bool isSpinner = false;

  getPreferenceData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      count = preferences.get("count");
      print('notification count---->${preferences.get("count")}');
    });
  }
  List<dynamic>? classData;

  getClassData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    academic_year = preferences.getString('academic_year');
    school_id = preferences.getString('school_id');
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

      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.LearningWalkClassList));
      request.body =
          json.encode({"user_id": widget.userid, "academic_year": academic_year,"school_id":school_id});
      request.headers.addAll(headers);

      print('---------LearnigWalkClassData--body--${request.body}');

      http.StreamedResponse response = await request.send();

      print('---------LearnigWalkClassData--statusCode--${response.statusCode}');
      if (response.statusCode == 200) {
        var resp = await response.stream.bytesToString();
        var decodedresp = json.decode(resp);
        classData = decodedresp['data']['details'];
        log('---------classData--${classData}');

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
  List<dynamic>? divisionData;
  getdivisionData({required List classSessionId, required List classCurriculumId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    academic_year = preferences.getString('academic_year');
    school_id = preferences.getString('school_id');
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

      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.LearningWalkdivisionList));
      request.body =
          json.encode({
            "school_id": school_id,
            "academic_year": academic_year,
            "user_id": widget.userid,
            "admin": widget.admin,
            "class_id": class_id,
            "session": classSessionId,
            "curriculum": classCurriculumId
          });
      request.headers.addAll(headers);

      print('---------LearnigWalkBatchData--body--${request.body}');

      http.StreamedResponse response = await request.send();

      print('---------LearnigWalkBatchData--statusCode--${response.statusCode}');
      if (response.statusCode == 200) {
        var resp = await response.stream.bytesToString();
        var decodedresp = json.decode(resp);
        divisionData = decodedresp['data']['details'];
        log('---------batchData--${divisionData}');

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

  List<dynamic>? teacherData;
  getTeacherData({required String divisionid, required String divisionSessionId, required String divisionCurriculumId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    academic_year = preferences.getString('academic_year');
    school_id = preferences.getString('school_id');
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

      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.LearningWalkTeacherList));
      request.body =
          json.encode({
              "school_id": school_id,
              "academic_year": academic_year,
              "user_id": widget.userid,
              "admin": widget.admin,
              "class_id": class_id,
              "batch_id": divisionid,
              "curriculum_id": divisionCurriculumId,
              "session_id": divisionSessionId,
          });
      request.headers.addAll(headers);

      print('---------LearnigWalkTeacherData--body--${request.body}');

      http.StreamedResponse response = await request.send();

      print('---------LearnigWalkTeacherData--statusCode--${response.statusCode}');
      if (response.statusCode == 200) {
        var resp = await response.stream.bytesToString();
        var decodedresp = json.decode(resp);
        teacherData = decodedresp['data']['details'];
        log('---------teacherData--${teacherData}');

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

  void initState() {
    print('---------------roll id lw----${widget.role_id}');
    print('---------------userid lw----${widget.userid}');
    print('---------------lwadmin---${widget.admin}');
    print(
        '---------------roleUnderLoginTeacher lw----${widget.roleUnderLoginTeacher}');
    // datas();
    getdata();
    getClassData();
    getNotification();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    super.initState();
  }

  var _textController = new TextEditingController();
  get builder => null;
  Object? dropdownValue;
  var count;
  Object? _teacherListSelected;
  Object? _teacherClassSelected;
  Object? _teacherBatchSelected;

  int? _teacherListSelectedIndex;
  int? _teacherClassSelectedIndex;
  getdata() {
    // print(widget.teacherData);
    // print(widget.teacherData![0]['teacher_name']);
    //teacherName = widget.teacherData![0]['teacher_name'];
  }

  @override
  void didUpdateWidget(covariant learningWalk oldWidget) {
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
        body: Form(
          key: _formKey,
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: Colors.white,
                        )),
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
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 30.h),
                          child: Text(
                            "Learning Walk",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 20.h),
                          child: DropdownButtonFormField(
                            validator: (dynamic value) =>
                                value == null ? 'Field Required' : null,
                            value: _teacherClassSelected,
                            isExpanded: true,
                            onChanged: (dynamic newVal) {
                              setState(() {
                              _teacherClassSelected = newVal;
                              class_id = classData![int.parse(newVal)]['_id'];
                              class_name = classData![int.parse(newVal)]['name'];
                              });
                              print('-------newVal$newVal');
                               getdivisionData( classSessionId: classData![int.parse(newVal)]['session_ids'], classCurriculumId: classData![int.parse(newVal)]['curriculum_ids']);
                            },
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                hintText: " Class",
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
                            items:classData == null ? null : classData!
                                    .map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem<String>(
                                      value: classData!
                                          .indexOf(item)
                                          .toString(),
                                      child: Text(
                                        ('Class: ${item['name']}'),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    );
                                  }).toList(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 20.h),
                          child: DropdownButtonFormField(
                            validator: (dynamic value) =>
                                value == null ? 'Field Required' : null,
                            value: _teacherBatchSelected,
                            isExpanded: true,
                            onChanged: (dynamic newVal) {
                              setState(() {
                                {
                                  _teacherBatchSelected = newVal;
                                  division_id =  divisionData![int.parse(newVal)]['_id'];
                                  division_name =  divisionData![int.parse(newVal)]['name'];
                                  curiculam_id = divisionData![int.parse(newVal)]['curriculum'];
                                  session_id = divisionData![int.parse(newVal)]['session'];
                                }
                              });
                              getTeacherData(divisionid: divisionData![int.parse(newVal)]['_id'],divisionCurriculumId: divisionData![int.parse(newVal)]['curriculum'] ,divisionSessionId: divisionData![int.parse(newVal)]['session'] );
                            },
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                hintText: " Division",
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
                            items: divisionData == null ? null : divisionData!
                                    .map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem<String>(
                                      value:  divisionData!
                                          .indexOf(item)
                                          .toString(),
                                      child: Text(
                                        'Division: ${item['name']}', maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        // maxLines: 1,
                                      ),
                                    );
                                  }).toList(),
                          ),
                        ),


                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 30.h),
                          child: DropdownButtonFormField(
                            value: _teacherListSelected,
                            isExpanded: true,
                            onChanged: (dynamic newVal) {
                              setState(() {
                                _teacherListSelected = newVal;
                                selectedteacher_Name = teacherData![int.parse(newVal)]['name'];
                                selectedteacher_Id = teacherData![int.parse(newVal)]['_id'];
                              });
                            },
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                hintText: " Teacher",
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
                            items: teacherData == null ? null : teacherData!
                                .map<DropdownMenuItem<dynamic>>((item) {
                              return DropdownMenuItem<dynamic>(
                                value: teacherData!
                                    .indexOf(item)
                                    .toString(),
                                child: Text(item['name'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                print('validation success');
                                {
                                  if (_formKey.currentState!.validate()) {
                                    print('validation success');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                learningwalkIndicators(
                                                  class_id: class_id,
                                                  class_Name: class_name,
                                                  session_Id: session_id,
                                                  academicyear: academic_year,
                                                  curriculam_Id: curiculam_id,
                                                  division_name:division_name,
                                                  division_id:division_id,
                                                  selectedteacher_Id: selectedteacher_Id,
                                                  roleUnderLoginTeacher: widget
                                                      .roleUnderLoginTeacher,
                                                  teacherImage: teacherImage,
                                                  loginname: widget.loginname,
                                                  teachername:
                                                      widget.teachername,
                                                  image: widget.image,
                                                  schoolid: widget.schoolid,
                                                  userid: widget.userid,
                                                  OB_ID: widget.OB_Id,
                                                  role_id: widget.role_id,
                                                  Image: widget.Image,
                                                  selectedteacher_Name: selectedteacher_Name ?? '',
                                                  // subjectName:
                                                  //     _teacherSubjectSelected
                                                  //         .toString()
                                                  //         .split('/')[0],
                                                  // teacherData:
                                                  //     widget.teacherData,
                                                  classname: class_batchName,
                                                  teacherId: teacherId,
                                                  // classId: classid,
                                                  // batchId: batchid,
                                                  HOS_id: widget.HOS_ID,
                                                  main_userId: widget.main_user,
                                                  user_roleId:
                                                      widget.user_roleid,

                                                  observationList:
                                                      widget.observationDataa,
                                                  learningData:
                                                      widget.learningData,
                                                  value: _textController.text,
                                                  // subject_id:
                                                  //     _teacherSubjectSelected
                                                  //         .toString()
                                                  //         .split('/')[1],
                                                )));
                                  } else {
                                    print('validation failed');
                                  }
                                }
                              } else {
                                print('validation failed');
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 75, right: 75),
                              child: Container(
                                  height: 60.h,
                                  // width: 220.w,
                                  decoration: BoxDecoration(
                                    color: Color(0xff42C614),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Continue',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ]))
            ])
          ]),
        ));
  }
}


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
import '../Leadership/LearningWalk_Model.dart';
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
  // List<dynamic>? teacherData;
  List<dynamic>? observationDataa;
  Map<String, dynamic>? learningData;
  bool? admin;
  Learningwalknew? learningwalknew;
  List<dynamic> loginRoleid;
  learningWalk(
      {Key? key,
      this.role_id,
      this.loginname,
      this.admin,
      this.schoolid,
      required this.loginRoleid,
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
      this.learningwalknew,
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
  List<Response>? classDetails;
  List<Batches>? divisionDetails;
  List<Teachers>? teacherDetails;

  int? _teacherListSelectedIndex;
  int? _teacherClassSelectedIndex;
  getdata() {
    print("-----gcnhcfgnh------${widget.learningwalknew!.status!.message}");
    if(widget.learningwalknew!.data!.details!.response != null){
      classDetails = widget.learningwalknew!.data!.details!.response;
      classDetails!.sort((a, b) {
        // Convert names to lowercase for case-insensitive sorting
        final aLower = a.name!.toLowerCase();
        final bLower = b.name!.toLowerCase();

        // Check if both names are numeric
        bool isANumeric = double.tryParse(aLower) != null;
        bool isBNumeric = double.tryParse(bLower) != null;

        if (isANumeric && isBNumeric) {
          // If both are numeric, compare as numbers
          return double.parse(aLower).compareTo(double.parse(bLower));
        } else {
          // If at least one is not numeric, compare lexicographically
          return aLower.compareTo(bLower);
        }
      });
    }

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
                            onTap: (){
                              setState(() {
                                _teacherBatchSelected = null;
                                _teacherListSelected = null;
                              });
                            },
                            validator: (dynamic value) =>
                                value == null ? 'Class is required' : null,
                            value: _teacherClassSelected,
                            isExpanded: true,
                            onChanged: (dynamic newVal) {
                              print('-------newVal$newVal');
                              setState(() {
                                // divisionDetails = null;
                              _teacherClassSelected = newVal;
                              class_id = classDetails![int.parse(newVal)].sId;
                              class_name = classDetails![int.parse(newVal)].name;
                              divisionDetails = classDetails![int.parse(newVal)].batches;
                              divisionDetails!.sort((a, b) => a.batch!.compareTo(b.batch!));
                              });

                              print('-------newVal$newVal');
                               // getdivisionData( classSessionId: classData![int.parse(newVal)]['session_ids'], classCurriculumId: classData![int.parse(newVal)]['curriculum_ids']);
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
                            items:classDetails == null ? null : classDetails!
                                    .map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem<String>(
                                      value: classDetails!
                                          .indexOf(item)
                                          .toString(),
                                      child: Text(
                                        ('Class: ${item.name}'),
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
                            onTap: (){
                              setState(() {

                                _teacherListSelected = null;
                              });
                            },
                            validator: (dynamic value) =>
                                value == null ? 'Division is required' : null,
                            value: _teacherBatchSelected,
                            isExpanded: true,
                            onChanged: (dynamic newVal) {
                              setState(() {
                                {
                                  _teacherBatchSelected = newVal;
                                  teacherDetails = divisionDetails![int.parse(newVal)].teachers;
                                  teacherDetails!.sort((a, b) => a.name!.compareTo(b.name!));
                                  division_id =  divisionDetails![int.parse(newVal)].batchId;
                                  division_name =  divisionDetails![int.parse(newVal)].batch;
                                  curiculam_id = divisionDetails![int.parse(newVal)].curriculumId;
                                  session_id = divisionDetails![int.parse(newVal)].sessionId;

                                }
                              });
                              // getTeacherData(divisionid: divisionData![int.parse(newVal)]['_id'],divisionCurriculumId: divisionData![int.parse(newVal)]['curriculum'] ,divisionSessionId: divisionData![int.parse(newVal)]['session'] );
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
                            items: divisionDetails == null ? null : divisionDetails!
                                    .map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem<String>(
                                      value:  divisionDetails!
                                          .indexOf(item)
                                          .toString(),
                                      child: Text(
                                        'Division: ${item.batch}', maxLines: 1,
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
                                selectedteacher_Name = teacherDetails![int.parse(newVal)].name;
                                selectedteacher_Id = teacherDetails![int.parse(newVal)].userId;
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
                            items: teacherDetails == null ? null : teacherDetails!
                                .map<DropdownMenuItem<dynamic>>((item) {
                              return DropdownMenuItem<dynamic>(
                                value: teacherDetails!
                                    .indexOf(item)
                                    .toString(),
                                child: Text(item.name!,
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
                                                  learningwalknew: widget.learningwalknew,
                                                  class_id: class_id,
                                                  class_Name: class_name,
                                                  session_Id: session_id,
                                                  academicyear: academic_year,
                                                  curriculam_Id: curiculam_id,
                                                  division_name:division_name,
                                                  division_id:division_id,
                                                  selectedteacher_Id: selectedteacher_Id,
                                                  selectedteacher_Name: selectedteacher_Name ?? '',
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
                                                  loginRoleid: widget.loginRoleid,
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

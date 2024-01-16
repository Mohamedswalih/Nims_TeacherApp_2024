import 'dart:async';

import 'package:bmteacher/exports.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;
import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../History/constant.dart';
import '../Leadership/Leadership.dart';
import 'LessonObservationPage2.dart';

class lessonObservation extends StatefulWidget {
  var roleUnderLoginTeacher;
  Map<String, dynamic>? data;
  String? subjectName;
  String? teacherName;
  String? image;
  String? teachername;
  String? classname;
  String? batchname;
  String? class_batchName;
  String? teacherid;
  String? classid;
  String? batchid;
  String? Subjectid;
  String? session_id;
  String? curiculam_id;
  final String? userid;
  final String? academicyear;
  final String? schoolid;
  final String? subject_id;
  final String? username;
  final String? Image;
  final String? HOS_ID;
  final String? main_user;
  final String? user_roleid;
  var OB_Id;
  var role_id;
  var loginname;
  List<dynamic>? teacherData;
  List<dynamic>? observationData;
  Map<String, dynamic>? lessonData;
  lessonObservation({
    Key? key,
    this.Image,
    this.roleUnderLoginTeacher,
    this.loginname,
    this.role_id,
    this.username,
    this.userid,
    this.schoolid,
    this.academicyear,
    this.subjectName,
    this.OB_Id,
    this.Subjectid,
    this.lessonData,
    this.teacherName,
    this.teachername,
    this.observationData,
    this.class_batchName,
    this.image,
    this.classname,
    this.teacherData,
    this.teacherid,
    this.batchname,
    this.batchid,
    this.classid,
    this.curiculam_id,
    this.data,
    this.HOS_ID,
    this.main_user,
    this.session_id,
    this.subject_id,
    this.user_roleid,
  }) : super(key: key);

  @override
  State<lessonObservation> createState() => _lessonObservationState();
}

class _lessonObservationState extends State<lessonObservation> {
  String? teacherName;
  String? teacherId;
  String? subjectName;
  String? classid;
  String? classname;
  String? batchname;
  String? batchid;
  String? class_batchName;
  String? session_id;
  String? subject_id;
  String? curiculam_id;
  Map<String, dynamic>? notificationResult;
  int Count = 0;
  Timer? timer;
  late List<String> className = [];
  final _formKey = GlobalKey<FormState>();
  var teacherImage;
  getPreferenceData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      count = preferences.get("count");
      print('notification count---->${preferences.get("count")}');
    });
  }

  int charLengthtopic = 0;

  _onChangedtopic(String value) {
    setState(() {
      charLengthtopic = value.length;
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
    getdata();
    getNotification();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    print('lesson obroleUnderLoginTeacher${widget.roleUnderLoginTeacher}');
    super.initState();
  }

  var _textController = new TextEditingController();
  get builder => null;
  Object? dropdownValue;
  var count;
  Object? _teacherListSelected;
  Object? _teacherClassSelected;
  Object? _teacherSubjectSelected;

  int? _teacherListSelectedIndex;
  int? _teacherClassSelectedIndex;
  getdata() {
    print(
        'lesson data in page2------------>lesson data in page2------------>${widget.lessonData}');
    // print(widget.teacherData);
    // print(widget.teacherData![0]['teacher_name']);
    // //teacherName = widget.teacherData![0]['teacher_name'];
    // print(teacherName);
  }

  @override
  void didUpdateWidget(covariant lessonObservation oldWidget) {
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
                          position: badges.BadgePosition.bottomEnd(
                              end: -7, bottom: 12),
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
                          padding: const EdgeInsets.only(left: 20, top: 30),
                          child: Text(
                            "Lesson Observation",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 30.h),
                          child: DropdownButtonFormField(
                            validator: (dynamic value) =>
                                value == null ? 'Field Required' : null,
                            value: _teacherListSelected,
                            isExpanded: true,
                            onChanged: (dynamic newVal) {
                              setState(() {
                                _teacherListSelected = newVal;

                                _teacherListSelectedIndex =
                                    int.parse(newVal.toString());
                                _teacherClassSelected = null;
                                _teacherClassSelectedIndex = null;
                                _teacherSubjectSelected = null;
                                teacherName = widget.teacherData![
                                    _teacherListSelectedIndex!]['teacher_name'];
                                teacherImage = widget.teacherData![
                                        _teacherListSelectedIndex!]
                                    ['teacher_image'];
                                teacherId = widget.teacherData![
                                    _teacherListSelectedIndex!]['teacher_id'];
                                print(teacherName);
                                print(
                                    'teacherid---------------------------------->$teacherId');
                                print(
                                    'teacherid---------------------------------->$teacherImage');
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
                            items: widget.teacherData!
                                .map<DropdownMenuItem<dynamic>>((item) {
                              return DropdownMenuItem<dynamic>(
                                value: widget.teacherData!
                                    .indexOf(item)
                                    .toString()
                                    .toCapitalCase(),
                                child: Text(
                                  item['teacher_name']
                                      .toString()
                                      .toCapitalCase(),
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
                            value: _teacherClassSelected,
                            isExpanded: true,
                            onChanged: (dynamic newVal) {
                              setState(() {
                                _teacherClassSelected = newVal;
                                _teacherClassSelectedIndex =
                                    int.parse(newVal.toString());
                                _teacherSubjectSelected = null;
                                classid = widget.teacherData![
                                        _teacherListSelectedIndex!]['details']
                                    [_teacherClassSelectedIndex]['class_id'];
                                classname = widget.teacherData![
                                        _teacherListSelectedIndex!]['details']
                                    [_teacherClassSelectedIndex]['class_name'];
                                batchname = widget.teacherData![
                                        _teacherListSelectedIndex!]['details']
                                    [_teacherClassSelectedIndex]['batch_name'];
                                batchid = widget.teacherData![
                                        _teacherListSelectedIndex!]['details']
                                    [_teacherClassSelectedIndex]['batch_id'];
                                class_batchName =
                                    '${classname}' + " " + '${batchname}';
                                session_id = widget.teacherData![
                                        _teacherListSelectedIndex!]['details']
                                    [_teacherClassSelectedIndex]['session_id'];
                                curiculam_id = widget.teacherData![
                                            _teacherListSelectedIndex!]
                                        ['details'][_teacherClassSelectedIndex]
                                    ['curriculum_id'];
                              });
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
                            items: _teacherListSelected == null
                                ? null
                                : widget
                                    .teacherData![_teacherListSelectedIndex!]
                                        ['details']
                                    .map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem<String>(
                                      value: widget.teacherData![
                                              _teacherListSelectedIndex!]
                                              ['details']
                                          .indexOf(item)
                                          .toString(),
                                      child: Text(
                                        (item['class_name'] +
                                            " " +
                                            item['batch_name']),
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
                            value: _teacherSubjectSelected,
                            isExpanded: true,
                            onChanged: (dynamic newVal) {
                              setState(() {
                                {
                                  _teacherSubjectSelected = newVal;
                                  print(_teacherSubjectSelected);

                                  print(
                                      'subjectid-------------------------------------->$subject_id');
                                }
                              });
                            },
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                hintText: " Subject",
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
                            items: _teacherClassSelected == null
                                ? null
                                : widget
                                    .teacherData![_teacherListSelectedIndex!]
                                        ['details'][_teacherClassSelectedIndex]
                                        ['subject_details']
                                    .map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem<String>(
                                      value: item['subject_name'] +
                                          "/" +
                                          item['subject_id'],
                                      child: Text(
                                        item['subject_name'], maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        // maxLines: 1,
                                      ),
                                    );
                                  }).toList(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 20.h),
                          child: TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? '  Field Required' : null,
                            controller: _textController,
                            cursorColor: Colors.grey,
                            keyboardType: TextInputType.text,
                            maxLength: 100,
                            decoration: dropFieldDecoration,
                            maxLines: 5,
                            onChanged: _onChangedtopic,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 280, top: 2),
                          child: Text(
                            '$charLengthtopic/100',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                print('validation success');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            lessonObservationPg2(
                                              roleUnderLoginTeacher:
                                                  widget.roleUnderLoginTeacher,
                                              teacherImage: teacherImage,
                                              loginname: widget.loginname,
                                              teachername: widget.teachername,
                                              image: widget.image,
                                              schoolid: widget.schoolid,
                                              userid: widget.userid,
                                              academicyear: widget.academicyear,
                                              OB_ID: widget.OB_Id,
                                              role_id: widget.role_id,
                                              Image: widget.Image,
                                              teacherName: teacherName,
                                              subjectName:
                                                  _teacherSubjectSelected
                                                      .toString()
                                                      .split('/')[0],
                                              teacherData: widget.teacherData,
                                              classname: class_batchName,
                                              teacherId: teacherId,
                                              classId: classid,
                                              batchId: batchid,
                                              HOS_id: widget.HOS_ID,
                                              main_userId: widget.main_user,
                                              user_roleId: widget.user_roleid,
                                              session_Id: session_id,
                                              curriculam_Id: curiculam_id,
                                              observationList:
                                                  widget.observationData,
                                              lessonData: widget.lessonData,
                                              value: _textController.text,
                                              subject_id:
                                                  _teacherSubjectSelected
                                                      .toString()
                                                      .split('/')[1],
                                            )));
                              } else {
                                print('validation failed');
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 75, right: 75),
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

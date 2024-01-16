import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:bmteacher/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Network/api_constants.dart';
import '../../../Utils/color_utils.dart';
import '../../History/constant.dart';
import '../../Leadership/Leadership.dart';

class resultPage extends StatefulWidget {
  var loginedUserName;
  String? images;
  String? name;
  String? Subject_name = '';
  String? Doneby = '';
  String? Date = '';
  String? Observerid;
  resultPage({
    Key? key,
    this.loginedUserName,
    this.images,
    this.name,
    this.Date,
    this.Doneby,
    this.Observerid,
    this.Subject_name,
  }) : super(key: key);

  @override
  State<resultPage> createState() => _resultPageState();
}

class _resultPageState extends State<resultPage> {
  bool isSpinner = false;
  final _formKey = GlobalKey<FormState>();
  var nodata = ' ';
  var _reasontextController = new TextEditingController();
  var _summarytextController = new TextEditingController();
  var _whatwentwelltextController = new TextEditingController();
  var _evenbetteriftextController = new TextEditingController();
  var _total_percentagetextController = new TextEditingController();
  var _total_gradetextController = new TextEditingController();
  var _teachertextController = new TextEditingController();
  Map<String, dynamic>? ObservationResult;
  // Map<String, dynamic>? ObservationResultList;
  var ObservationResultList = [];
  var Strength;
  var Areasforimprovements;
  var RemedialMeasures;
  var class_id;
  var curriculum_id;
  var loId;
  var class_and_batch = '';
  var topic_lesson;
  var isjoin;
  var total_percentage;
  var total_grade;
  var observer_id;
  var SCHOOL_id;
  var session_id;
  var user_id;
  var username;
  var Type;
  var TeacherComment;
  var count;
  int Count = 0;
  Map<String, dynamic>? notificationResult;
  getNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var loginname = preferences.getString('name');
    print('userIDuserIDuserID$userID');
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

  getCount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      count = preferences.get("count");
    });
  }

  Timer? timer;
  void initState() {
    getObservationResultdata();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    getNotification();
    super.initState();
  }

  Future getObservationResultdata() async {
    print('callingdetdata');
    setState(() {
      isSpinner = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var schoolID = preferences.getString('school_id');
    var academicyear = preferences.getString('academic_year');
    print("____---shared$schoolID");
    print("____---id${widget.Observerid}");
    print("____---academic$academicyear");
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };

    var request = http.Request('GET',
        Uri.parse('${ApiConstants.ObservationResultlist}${widget.Observerid}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseJson = await response.stream.bytesToString();
      setState(() {
        ObservationResult = json.decode(responseJson);
        print('....ObservationResult$ObservationResult');
        ObservationResultList = ObservationResult!['data']['details']
            ['remarks_data'][0]['Indicators'];
        log('....ObservationResultList$ObservationResultList');
        Strength = ObservationResult!['data']['details']['strengths'][0];
        Areasforimprovements =
            ObservationResult!['data']['details']['areas_for_improvement'][0];
        RemedialMeasures =
            ObservationResult!['data']['details']['remedial_measures'];
        class_id = ObservationResult!['data']['details']['class_id'];
        curriculum_id = ObservationResult!['data']['details']['curriculum_id'];
        loId = ObservationResult!['data']['details']['_id'];
        observer_id = ObservationResult!['data']['details']['observer_id'];
        SCHOOL_id = ObservationResult!['data']['details']['school_id'];
        session_id = ObservationResult!['data']['details']['session_id'];
        user_id = ObservationResult!['data']['details']['teacher_id'];
        username = ObservationResult!['data']['details']['teacher_name'];
        Type = ObservationResult!['data']['details']['type'];
        class_and_batch =
            ObservationResult!['data']['details']['class_batch_name'];
        topic_lesson = ObservationResult!['data']['details']['topic'];
        isjoin = ObservationResult!['data']['details']['isJoin'];
        total_percentage = ObservationResult!['data']['details']['evaluation']['total_percentage'];
        total_grade = ObservationResult!['data']['details']['evaluation']['total_grade'];
        TeacherComment =
            ObservationResult!['data']['details']['teacherComment'] ?? '';
        _teachertextController.text = TeacherComment ?? '';
        print('....Strength$Strength');
        print('....total_percentage$total_percentage');
        print('....total_grade$total_grade');
        print('....Areasforimprovements$Areasforimprovements');
        print('....RemedialMeasures$RemedialMeasures');
      });
      _summarytextController.text = Strength;
      _whatwentwelltextController.text = Areasforimprovements;
      _evenbetteriftextController.text = RemedialMeasures;
      setState(() {
        isSpinner = false;
      });
    } else {
      setState(() {
        isSpinner = false;
      });
      nodata = 'No Data';
    }
    // print('------------api response---------------$response');
    // ObservationData = response;
    // ObservationDataList = response['data']['details'];
    // print('------------api response---------------$ObservationData');
    // print('------------ObservationDataList---------------$ObservationDataList');
    // if (ObservationData!.isEmpty ) {
    //   setState(() {
    //     isSpinner = false;
    //   });
    //   nodata = 'No Data';
    // }
  }

  Future submitRemarksLesonObservation() async {
    setState(() {
      isSpinner = true;
    });
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var body = {
      "class_id": class_id,
      "comment": _reasontextController.text,
      "curriculum_id": curriculum_id,
      "loId": loId,
      "observer_id": observer_id,
      "school_id": SCHOOL_id,
      "session_id": session_id,
      "user_id": user_id,
      "username": username
    };
    print('---b-o-d-y-obsubmitLessonObservation--${body}');
    var request = await http.post(
        Uri.parse(ApiConstants.ObservationResultSubmitLessonObservation),
        headers: headers,
        body: json.encode(body));
    var response = json.decode(request.body);
    if (response['status']['code'] == 200) {
      log('----------rsssssobsubmitLessonObservation${response}');
      print('----------rsssssobsubmitLessonObservation${response['data']}');
      print(
          '----------rsssssobsubmitLessonObservation${response['data']['message']}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response['data']['message']}'),
        backgroundColor: Colors.green,
      ));
    }
    setState(() {
      isSpinner = false;
    });
    Navigator.of(context).pop();
  }

  Future submitRemarksLearningWalk() async {
    setState(() {
      isSpinner = true;
    });
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var body = {
      "class_id": class_id,
      "comment": _reasontextController.text,
      "curriculum_id": curriculum_id,
      "loId": loId,
      "observer_id": observer_id,
      "school_id": SCHOOL_id,
      "session_id": session_id,
      "user_id": user_id,
      "username": username
    };
    print('---b-o-d-y-obsubmitLearningwalk--${body}');
    var request = await http.post(
        Uri.parse(ApiConstants.ObservationResultSubmitLearningWalk),
        headers: headers,
        body: json.encode(body));
    var response = json.decode(request.body);
    if (response['status']['code'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response['data']['message']}'),
        backgroundColor: Colors.green,
      ));
    }

    //log('----------reqbdyy${request.body}');
    log('----------rsssssbdyy${response}');
    setState(() {
      isSpinner = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: ColorUtils.BACKGROUND,
      body: LoadingOverlay(
        opacity: 0,
        isLoading: isSpinner,
        progressIndicator: CircularProgressIndicator(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
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
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                        margin: const EdgeInsets.all(6),
                        child: Image.asset("assets/images/goback.png")),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              widget.loginedUserName,
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
                // padding: EdgeInsets.only(
                //     bottom: MediaQuery.of(context).viewInsets.bottom),
                margin: EdgeInsets.only(left: 10.w, top: 130.h, right: 10.w),
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${widget.Subject_name}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[800]),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '-  ${class_and_batch}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[800]),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 220.w,
                                  child: Text(
                                    '${widget.Doneby}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 150.w,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    '${widget.Date!.split('T')[0].split('-').last}-${widget.Date!.split('T')[0].split('-')[1]}-${widget.Date!.split('T')[0].split('-').first}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            topic_lesson != null
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Type == 'lesson_observation'
                                          ? Container(
                                              width: 200.w,
                                              child: Text(
                                                'Topic:${topic_lesson.toString()[0].toUpperCase()}${topic_lesson.toString().substring(1, topic_lesson.toString().length)}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blueAccent),
                                              ),
                                            )
                                          : Text(''),
                                      isjoin != null
                                          ? Text(
                                              'Joined:${isjoin.toString()[0].toUpperCase()}${isjoin.toString().substring(1, isjoin.toString().length)}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blueAccent),
                                            )
                                          : Text('')
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Joined:${isjoin.toString()[0].toUpperCase()}${isjoin.toString().substring(1, isjoin.toString().length)}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blueAccent),
                                      )
                                    ],
                                  ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // height: ObservationResultList.length * 110.h,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: ObservationResultList.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _resultlist(index,
                                            Observation:
                                                ObservationResultList[index]
                                                    ['name'],
                                            Result: ObservationResultList[index]
                                                ['remark']);
                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height: 25.h,
                                          width: 165.w,
                                          decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                              border: Border.all(
                                                  color: Colors.grey,width: 0.3),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                              )),child: Center(child: Text('Score %',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),))),
                                      Container(
                                          height: 25.h,
                                          width: 165.w,
                                          decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                              border: Border.all(
                                                  color: Colors.grey,width: 0.3),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                              )),child: Center(child: Text('Rating',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),))),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height: 25.h,
                                          width: 165.w,
                                          decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                              border: Border.all(
                                                  color: Colors.grey,width: 0.1)),child: Center(child: Text('100-95',style: TextStyle(fontSize: 12)))),
                                      Container(
                                        height: 25.h,
                                        width: 165.w,
                                        decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                            border:
                                                Border.all(color: Colors.grey,width: 0.1)),child: Center(child: Text('Outstanding',style: TextStyle(fontSize: 12)))
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height: 25.h,
                                          width: 165.w,
                                          decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                              border: Border.all(
                                                  color: Colors.grey,width: 0.1)),child: Center(child: Text('94-85',style: TextStyle(fontSize: 12)))),
                                      Container(
                                        height: 25.h,
                                        width: 165.w,
                                        decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                            border:
                                                Border.all(color: Colors.grey,width: 0.1)),child: Center(child: Text('Very Good',style: TextStyle(fontSize: 12)))
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height: 25.h,
                                          width: 165.w,
                                          decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                              border: Border.all(
                                                  color: Colors.grey,width: 0.1)),child: Center(child: Text('84-66',style: TextStyle(fontSize: 12)))),
                                      Container(
                                        height: 25.h,
                                        width: 165.w,
                                        decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                            border:
                                                Border.all(color: Colors.grey,width: 0.1)),child: Center(child: Text('Good',style: TextStyle(fontSize: 12)))
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height: 25.h,
                                          width: 165.w,
                                          decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                              border: Border.all(
                                                  color: Colors.grey,width: 0.1)),child: Center(child: Text('65-41',style: TextStyle(fontSize: 12)))),
                                      Container(
                                        height: 25.h,
                                        width: 165.w,
                                        decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                            border:
                                                Border.all(color: Colors.grey,width: 0.1)),child: Center(child: Text('Acceptable',style: TextStyle(fontSize: 12)))
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height: 25.h,
                                          width: 165.w,
                                          decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                              border: Border.all(
                                                  color: Colors.grey,width: 0.1),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                              )),child: Center(child: Text('40-0',style: TextStyle(fontSize: 12)))),
                                      Container(
                                          height: 25.h,
                                          width: 165.w,
                                          decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),
                                              border: Border.all(
                                                  color: Colors.grey,width: 0.1),
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                              )),child: Center(child: Text('Weak',style: TextStyle(fontSize: 12)))),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Summary',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    controller: _summarytextController,
                                    cursorColor: Colors.grey,
                                    decoration: dropTextFieldDecoration,
                                    keyboardType: TextInputType.text,
                                    maxLines: 5,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'What Went Well',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    controller: _whatwentwelltextController,
                                    cursorColor: Colors.grey,
                                    decoration: dropTextFieldDecoration,
                                    keyboardType: TextInputType.text,
                                    maxLines: 5,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Even Better If',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    controller: _evenbetteriftextController,
                                    cursorColor: Colors.grey,
                                    decoration: dropTextFieldDecoration,
                                    keyboardType: TextInputType.text,
                                    maxLines: 5,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(20, 15, 0, 5),
                                    width: 350.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(color: Color.fromRGBO(230, 236, 254, 8),borderRadius: BorderRadius.circular(10)),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text('Grade: ${total_grade.toString()[0].toUpperCase()}${total_grade.toString().substring(1, total_grade.toString().length)}',style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500),),
                                        // SizedBox(
                                        //   height: 5.h,
                                        // ),
                                        Text('(${_percentage(total_percentage)})',style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Teacher Comment',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  (TeacherComment.toString().isEmpty)
                                      ? Focus(
                                          autofocus: true,
                                          child: Form(
                                            key: _formKey,
                                            child: TextFormField(
                                              maxLength: 500,
                                              validator: (val) => val!.isEmpty
                                                  ? '  *Enter the Reason'
                                                  : null,
                                              controller: _reasontextController,
                                              cursorColor: Colors.grey,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                              ),
                                              keyboardType: TextInputType.text,
                                              maxLines: 5,
                                            ),
                                          ),
                                        )
                                      : TextFormField(
                                          readOnly: true,
                                          controller: _teachertextController,
                                          cursorColor: Colors.grey,
                                          decoration: dropTextFieldDecoration,
                                          keyboardType: TextInputType.text,
                                          maxLines: 5,
                                        ),
                                  (TeacherComment.toString().isEmpty)
                                      ? GestureDetector(
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (Type ==
                                                  'lesson_observation') {
                                                submitRemarksLesonObservation();
                                                // Navigator.of(context).pop();
                                              } else {
                                                if (Type == 'learning_walk') {
                                                  submitRemarksLearningWalk();
                                                  // Navigator.of(context).pop();
                                                }
                                              }
                                            }
                                          },
                                          child: Container(
                                              height: 60.h,
                                              // width: 220.w,
                                              decoration: BoxDecoration(
                                                color: Color(0xff42C614),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultlist(
    int index, {
    String? Observation,
    // int? index,
    String? Result,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: 100.h,
            width: 350.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Result == 'NA'
                  ? Colors.red[300]
                  : Result == 'Weak'
                      ? Colors.yellow[600]
                      : Result == 'Acceptable'
                          ? Colors.yellow[800]
                          : Result == 'Good'
                              ? Colors.green[300]
                              : Result == 'Very Good'
                                  ? Colors.green
                                  : Result == 'Outstanding'
                                      ? Colors.green[700]
                                      : Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          // width: 300.w,
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Observation:',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.black),
                          ),
                          Container(
                            // width: 350.w,
                            child: Text(
                              '$Observation',
                              // 'Observation:',
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.white),
                            ),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                          width: 240.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Result:',
                                // 'Result:',
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.black),
                              ),
                              Text(
                                '$Result',
                                // 'Result:',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  // color: Result == 'NA'
                                  //     ? Colors.red[300]
                                  //     : Result == 'Weak'
                                  //         ? Colors.yellow[700]
                                  //         : Result == 'Acceptable'
                                  //             ? Colors.yellow[400]
                                  //             : Result == 'Good'
                                  //                 ? Colors.green[200]
                                  //                 : Result == 'Very Good'
                                  //                     ? Colors.green[400]
                                  //                     : Result ==
                                  //                             'Outstanding'
                                  //                         ? Colors.green[600]
                                  //                         : Colors.blue[50]
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      );
  String _percentage(percent){
    if(percent.toString().contains('.')){
      if(percent.toString().length>5){
        return '${percent.toString().split('.').first}.${percent.toString().split('.').last.substring(0,2)}%';
      }else{
        return '${percent.toString()}%';
      }
    }else{
      return '${percent.toString()}%';
    }
  }
}

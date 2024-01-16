import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bmteacher/exports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Network/api_constants.dart';
import '../../../Utils/color_utils.dart';
import 'package:badges/badges.dart' as badges;
import 'Leave_Request_Approval.dart';

class leaverequest extends StatefulWidget {
  var roleUnderLoginTeacher;
  var newTeacherData;
  var loginedUserName;
  String? images;
  String? name;
  String? selectedDate;
  var teacherClasses;
  String? user_id;
  String? school_id;
  Object? classAndDivision;
  String? academic_year;
  String? session_id;
  String? curriculam_id;
  String? class_id;
  String? batch_id;
  String? className;
  String? batchName;
  String? userId;
  var teacherData;
  bool? notclassteacher;
  leaverequest(
      {Key? key,
      this.teacherData,
      this.newTeacherData,
      this.notclassteacher,
      this.user_id,
      this.teacherClasses,
      this.classAndDivision,
      this.batchName,
      this.className,
      this.userId,
      this.batch_id,
      this.class_id,
      this.curriculam_id,
      this.session_id,
      this.academic_year,
      this.school_id,
      this.name,
      this.selectedDate,
      this.images,
      this.roleUnderLoginTeacher,
      this.loginedUserName})
      : super(key: key);
  @override
  State<leaverequest> createState() => _leaverequestState();
}

class _leaverequestState extends State<leaverequest> {
  var cLASS = [];
  int Count = 0;
  Map<String, dynamic>? notificationResult;
  Timer? timer;
  var newStudentList = [];
  var ourStudentList;
  var isStudentListnull = [];
  var modifiedStudentList = [];
  var SubjectIds = [
    "subject123456",
    "subjectArtEdu6",
    "765d8gfheHJNt",
    "subjectDesc",
    "subject123",
    "subjectGenKnwi",
    "5d08b782035c5c68be840d43",
    "subject1234",
    "3h2S6noQZiAkP",
    "subject12345",
    "765d8gfhNVVert",
    "yj6wZhLmLWAtb",
    "subjectHealthAndPE",
    "5d0f0eb1a0a6ad1dc97a61d0",
    "c4A25ahdFonzb",
    "hnAttZHatyQRA",
    "7658gfhNNBVVert"
  ];
  var leavereqlist = [];
  bool isSpinner = false;
  var cLASSNAME;
  var bATCHNAME;
  var sessionID;
  var curriculumID;
  var sessionName;
  var curriculumName;
  var classId;
  var className;
  var batchId;
  var batchName;
  var studentssssss = [];
  var studentssssssName;
  var studentssssssID;
  var admissionNUM;
  var profileImage;
  Map<String, dynamic>? leavelist;
  var studentListforleave = [];
  var studentlistLeave = {};
  var selectedColor;
  var _searchController = TextEditingController();
  List newResult = [];
  var nodata = ' ';
  var valueeeeeee;
  bool _isListening = false;
  int _selectedIndex = 0;
  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

  Map<String, dynamic>? StudentList;

  getleavelist() async {
    setState(() {
      isSpinner = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var schoolID = preferences.getString('school_id');
    var academicyear = preferences.getString('academic_year');
    print("____---shared$schoolID");
    print("____---user$userID");
    print("____---academic$academicyear");

    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };

    var body = {
      "school_id": schoolID,
      "academic_year": academicyear,
      "user_id": userID,
    };

    print('-b_b-o_o-d_d-y_y____req$body');
    var request = await http.post(Uri.parse(ApiConstants.LeaveRequestList),
        headers: headers, body: json.encode(body));
    var response = json.decode(request.body);
    // print('------------api response---------------$response');
    leavelist = response;
    print('------------api response---------------$leavelist');
    studentListforleave = leavelist!['data']['details'];
    if (studentListforleave.isEmpty) {
      setState(() {
        isSpinner = false;
      });
      nodata = 'No Data';
    }
    sessionID = leavelist!['data']['details'][0]['session_id'];
    curriculumID = leavelist!['data']['details'][0]['curriculum_id'];
    sessionName = leavelist!['data']['details'][0]['session_name'];
    curriculumName = leavelist!['data']['details'][0]['curriculum_name'];
    classId = leavelist!['data']['details'][0]['class_id'];
    className = leavelist!['data']['details'][0]['class_name'];
    batchId = leavelist!['data']['details'][0]['batch_id'];
    batchName = leavelist!['data']['details'][0]['batch_name'];
    studentssssss = leavelist!['data']['details'][0]['students'];
    studentssssssName = studentssssss[0]['name'];
    studentssssssID = studentssssss[0]['studentId'];
    admissionNUM = studentssssss[0]['admission_number'];
    // profileImage = studentssssss[0]['profileImage'];
    studentssssss.forEach((stud) {
      print(stud['name']);
    });

    // print('------------detailsss ---------------$leavelist');
    // print('------------sessionID---------------$sessionID');
    // print('------------curriculumID---------------$curriculumID');
    // print('------------sessionName---------------$sessionName');
    // print('------------curriculumName---------------$curriculumName');
    // print('------------classId---------------$classId');
    // print('------------className---------------$className');
    // print('------------batchId---------------$batchId');
    // print('------------batchName---------------$batchName');
    print('------------studentssssss.....runtimeType---------------${studentssssss.runtimeType}');
    print('------------studentssssss....length---------------${studentssssss.length}');
    print('------------studentssssssName---------------$studentssssssName');
    print('------------studentssssssID---------------$studentssssssID');
    print('------------admissionNUM---------------$admissionNUM');
    print('------------profileImage---------------$profileImage');
    // academicYEAR = studentDataasforleave[1]['academic_year'];
    //leaveId = studentDataasforleave[i]['academic_year'];

    for (int i = 0; i < studentListforleave.length; i++) {
      cLASS.add(
          '${studentListforleave[i]['class_name']} ${studentListforleave[i]['batch_name']}');
      // cLASSNAME = studentListforleave[i]['class_name'];
      // bATCHNAME = studentListforleave[i]['batch_name'];
      leavereqlist.add({
        "class": studentListforleave[i]['class_name'],
        "batch": studentListforleave[i]['batch_name'],
        "sessionanme": studentListforleave[i]['session_name'],
        "curriculumname": studentListforleave[i]['curriculum_name'],
        "curriculumid": studentListforleave[i]['curriculum_id'],
        "batch_id": studentListforleave[i]['batch_id'],
        "class_id": studentListforleave[i]['class_id'],
        "profileimg": studentListforleave[i]['students'][i]['profileImage'] ?? ' ',
        "studentsname": studentListforleave[i]['students'][i]['name'],
        "admission_number": studentListforleave[i]['students'][i]
            ['admission_number']
      });
    }
    log("-----classs--$leavereqlist");

    for (int i = 0; i < studentListforleave.length; i++) {
      print('batch name----${studentListforleave[i]['batch_name']}');
      print('session_name----${studentListforleave[i]['session_name']}');
      print('curriculum_name----${studentListforleave[i]['curriculum_name']}');
      print('batch_id----${studentListforleave[i]['batch_id']}');
      print('class_id----${studentListforleave[i]['class_id']}');
      print('curriculum_id----${studentListforleave[i]['curriculum_id']}');
      // studentlistLeave = {
      //   "${studentListforleave[i]['class_name']} ${studentListforleave[i]['batch_name']}":studentListforleave[i]['students']
      // };
      studentlistLeave.addAll({
        "${studentListforleave[i]['class_name']} ${studentListforleave[i]['batch_name']}":
            studentListforleave[i]['students']
      });
    }

    cLASSNAME = '$className $batchName';

    leavereqlist = studentlistLeave['$className $batchName'];
    // newResult = leavereqlist;

    if (newResult.isEmpty) {
      nodata = 'No Data';
    }

    leavereqlist.sort(
        (a, b) => a["name"].toLowerCase().compareTo(b["name"].toLowerCase()));
    log('studenttt-----tttt${leavereqlist}------endddd');

    setState(() {
      isSpinner = false;
    });
  }

  void initState() {
    getleavelist();
    getNotification();
    // isAClassTeacher();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    super.initState();
  }

  var count;

  @override
  void didUpdateWidget(covariant leaverequest oldWidget) {
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
                  margin: EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
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
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text(
                                'Leave Request',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 75.w,
                              ),
                              Text(
                                'My Class',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                    color: Colors.blueGrey),
                              ),
                              Container(
                                height: 40.h,
                                width: 89.w,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: cLASS.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _classandbatchforleave(
                                          classandbatch: cLASS[index],
                                          subcolorr: subColorList[index],
                                          index: index,
                                          activecolor: ColorUtils.BLACK_GREY);
                                    }),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                //  valueeeeeee = int.parse(value);
                                print('lllllllleave$leavereqlist');
                                print("runtimetype${value}");
                                print(
                                    "runtimetypeval${valueeeeeee.runtimeType}");
                                if (value.contains('1') ||
                                    value.contains('2') ||
                                    value.contains('3') ||
                                    value.contains('4') ||
                                    value.contains('5') ||
                                    value.contains('6') ||
                                    value.contains('7') ||
                                    value.contains('8') ||
                                    value.contains('9') ||
                                    value.contains('0')) {
                                  newResult = leavereqlist
                                      .where((element) =>
                                          element["admission_number"]
                                              .contains("${value.toString()}"))
                                      .toList();
                                  log("the new result is valueeeee$newResult");
                                } else {
                                  newResult = leavereqlist
                                      .where((element) =>
                                          element["name"]
                                              .toString()
                                              .toLowerCase()
                                              .replaceAll(" ", '')
                                              .startsWith("$value") ||
                                          element["name"]
                                              .toString()
                                              .toLowerCase()
                                              .startsWith("$value"))
                                      .toList();
                                  log("the new result is$newResult");
                                }
                                // newResult = leavereqlist
                                //     .where((element) => element["name"]
                                //     .contains("${value.toUpperCase()}"))
                                //     .toList();

                                //newResult = afterAttendanceTaken.where((element) => element["feeDetails"]["username"].contains("${value.toUpperCase()}")).toList();
                                //print(_searchController.text.toString());
                                // log("the new result is   $newResult");
                              });
                            },
                            validator: (val) =>
                                val!.isEmpty ? 'Enter the Topic' : null,
                            cursorColor: Colors.grey,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: _isListening
                                    ? "Listening..."
                                    : "Search Here",
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
                          height: 5.h,
                        ),
                        Container(
                          height: 500.h,
                          child: isSpinner
                              ? Container(
                            color: Colors.white,
                            height: 580.h,
                          )
                              :  newResult.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: newResult.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _approvedLeave(
                                      studentNAme:
                                          '${newResult[index]['name']}',
                                      studentID:
                                          '${newResult[index]['studentId']}',
                                      classNaMe: '${newResult[index]['class']}',
                                      sessionidds:
                                          '${newResult[index]['session_id']}',
                                      curriculamidds:
                                          '${newResult[index]['curriculum_id']}',
                                      batchNaMe: '${newResult[index]['batch']}',
                                      studimage:
                                          '${newResult[index]['profileImage']}',
                                      admissionNuMber:
                                          '${newResult[index]['admission_number']}',
                                      index: index,
                                    );
                                  },
                                  // _approvedLeave(studentNAme:'${studentssssss[i]['name']}' ),
                                  // SizedBox(
                                  //   height: 150.h,
                                  // )
                                )
                              : leavereqlist.isEmpty
                                  ? Center(
                                      child: Image.asset(
                                          "assets/images/nodata.gif"))
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: leavereqlist.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _approvedLeave(
                                          studentNAme:
                                              '${leavereqlist[index]['name']}',
                                          studentID:
                                              '${leavereqlist[index]['studentId']}',
                                          classNaMe:
                                              '${leavereqlist[index]['class']}',
                                          sessionidds:
                                              '${leavereqlist[index]['session_id']}',
                                          curriculamidds:
                                              '${leavereqlist[index]['curriculum_id']}',
                                          batchNaMe:
                                              '${leavereqlist[index]['batch']}',
                                          studimage:
                                              '${leavereqlist[index]['profileImage']}',
                                          admissionNuMber:
                                              '${leavereqlist[index]['admission_number']}',
                                          index: index,
                                        );
                                      },
                                      // _approvedLeave(studentNAme:'${studentssssss[i]['name']}' ),
                                      // SizedBox(
                                      //   height: 150.h,
                                      // )
                                    ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _approvedLeave({
    String? studentNAme,
    int? index,
    String? admissionNuMber,
    String? classNaMe,
    String? sessionidds,
    String? curriculamidds,
    String? batchNaMe,
    String? studentID,
    String? studimage,
  }) =>
      Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          // Divider(color: Colors.black26,height: 2.h,),
          GestureDetector(
            onTap: () {
              NavigationUtils.goNext(
                context,
                leaverequestapproval(
                  teacherClasses: widget.teacherClasses,
                  newTeacherData: widget.newTeacherData,
                  academic_year: widget.academic_year,
                  teacherData: widget.teacherData,
                  loginedUserName: widget.loginedUserName,
                  images: widget.images,
                  name: widget.name,
                  roleUnderLoginTeacher: widget.roleUnderLoginTeacher,
                  studentNAME: studentNAme,
                  studentADMNO: admissionNuMber,
                  studenTID: studentID,
                  sTUDENTCLASSNAME: cLASSNAME,
                  sessionIDSS: sessionID,
                  curriculamIDSS: curriculumID,
                  batchIDSS: batchId,
                  classIDSS: classId,
                  curriculamNAmeess: curriculumName,
                  sessionNAmeess: sessionName,
                  studentimage: studimage,
                ),
              );
              print('--cl---batchId---${batchId}');
              print('--cl---cLASSNAME---${cLASSNAME}');
              print('--cl---sessionID---${sessionID}');
              print('--cl---profileImage---${studimage}');
              print('--cl---sessionName---${sessionName}');
              print('--cl---studentNAme---${studentNAme}');
              print('--cl---curriculumID---${curriculumID}');
              print('--cl---curriculumName---${curriculumName}');
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              width: 360.w,
              // height: 120.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.black26),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFFD6E4FA)),
                            // image: DecorationImage(
                            //   image: NetworkImage('studimage' == ""
                            //       ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                            //       : ApiConstants.IMAGE_BASE_URL +
                            //           "${studimage}"),
                            // ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill,
                              imageUrl:
                                  ApiConstants.IMAGE_BASE_URL + "${studimage}",
                              placeholder: (context, url) => Center(
                                child: Text(
                                  '${studentNAme!.split(' ')[0].toString()[0]}'
                                      // '${studentNAme.split(' ')[1].toString()[0]}'
                                  ,
                                  style: TextStyle(
                                      color: Color(0xFFB1BFFF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: Text(
                                  '${studentNAme!.split(' ')[0].toString()[0]}'
                                      // '${studentNAme.split(' ')[1].toString()[0]}'
                                  ,
                                  style: TextStyle(
                                      color: Color(0xFFB1BFFF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 240.w,
                              child: Text(
                                studentNAme!,
                                // 'NASRUDHEEN MOHAMMED ALI',
                                style: TextStyle(fontSize: 13.sp),
                              )),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Text(admissionNuMber!),
                              SizedBox(
                                width: 60.w,
                              ),
                              // Text('Class: ${classNaMe! + " " + batchNaMe!}'),
                            ],
                          ),
                          // SizedBox(
                          //   height: 5.h,
                          // ),
                          // Text('Reason : '),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          // Row(
                          //   children: [
                          //     Text('No Of Days :'),
                          //
                          //   ],
                          // ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Divider( indent: 20,
          //   endIndent: 20,
          //   height: 5.h,thickness: 3,),
        ],
      );
  Widget _classandbatchforleave({
    String? classandbatch,
    Color? subcolorr,
    Color? activecolor,
    int? index,
  }) =>
      Row(
        children: [
          SizedBox(
            width: 5.w,
          ),
          SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  //newResult.clear();
                  print('class and batch---->$classandbatch');
                  // if(newResult.isNotEmpty){
                  //   newResult.clear();
                  // }
                  selectedColor = activecolor;
                  _onSelected(index!);
                });
                leavereqlist = studentlistLeave['$classandbatch'];
                print('stud list------>$studentlistLeave');
                print('object-------------rrrrrr$leavereqlist');
                cLASSNAME = classandbatch;
                print('--NAME----cLASSNAME${cLASSNAME}');
              },
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                    color: _selectedIndex != null && _selectedIndex == index
                        ? Colors.redAccent
                        : Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(50.r))),
                child: Center(
                  child: Text(
                    classandbatch!,
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}

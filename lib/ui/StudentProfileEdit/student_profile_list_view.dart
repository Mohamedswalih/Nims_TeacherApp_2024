import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Network/api_constants.dart';
import '../../Notification/notification.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import 'package:http/http.dart' as http;

import 'edit_profile_page.dart';

class StudentProfileListView extends StatefulWidget {
  String? image;
  String? name;
  var ClassAndBatch;
  var academicYear;
  var batchId;
  var classId;
  var curriculumId;
  var schoolId;
  var sessionId;
  var userId;

  StudentProfileListView(
      {this.image,
      this.name,
      this.ClassAndBatch,
      this.userId,
      this.academicYear,
      this.batchId,
      this.classId,
      this.curriculumId,
      this.schoolId,
      this.sessionId});

  @override
  _StudentProfileListViewState createState() => _StudentProfileListViewState();
}

class _StudentProfileListViewState extends State<StudentProfileListView> {
  Timer? timer;
  var _searchController = TextEditingController();
  bool isChanged = false;
  bool isLoading = false;
  bool refresh = false;

  Map<String, dynamic>? notificationResult;
  int Count = 0;
  var academicyear;
  getNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    academicyear = preferences.getString('academic_year');
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

  var count;

  getCount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      count = preferences.get("count");
    });
  }

  Map<String, dynamic>? studentList;
  List reoderedStudentList = [];
  List modifiedList = [];

  getNewStudentDetails() async {
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse(ApiConstants.GET_STUDENT_DETAILS_TO_UPDATE));
    request.body = json.encode({
      // "FILE_UPLOAD_URL": "https://teamsqa4000.educore.guru",
      "FILE_UPLOAD_URL": ApiConstants.FILE_SERVER,
      "academic_year": academicyear,
      "batch_id": widget.batchId,
      "class_id": widget.classId,
      "curriculum_id": widget.curriculumId,
      "school_id": widget.schoolId,
      "session_id": widget.sessionId,
      "user_id": widget.userId
    });
    request.headers.addAll(headers);

    log("${request.body}");
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());

      var responseJson = await response.stream.bytesToString();

      setState(() {
        studentList = json.decode(responseJson);
        reoderedStudentList.add(studentList!["data"]["details"]["response"]["students"]);
      });

      //log(">>>>>>>>>>>>>>>>>${reoderedStudentList[0][10]["parent_doc"]["mother_obj"]}");

      //modifiedList = reoderedStudentList[0];


      log("$reoderedStudentList");

      for (int i = 0; i < reoderedStudentList[0].length; i++) {
        modifiedList.add({
          "_id": reoderedStudentList[0][i]["_id"],
          "userId": reoderedStudentList[0][i]["user_id"],
          "roll_number": reoderedStudentList[0][i]["roll_number"] == null
              ? "${i + 1}"
              : reoderedStudentList[0][i]["roll_number"],
          "user_name": reoderedStudentList[0][i]["name"],
          "name": reoderedStudentList[0][i]["name"],
          "admission_number": reoderedStudentList[0][i]["admission_number"],
          "gender": reoderedStudentList[0][i]["gender"],
          "birth_date": reoderedStudentList[0][i]["birth_date"],
          "display_name": reoderedStudentList[0][i]["display_name"],
          "selected": true,
          "session_id": widget.sessionId,
          "curriculum_id": widget.curriculumId,
          "class_id": widget.classId,
          "batch_id": widget.batchId,
          "school_id": widget.schoolId,
          "image": reoderedStudentList[0][i]["student_img"],
          "teacher_id": widget.userId,
          "parent_id": reoderedStudentList[0][i]["parent_id"],
          "father_name": reoderedStudentList[0][i]["parent_doc"] == null ? "" : reoderedStudentList[0][i]["parent_doc"]["name"],
          "father_phone": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["phone"],
          "father_email": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["email"],
          "address_one": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["addrLine1"],
          "address_two": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["addrLine2"],
          "address_three": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["addrLine3"],
          "zip_code": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["pincode"],
          "academic_year": academicyear,
          "bcrypt": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["services"]["password"]["bcrypt"],
          "city": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["city"],
          "country": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["country"],
          "password_tracking": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["password_tracking"],
          "updated_by": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["updated_by"],
          "parent_doc_id": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["_id"],
          "educore_id": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["educore_id"],
          "parent_role_id": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["role_id"],
          "blood_group": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["blood_group"],
          "mother_name": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"] == null ? "" : reoderedStudentList[0][i]["parent_doc"]["mother_obj"]["mother_name"],
          "mother_phone": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"]["mother_mobile"],
          "mother_email": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"]["mother_email"],
        });
      }

      for (int index = 0; index < modifiedList.length; index++) {
        modifiedList
            .sort((a, b) => a["roll_number"].compareTo(b["roll_number"]));
      }

      log("$modifiedList");
    } else {
      print(response.reasonPhrase);
    }
  }

  List rollToBeSubmitted = [];

  SubmitStudentRollNumber() async {
    isLoading=true;
    if (rollToBeSubmitted.isEmpty) {
      for (int index = 0; index < modifiedList.length; index++) {
        rollToBeSubmitted.add({
          "_id": modifiedList[index]["_id"],
          "user_id": modifiedList[index]["userId"],
          "roll_number": index + 1,
          "user_name": modifiedList[index]["name"],
          "name": modifiedList[index]["name"],
          "admission_number": modifiedList[index]["admission_number"],
          "gender": modifiedList[index]["gender"],
          "birth_date": modifiedList[index]["birth_date"],
          "display_name": modifiedList[index]["display_name"],
          "selected": modifiedList[index]["selected"],
          "image": modifiedList[index]["student_img"],
        });
      }
    } else {
      for (int index = 0; index < rollToBeSubmitted.length; index++) {
        rollToBeSubmitted[index]["_id"] = modifiedList[index]["_id"];
        rollToBeSubmitted[index]["user_id"] = modifiedList[index]["userId"];
        rollToBeSubmitted[index]["roll_number"] = index + 1;
        rollToBeSubmitted[index]["name"] = modifiedList[index]["name"];
        rollToBeSubmitted[index]["user_name"] = modifiedList[index]["name"];
        rollToBeSubmitted[index]["admission_number"] =
            modifiedList[index]["admission_number"];
        rollToBeSubmitted[index]["gender"] = modifiedList[index]["gender"];
        rollToBeSubmitted[index]["birth_date"] =
            modifiedList[index]["birth_date"];
        rollToBeSubmitted[index]["display_name"] =
            modifiedList[index]["display_name"];
        rollToBeSubmitted[index]["selected"] = modifiedList[index]["selected"];
        rollToBeSubmitted[index]["student_img"] =
            modifiedList[index]["student_img"];
      }
    }



    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse(ApiConstants.ROLL_NUMBER_UPDATE));
    request.body = json.encode({
      // "session_id": widget.sessionId,
      // "curriculum_id": widget.curriculumId,
      // "class_id": widget.classId,
      // "batch_id": widget.batchId,
      // "school_id": widget.schoolId,
      // "academic_year": widget.academicYear,
      // "user_id": widget.userId,
      "studentList": rollToBeSubmitted
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    log("${request.body}");
    if (response.statusCode == 200) {
      print("submited");
      setState(() {
        isLoading=false;
      });
    } else {
      setState(() {
        isLoading=false;
      });
      print(response.reasonPhrase);
    }

    log("$rollToBeSubmitted");
  }

  Future<void> update() async {
    studentList?.clear();
    modifiedList.clear();
    reoderedStudentList.clear();
    log("$studentList");
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request =
    http.Request('POST', Uri.parse(ApiConstants.GET_STUDENT_DETAILS_TO_UPDATE));
    request.body = json.encode({
      // "FILE_UPLOAD_URL": "https://teamsqa4000.educore.guru",
      "FILE_UPLOAD_URL": ApiConstants.FILE_SERVER,
      "academic_year": academicyear,
      "batch_id": widget.batchId,
      "class_id": widget.classId,
      "curriculum_id": widget.curriculumId,
      "school_id": widget.schoolId,
      "session_id": widget.sessionId,
      "user_id": widget.userId
    });
    request.headers.addAll(headers);

    log("${request.body}");
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());

      var responseJson = await response.stream.bytesToString();

      setState(() {
        studentList = json.decode(responseJson);
        reoderedStudentList.add(studentList!["data"]["details"]["response"]["students"]);
      });

      //log(">>>>>>>>>>>>>>>>>${reoderedStudentList[0][10]["parent_doc"]["mother_obj"]}");

      //modifiedList = reoderedStudentList[0];


      log("$reoderedStudentList");

      for (int i = 0; i < reoderedStudentList[0].length; i++) {
        modifiedList.add({
          "_id": reoderedStudentList[0][i]["_id"],
          "userId": reoderedStudentList[0][i]["user_id"],
          "roll_number": reoderedStudentList[0][i]["roll_number"] == null
              ? "${i + 1}"
              : reoderedStudentList[0][i]["roll_number"],
          "user_name": reoderedStudentList[0][i]["name"],
          "name": reoderedStudentList[0][i]["name"],
          "admission_number": reoderedStudentList[0][i]["admission_number"],
          "gender": reoderedStudentList[0][i]["gender"],
          "birth_date": reoderedStudentList[0][i]["birth_date"],
          "display_name": reoderedStudentList[0][i]["display_name"],
          "selected": true,
          "session_id": widget.sessionId,
          "curriculum_id": widget.curriculumId,
          "class_id": widget.classId,
          "batch_id": widget.batchId,
          "school_id": widget.schoolId,
          "image": reoderedStudentList[0][i]["student_img"],
          "teacher_id": widget.userId,
          "parent_id": reoderedStudentList[0][i]["parent_id"],
          "father_name": reoderedStudentList[0][i]["parent_doc"] == null ? "" : reoderedStudentList[0][i]["parent_doc"]["name"],
          "father_phone": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["phone"],
          "father_email": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["email"],
          "address_one": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["addrLine1"],
          "address_two": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["addrLine2"],
          "address_three": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["addrLine3"],
          "zip_code": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["pincode"],
          "academic_year": academicyear,
          "bcrypt": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["services"]["password"]["bcrypt"],
          "city": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["city"],
          "country": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["country"],
          "password_tracking": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["password_tracking"],
          "updated_by": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["updated_by"],
          "parent_doc_id": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["_id"],
          "educore_id": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["educore_id"],
          "parent_role_id": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["role_id"],
          "blood_group": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["blood_group"],
          "mother_name": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"] == null ? "" : reoderedStudentList[0][i]["parent_doc"]["mother_obj"]["mother_name"],
          "mother_phone": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"]["mother_mobile"],
          "mother_email": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"]["mother_email"],
        });
      }

      for (int index = 0; index < modifiedList.length; index++) {
        modifiedList
            .sort((a, b) => a["roll_number"].compareTo(b["roll_number"]));
      }
      setState(() {
        isLoading=false;
      });
      log("$modifiedList");
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    getNewStudentDetails();
    getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.BACKGROUND,
      body: LoadingOverlay(
        isLoading: isLoading,
        opacity: 0.6,
        color: Colors.white,
        progressIndicator: CircularProgressIndicator(color: ColorUtils.RED,),
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
                      onTap: () => NavigationUtils.goBack(context),
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
                                widget.name.toString(),
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
                            image: NetworkImage(widget.image == "" ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg" : ApiConstants.IMAGE_BASE_URL +"${widget.image}"),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(widget.ClassAndBatch),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: studentList == null
                                ? Text("")
                                : Text(
                                    "Total Students: ${modifiedList.length}",
                                    style: TextStyle(
                                        color: ColorUtils.RED,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.white, elevation: 0),
                              onPressed: () {
                              setState(() {
                                isLoading=true;
                              });
                              update();
                              }, child: Icon(Icons.refresh, color: ColorUtils.SEARCH_TEXT_COLOR,)
                          )
                        ],
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(left: 10.w, right: 10.w),
                      //   child: TextFormField(
                      //     controller: _searchController,
                      //     onChanged: (value) {
                      //       setState(() {});
                      //     },
                      //     validator: (val) =>
                      //         val!.isEmpty ? 'Enter the Topic' : null,
                      //     cursorColor: Colors.grey,
                      //     keyboardType: TextInputType.text,
                      //     decoration: const InputDecoration(
                      //         hintStyle: TextStyle(color: Colors.grey),
                      //         hintText: "Search Here",
                      //         prefixIcon: Icon(
                      //           Icons.search,
                      //           color: ColorUtils.SEARCH_TEXT_COLOR,
                      //         ),
                      //         // suffixIcon: GestureDetector(
                      //         //   onTap: () => onListen(),
                      //         //   child: AvatarGlow(
                      //         //     animate: _isListening,
                      //         //     glowColor: Colors.blue,
                      //         //     endRadius: 20.0,
                      //         //     duration: Duration(milliseconds: 2000),
                      //         //     repeat: true,
                      //         //     showTwoGlows: true,
                      //         //     repeatPauseDuration:
                      //         //     Duration(milliseconds: 100),
                      //         //     child: Icon(
                      //         //       _isListening == false
                      //         //           ? Icons.keyboard_voice_outlined
                      //         //           : Icons.keyboard_voice_sharp,
                      //         //       color: ColorUtils.SEARCH_TEXT_COLOR,
                      //         //     ),
                      //         //   ),
                      //         // ),
                      //         contentPadding: EdgeInsets.symmetric(
                      //             vertical: 10.0, horizontal: 20.0),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.all(
                      //             Radius.circular(2.0),
                      //           ),
                      //         ),
                      //         enabledBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //               color: Color.fromRGBO(230, 236, 254, 8),
                      //               width: 1.0),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10)),
                      //         ),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //               color: Color.fromRGBO(230, 236, 254, 8),
                      //               width: 1.0),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(10.0)),
                      //         ),
                      //         fillColor: Color.fromRGBO(230, 236, 254, 8),
                      //         filled: true),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10.h,
                      ),
                      studentList == null
                          ? Expanded(
                              child: CardListSkeleton(
                                isCircularImage: true,
                                isBottomLinesActive: true,
                                length: 10,
                              ),
                            )
                          : Expanded(
                              child: ReorderableListView.builder(
                              itemCount: modifiedList.length,
                              onReorder: (int oldIndex, int newIndex) {
                                print(oldIndex);
                                print(newIndex);
                                setState(() {
                                  isChanged = true;
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  Object item = modifiedList.removeAt(oldIndex);
                                  modifiedList.insert(newIndex, item);

                                  Future.delayed(const Duration(milliseconds: 50), () {
                                    SubmitStudentRollNumber();
                                  });
                                  log("the ordered list is $modifiedList");
                                });
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  key: ValueKey(index),
                                  onTap: () {
                                    NavigationUtils.goNext(
                                        context,
                                        StudentProfileEditPage(
                                          name: widget.name,
                                          image: widget.image,
                                          officialName: modifiedList[index]
                                              ["name"],
                                          displayName: modifiedList[index]["display_name"],
                                          fatherPhone: modifiedList[index]["father_phone"],
                                          fatherEmail: modifiedList[index]["father_email"],
                                          fatherName: modifiedList[index]["father_name"],
                                          address1: modifiedList[index]["address_one"],
                                          address2: modifiedList[index]["address_two"],
                                          address3: modifiedList[index]["address_three"],
                                          zipCode: modifiedList[index]["zip_code"],
                                          studentImage: modifiedList[index]["image"],
                                          admissionNumber: modifiedList[index]["admission_number"],
                                          session_id: modifiedList[index]["session_id"],
                                          curriculum_id: modifiedList[index]["curriculum_id"],
                                          school_id: modifiedList[index]["school_id"],
                                          accademic_year: modifiedList[index]["academic_year"],
                                          user_id: modifiedList[index]["teacher_id"],
                                          parent_id: modifiedList[index]["parent_id"],
                                          password_bcrypt: modifiedList[index]["bcrypt"],
                                          city: modifiedList[index]["city"],
                                          country: modifiedList[index]["country"],
                                          educore_id: modifiedList[index]["educore_id"],
                                          password_tracking: modifiedList[index]["password_tracking"],
                                          updatedBy: modifiedList[index]["updated_by"],
                                          parentDocId: modifiedList[index]["parent_doc_id"],
                                          parent_role_id: modifiedList[index]["parent_role_id"],
                                          blood_group: modifiedList[index]["blood_group"],
                                          gender: modifiedList[index]["gender"],
                                          class_id: modifiedList[index]["class_id"],
                                          batch_id: modifiedList[index]["batch_id"],
                                          student_id: modifiedList[index]["userId"],
                                          roll_number: modifiedList[index]["roll_number"],
                                          bith_date: modifiedList[index]["birth_date"],
                                          motherName: modifiedList[index]["mother_name"],
                                          motherEmail: modifiedList[index]["mother_email"],
                                          motherPhone: modifiedList[index]["mother_phone"],
                                        ));
                                    print(" the dhdhdhhd ${modifiedList[index]["image"]}");
                                  },
                                  child: Container(
                                    child: Container(
                                        margin: EdgeInsets.only(left: 10.w),
                                        child: Column(
                                          children: [
                                            Theme(
                                              data: ThemeData().copyWith(
                                                  dividerColor:
                                                      Colors.transparent),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 50.w,
                                                    height: 50.h,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF3F7FD),
                                                      border: Border.all(
                                                          color:
                                                              Color(0xFFF3F7FD)),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "${index + 1}",
                                                        style: TextStyle(
                                                            color:
                                                                Color(0xFFA2ACDE),
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          width: 200.w,
                                                          child: Text(
                                                              modifiedList[index]
                                                                  ["name"],style: GoogleFonts.spaceGrotesk(
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                  16.sp,
                                                                  color: ColorUtils
                                                                      .BLACK,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold)))),
                                                      SizedBox(
                                                        height: 6.h,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 20.w,
                                                  ),
                                                  const Icon(
                                                    Icons.drag_indicator,
                                                    color: ColorUtils
                                                        .SEARCH_TEXT_COLOR,
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              indent: 20,
                                              endIndent: 20,
                                              height: 20,
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              },
                            )),
                      SizedBox(
                        height: 120.h,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }



  void refreshStudentDetails() async {
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request =
    http.Request('POST', Uri.parse(ApiConstants.GET_STUDENT_DETAILS_TO_UPDATE));
    request.body = json.encode({
      // "FILE_UPLOAD_URL": "https://teamsqa4000.educore.guru",
      "FILE_UPLOAD_URL": ApiConstants.FILE_SERVER,
      "academic_year": academicyear,
      "batch_id": widget.batchId,
      "class_id": widget.classId,
      "curriculum_id": widget.curriculumId,
      "school_id": widget.schoolId,
      "session_id": widget.sessionId,
      "user_id": widget.userId
    });
    request.headers.addAll(headers);

    log("${request.body}");
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());

      var responseJson = await response.stream.bytesToString();

      setState(() {
        studentList = json.decode(responseJson);
        reoderedStudentList.add(studentList!["data"]["details"]["response"]["students"]);
      });

      //log(">>>>>>>>>>>>>>>>>${reoderedStudentList[0][10]["parent_doc"]["mother_obj"]}");

      //modifiedList = reoderedStudentList[0];


      log("$reoderedStudentList");

      for (int i = 0; i < reoderedStudentList[0].length; i++) {
        modifiedList.add({
          "_id": reoderedStudentList[0][i]["_id"],
          "userId": reoderedStudentList[0][i]["user_id"],
          "roll_number": reoderedStudentList[0][i]["roll_number"] == null
              ? "${i + 1}"
              : reoderedStudentList[0][i]["roll_number"],
          "user_name": reoderedStudentList[0][i]["name"],
          "name": reoderedStudentList[0][i]["name"],
          "admission_number": reoderedStudentList[0][i]["admission_number"],
          "gender": reoderedStudentList[0][i]["gender"],
          "birth_date": reoderedStudentList[0][i]["birth_date"],
          "display_name": reoderedStudentList[0][i]["display_name"],
          "selected": true,
          "session_id": widget.sessionId,
          "curriculum_id": widget.curriculumId,
          "class_id": widget.classId,
          "batch_id": widget.batchId,
          "school_id": widget.schoolId,
          "image": reoderedStudentList[0][i]["student_img"],
          "teacher_id": widget.userId,
          "parent_id": reoderedStudentList[0][i]["parent_id"],
          "father_name": reoderedStudentList[0][i]["parent_doc"] == null ? "" : reoderedStudentList[0][i]["parent_doc"]["name"],
          "father_phone": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["phone"],
          "father_email": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["email"],
          "address_one": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["addrLine1"],
          "address_two": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["addrLine2"],
          "address_three": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["addrLine3"],
          "zip_code": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["pincode"],
          "academic_year": academicyear,
          "bcrypt": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["services"]["password"]["bcrypt"],
          "city": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["city"],
          "country": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["country"],
          "password_tracking": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["password_tracking"],
          "updated_by": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["updated_by"],
          "parent_doc_id": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["_id"],
          "educore_id": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["educore_id"],
          "parent_role_id": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["role_id"],
          "blood_group": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["blood_group"],
          "mother_name": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"] == null ? "" : reoderedStudentList[0][i]["parent_doc"]["mother_obj"]["mother_name"],
          "mother_phone": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"]["mother_mobile"],
          "mother_email": reoderedStudentList[0][i]["parent_doc"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"] == null ? "" :  reoderedStudentList[0][i]["parent_doc"]["mother_obj"]["mother_email"],
        });
      }

      for (int index = 0; index < modifiedList.length; index++) {
        modifiedList
            .sort((a, b) => a["roll_number"].compareTo(b["roll_number"]));
      }

      log("$modifiedList");
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
}

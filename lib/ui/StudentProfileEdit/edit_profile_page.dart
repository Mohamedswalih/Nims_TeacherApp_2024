import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import 'package:http/http.dart' as http;

import '../../Utils/utils.dart';

class StudentProfileEditPage extends StatefulWidget {
  var name;
  var image;
  var officialName;
  var displayName;
  var fatherName;
  var fatherEmail;
  var fatherPhone;
  var address1;
  var address2;
  var address3;
  var zipCode;
  var motherName;
  var motherEmail;
  var motherPhone;
  var studentImage;
  var admissionNumber;
  var session_id;
  var curriculum_id;
  var class_id;
  var batch_id;
  var school_id;
  var accademic_year;
  var user_id;
  var student_id;
  var roll_number;
  var bith_date;
  var parent_id;
  var password_bcrypt;
  var country;
  var city;
  var educore_id;
  var password_tracking;
  var updatedBy;
  var gender;
  var parentDocId;
  var parent_role_id;
  var blood_group;

  StudentProfileEditPage(
      {this.name,
      this.image,
      this.address1,
      this.address2,
      this.address3,
      this.displayName,
      this.fatherEmail,
      this.fatherName,
      this.fatherPhone,
      this.motherEmail,
      this.motherName,
      this.gender,
      this.motherPhone,
      this.officialName,
      this.studentImage,
      this.zipCode,
      this.admissionNumber,
      this.user_id,
      this.school_id,
      this.accademic_year,
      this.batch_id,
      this.bith_date,
      this.city,
      this.class_id,
      this.country,
      this.curriculum_id,
      this.educore_id,
      this.parent_id,
      this.password_bcrypt,
      this.password_tracking,
      this.roll_number,
      this.session_id,
      this.student_id,
      this.updatedBy,
      this.parentDocId,
      this.parent_role_id,
      this.blood_group});

  @override
  _StudentProfileEditPageState createState() => _StudentProfileEditPageState();
}

class _StudentProfileEditPageState extends State<StudentProfileEditPage> {
  final picker = ImagePicker();
  var image;
  var value;
  File? imageFile;
  String base64Image = "";
  bool isUpdating = false;
  var profileImage;

  bool _isDisplayname = false;
  bool _isfathername = false;
  bool _isFatherEmail = false;
  bool _isFatherPhone = false;
  bool _adressOne = false;
  bool _adresstwo = false;
  bool _adressthree = false;
  bool _zipcode = false;
  bool _motherName = false;
  bool _motherEmail = false;
  bool _motherPhone = false;

  var _displayNameController = TextEditingController();
  var _fatherNameController = TextEditingController();
  var _fatherEmailController = TextEditingController();
  var _fatherPhoneController = TextEditingController();
  var _addressOnecontroller = TextEditingController();
  var _addressTwoController = TextEditingController();
  var _addressThreeController = TextEditingController();
  var _zipCodeController = TextEditingController();
  var _motherNameController = TextEditingController();
  var _motherEmailcontroller = TextEditingController();
  var _motherPhoneController = TextEditingController();

  @override
  void initState() {
    print(widget.studentImage.replaceAll('"', ''));
    profileImage = widget.studentImage.replaceAll('"', '');
    super.initState();
    widget.displayName == null
        ? null
        : _displayNameController.text = "${widget.displayName}";
    widget.fatherName == null
        ? null
        : _fatherNameController.text = "${widget.fatherName}";
    widget.fatherEmail == null
        ? null
        : _fatherEmailController.text = "${widget.fatherEmail}";
    widget.fatherPhone == null
        ? null
        : _fatherPhoneController.text = "${widget.fatherPhone}";
    widget.address1 == null
        ? null
        : _addressOnecontroller.text = "${widget.address1}";
    widget.address2 == null
        ? null
        : _addressTwoController.text = "${widget.address2}";
    widget.address3 == null
        ? null
        : _addressThreeController.text = "${widget.address3}";
    widget.zipCode == null
        ? null
        : _zipCodeController.text = "${widget.zipCode}";
    widget.motherName == null
        ? null
        : _motherNameController.text = "${widget.motherName}";
    widget.motherEmail == null
        ? null
        : _motherEmailcontroller.text = "${widget.motherEmail}";
    widget.motherPhone == null
        ? null
        : _motherPhoneController.text = "${widget.motherPhone}";
  }

  submitDataToDocme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? school_token = preferences.getString("school_token");
    var headers = {
      'API-Key': '525-777-777',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse(ApiConstants.DOCME_URL));
    if(imageFile == null){
      request.body = json.encode({
        "action": "updateStudentProfileData",
        "token": school_token,
        "admn_no": widget.admissionNumber,
        "father_name": _fatherNameController.text.toString(),
        "father_addr1_c": _addressOnecontroller.text.toString(),
        "father_addr2_c": _addressTwoController.text.toString(),
        "father_addr3_c": _addressThreeController.text.toString(),
        "father_zip_c": _zipCodeController.text.toString(),
        "father_email_c": _fatherEmailController.text.toString(),
        "father_mob_c": _fatherPhoneController.text.toString(),
        //"father_phone_c": _fatherPhoneController.text.toString(),
        "mother_name": _motherNameController.text.toString(),
        "mother_email_c": _motherEmailcontroller.text.toString(),
        "mother_mob_c": _motherPhoneController.text.toString(),
        //"mother_phone_c": _motherPhoneController.text.toString(),
        //"student_img": "data:image/jpeg;base64,$base64Image"
      });
    }else{
      request.body = json.encode({
        "action": "updateStudentProfileData",
        "token": school_token,
        "admn_no": widget.admissionNumber,
        "father_name": _fatherNameController.text.toString(),
        "father_addr1_c": _addressOnecontroller.text.toString(),
        "father_addr2_c": _addressTwoController.text.toString(),
        "father_addr3_c": _addressThreeController.text.toString(),
        "father_zip_c": _zipCodeController.text.toString(),
        "father_email_c": _fatherEmailController.text.toString(),
        "father_mob_c": _fatherPhoneController.text.toString(),
        //"father_phone_c": _fatherPhoneController.text.toString(),
        "mother_name": _motherNameController.text.toString(),
        "mother_email_c": _motherEmailcontroller.text.toString(),
        "mother_mob_c": _motherPhoneController.text.toString(),
        //"mother_phone_c": _motherPhoneController.text.toString(),
        "student_img": "data:image/jpeg;base64,$base64Image"
      });
    }
    request.headers.addAll(headers);

    log("${request.body}");
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var jsonReesponse = await response.stream.bytesToString();
      var responseData = json.decode(jsonReesponse);
      print(responseData);
      if(responseData["data_status"] == 0){
        setState(() {
          isUpdating=false;
        });
        print(responseData["message"]);
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Failed'),
              content: Text(responseData["message"]),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Try Again'),
                  onPressed: () {
                    NavigationUtils.goBack(context);
                  },
                ),
              ],
            );
          },
        );
      }else{
        if(imageFile == null){
          print("dddddddddddddddddddddddddddd");
          updateStudentListToEducore();
        }else{
          uploadImage();
        }
      }
    } else {
      print(response.reasonPhrase);
      _submitFailed();
      setState(() {
        isUpdating = false;
      });
    }
  }

  uploadImage() async {
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'image/jpeg'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiConstants.FILE_SERVER));
    request.headers.addAll(headers);
    request.fields.addAll({'userPath': "${widget.student_id}/profile/"});
    var process = await http.MultipartFile.fromBytes(
        'file', File(image.path).readAsBytesSync(),
        filename: image.path.split("/").last,
        contentType: MediaType('image', 'jpg'));
    request.files.add(process);
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      value = await response.stream.transform(utf8.decoder).first;
      updateStudentListToEducore();
      print(value);
    }
  }

  Future<void> _handleClickMe() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text('The form has been submitted successfully'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Done'),
              onPressed: () {
                NavigationUtils.goBack(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitFailed() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Failed'),
          content: Text('The form has not been submitted, Please try again'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Try Again'),
              onPressed: () {
                NavigationUtils.goBack(context);
              },
            ),
          ],
        );
      },
    );
  }

  updateStudentListToEducore() async {
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse(ApiConstants.STUDENT_DETAIL_UPLOAD));
    if(imageFile == null){
      print("jccjcjjcjcjcjcjjcj");
      request.body = json.encode({
        "_isSingle": true,
        "academic_year": widget.accademic_year,
        "batch_id": widget.batch_id,
        "class_id": widget.class_id,
        "curriculum_id": widget.curriculum_id,
        "FILE_UPLOAD_URL": "https://teamsqa4000.educore.guru",
        "parent_update": true,
        "school_id": widget.school_id,
        "session_id": widget.session_id,
        "students": [
          {
            "_id": widget.student_id,
            "admission_number": widget.admissionNumber,
            "birth_date": widget.bith_date,
            "db_parent_doc": {
              "_id": widget.parent_id,
              "addrLine1": "${_addressOnecontroller.text.toString()}",
              "addrLine2": "${_addressTwoController.text.toString()}",
              "addrLine3": "${_addressThreeController.text.toString()}",
              "blood_group": widget.blood_group,
              "city": widget.city,
              "country": widget.country,
              "createdAt": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
              "default_role": widget.parent_role_id,
              "educore_id": widget.educore_id,
              "email": "${_fatherEmailController.text.toString()}",
              "emails": [
                {"address": "${_fatherEmailController.text.toString()}", "verified": true}
              ],
              "feeDue_status": "updated",
              "mother_obj": {
                "mother_email": "${_motherEmailcontroller.text.toString()}",
                "mother_mobile": "${_motherPhoneController.text.toString()}",
                "mother_name": "${_motherNameController.text.toString()}"
              },
              "name": "${_fatherNameController.text.toString()}",
              "password_tracking": widget.password_tracking,
              "phone": "${_fatherPhoneController.text.toString()}",
              "pincode": "${_zipCodeController.text.toString()}",
              "role_id": widget.parent_role_id,
              "role_ids": ["${widget.parent_role_id}"],
              "school_id": widget.school_id,
              "services": {
                "password": {"bcrypt": widget.password_bcrypt}
              },
              "set_privacy": {
                "addrLine1": false,
                "addrLine2": false,
                "blood_group": true,
                "city": false,
                "country": true,
                "phone": false,
                "pincode": false,
                "username": true
              },
              "username": "${_fatherEmailController.text.toString()}"
            },
            "display_name": "${_displayNameController.text.toString()}",
            "expanded": true,
            "gender": widget.gender,
            "image": {
              "original": ""
            },
            "name": widget.officialName,
            "parent_doc": {
              "_id": widget.parent_id,
              "addrLine1": "${_addressOnecontroller.text.toString()}",
              "addrLine2": "${_addressTwoController.text.toString()}",
              "addrLine3": "${_addressThreeController.text.toString()}",
              "blood_group": widget.blood_group,
              "city": widget.city,
              "country": widget.country,
              "createdAt": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
              "default_role": widget.parent_role_id,
              "educore_id": widget.educore_id,
              "email": "${_fatherEmailController.text.toString()}",
              "emails": [
                {"address": "${_fatherEmailController.text.toString()}", "verified": true}
              ],
              "feeDue_status": "updated",
              "mother_obj": {
                "mother_email": "${_motherEmailcontroller.text.toString()}",
                "mother_mobile": "${_motherPhoneController.text.toString()}",
                "mother_name": "${_motherNameController.text.toString()}"
              },
              "name": "${_fatherNameController.text.toString()}",
              "password_tracking": widget.password_tracking,
              "phone": "${_fatherPhoneController.text.toString()}",
              "pincode": "${_zipCodeController.text.toString()}",
              "role_id": widget.parent_role_id,
              "role_ids": ["${widget.parent_role_id}"],
              "school_id": widget.school_id,
              "services": {
                "password": {"bcrypt": widget.password_bcrypt}
              },
              "set_privacy": {
                "addrLine1": false,
                "addrLine2": false,
                "blood_group": true,
                "city": false,
                "country": true,
                "phone": false,
                "pincode": false,
                "username": true
              },
              "username": "${_fatherEmailController}"
            },
            "parent_id": widget.parent_id,
            "roll_number": widget.roll_number,
            "sex": widget.gender,
            "student_img": "${widget.studentImage}",
            "is_new_img": false,
          }
        ],
        "user_id": widget.user_id
      });
    }else{
      request.body = json.encode({
        "_isSingle": true,
        "academic_year": widget.accademic_year,
        "batch_id": widget.batch_id,
        "class_id": widget.class_id,
        "curriculum_id": widget.curriculum_id,
        "FILE_UPLOAD_URL": "https://teamsqa4000.educore.guru",
        "parent_update": true,
        "school_id": widget.school_id,
        "session_id": widget.session_id,
        "students": [
          {
            "_id": widget.student_id,
            "admission_number": widget.admissionNumber,
            "birth_date": widget.bith_date,
            "db_parent_doc": {
              "_id": widget.parent_id,
              "addrLine1": "${_addressOnecontroller.text.toString()}",
              "addrLine2": "${_addressTwoController.text.toString()}",
              "addrLine3": "${_addressThreeController.text.toString()}",
              "blood_group": widget.blood_group,
              "city": widget.city,
              "country": widget.country,
              "createdAt": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
              "default_role": widget.parent_role_id,
              "educore_id": widget.educore_id,
              "email": "${_fatherEmailController.text.toString()}",
              "emails": [
                {"address": "${_fatherEmailController.text.toString()}", "verified": true}
              ],
              "feeDue_status": "updated",
              "mother_obj": {
                "mother_email": "${_motherEmailcontroller.text.toString()}",
                "mother_mobile": "${_motherPhoneController.text.toString()}",
                "mother_name": "${_motherNameController.text.toString()}"
              },
              "name": "${_fatherNameController.text.toString()}",
              "password_tracking": widget.password_tracking,
              "phone": "${_fatherPhoneController.text.toString()}",
              "pincode": "${_zipCodeController.text.toString()}",
              "role_id": widget.parent_role_id,
              "role_ids": ["${widget.parent_role_id}"],
              "school_id": widget.school_id,
              "services": {
                "password": {"bcrypt": widget.password_bcrypt}
              },
              "set_privacy": {
                "addrLine1": false,
                "addrLine2": false,
                "blood_group": true,
                "city": false,
                "country": true,
                "phone": false,
                "pincode": false,
                "username": true
              },
              "username": "${_fatherEmailController.text.toString()}"
            },
            "display_name": "${_displayNameController.text.toString()}",
            "expanded": true,
            "gender": widget.gender,
            "image": {
              "original": "$value"
            },
            "name": widget.officialName,
            "parent_doc": {
              "_id": widget.parent_id,
              "addrLine1": "${_addressOnecontroller.text.toString()}",
              "addrLine2": "${_addressTwoController.text.toString()}",
              "addrLine3": "${_addressThreeController.text.toString()}",
              "blood_group": widget.blood_group,
              "city": widget.city,
              "country": widget.country,
              "createdAt": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
              "default_role": widget.parent_role_id,
              "educore_id": widget.educore_id,
              "email": "${_fatherEmailController.text.toString()}",
              "emails": [
                {"address": "${_fatherEmailController.text.toString()}", "verified": true}
              ],
              "feeDue_status": "updated",
              "mother_obj": {
                "mother_email": "${_motherEmailcontroller.text.toString()}",
                "mother_mobile": "${_motherPhoneController.text.toString()}",
                "mother_name": "${_motherNameController.text.toString()}"
              },
              "name": "${_fatherNameController.text.toString()}",
              "password_tracking": widget.password_tracking,
              "phone": "${_fatherPhoneController.text.toString()}",
              "pincode": "${_zipCodeController.text.toString()}",
              "role_id": widget.parent_role_id,
              "role_ids": ["${widget.parent_role_id}"],
              "school_id": widget.school_id,
              "services": {
                "password": {"bcrypt": widget.password_bcrypt}
              },
              "set_privacy": {
                "addrLine1": false,
                "addrLine2": false,
                "blood_group": true,
                "city": false,
                "country": true,
                "phone": false,
                "pincode": false,
                "username": true
              },
              "username": "${_fatherEmailController}"
            },
            "parent_id": widget.parent_id,
            "roll_number": widget.roll_number,
            "sex": widget.gender,
            "student_img": "https://teamsqa4000.educore.guru$value",
            "is_new_img": true,
            "new_img": "$value"
          }
        ],
        "user_id": widget.user_id
      });
    }
    request.headers.addAll(headers);

    log("${request.body}");
    http.StreamedResponse response = await request.send();

    print(response.statusCode);
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      _handleClickMe();
      setState(() {
        isUpdating = false;
      });
    } else {
      print(response.reasonPhrase);
      _submitFailed();
      setState(() {
        isUpdating = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Column(
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
                            child: Image.asset("assets/images/goback.png")),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "Manage",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontSize: 17.sp,
                                    color: Colors.white),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 190.w,
                                  height: 40.h,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      "Student Profile",
                                      style: TextStyle(
                                          fontFamily: "WorkSans",
                                          fontSize: 20.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 60.w,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40.w,
                      ),
                      // GestureDetector(
                      //   onTap: () => NavigationUtils.goNext(
                      //       context,
                      //       NotificationPage(
                      //         name: widget.name,
                      //         image: widget.image,
                      //       )),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Badge(
                      //         position: BadgePosition(end: -7, bottom: 12),
                      //         badgeContent: count == null
                      //             ? Text("")
                      //             : Text(
                      //                 count.toString(),
                      //                 style: TextStyle(color: Colors.white),
                      //               ),
                      //         toAnimate: true,
                      //         child:
                      //             SvgPicture.asset("assets/images/bell.svg")),
                      //   ),
                      // ),
                      // Card(
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(50.r)),
                      //       side: const BorderSide(
                      //           width: 2, color: Colors.white)),
                      //   margin: EdgeInsets.only(top: 5.h),
                      //   child: Container(
                      //     width: 49.w,
                      //     height: 50.h,
                      //     decoration: BoxDecoration(
                      //       border: Border.all(color: Color(0xFFD6E4FA)),
                      //       shape: BoxShape.circle,
                      //       image: DecorationImage(
                      //           image: NetworkImage(
                      //               ApiConstants.IMAGE_BASE_URL +
                      //                   "${widget.image}"),
                      //           fit: BoxFit.fill),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border.all(color: Color(0xFFCAD3FF)),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height / 1.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFCAD3FF)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            // physics: NeverScrollableScrollPhysics(),
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    children: [
                                      imageFile == null
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  top: 30.h, bottom: 10.h),
                                              width: 100.w,
                                              height: 100.h,
                                              decoration: BoxDecoration(
                                                boxShadow: const <BoxShadow>[
                                                  BoxShadow(
                                                      blurStyle:
                                                          BlurStyle.outer,
                                                      color: Color(0xFF6D7AB1),
                                                      blurRadius: 5.0,
                                                      offset: Offset(0.0, 0.75))
                                                ],
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 5.w),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: NetworkImage(widget.studentImage == "" || widget.studentImage == null
                                                        ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profileImage.jpg"
                                                        : profileImage),
                                                    fit: BoxFit.fill),
                                              ),
                                            )
                                          : Container(
                                              margin: EdgeInsets.only(
                                                  top: 30.h, bottom: 10.h),
                                              width: 100.w,
                                              height: 100.h,
                                              decoration: BoxDecoration(
                                                boxShadow: const <BoxShadow>[
                                                  BoxShadow(
                                                      blurStyle:
                                                          BlurStyle.outer,
                                                      color: Color(0xFF6D7AB1),
                                                      blurRadius: 5.0,
                                                      offset: Offset(0.0, 0.75))
                                                ],
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 5.w),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image:
                                                        FileImage(imageFile!),
                                                    fit: BoxFit.fill),
                                              ),
                                            ),
                                      Positioned(
                                          bottom: 0,
                                          right: -20,
                                          child: RawMaterialButton(
                                            onPressed: () async {
                                              final pickedFile =
                                                  await picker.pickImage(
                                                source: ImageSource.gallery,
                                                imageQuality: 100,
                                              );
                                              setState(() {
                                                image = pickedFile;
                                                imageFile =
                                                    File(pickedFile!.path);
                                              });
                                              List<int> imageBytes =
                                                  await imageFile!
                                                      .readAsBytesSync();
                                              base64Image =
                                                  base64Encode(imageBytes);
                                            },
                                            elevation: 1.0,
                                            fillColor: Colors.white,
                                            child: const Icon(
                                              Icons.edit_outlined,
                                              color: Colors.blue,
                                            ),
                                            padding: const EdgeInsets.all(4.0),
                                            shape: const CircleBorder(),
                                          ))
                                    ],
                                  ),
                                  ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    // scrollDirection: Axis.vertical,
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Official Name",
                                            style: GoogleFonts.nunitoSans(
                                                fontSize: 14.sp,
                                                color:
                                                    ColorUtils.HEADING_COLOR),
                                          )),
                                      Container(
                                          margin: EdgeInsets.only(left: 8.w),
                                          child: Text(
                                            widget.officialName,
                                            style: GoogleFonts.nunitoSans(
                                                fontSize: 20.sp,
                                                color: ColorUtils.VALUE_COLOR,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      const Divider(
                                        color: ColorUtils.VERTICAL_COLOR,
                                        endIndent: 10,
                                        indent: 10,
                                      ),
                                      Container(
                                          margin: const EdgeInsets.all(8.0),
                                          child: _isDisplayname
                                              ? Text(
                                                  "Display Name*",
                                                  style: GoogleFonts.nunitoSans(
                                                      fontSize: 14.sp,
                                                      color:
                                                          ColorUtils.RED_DARK),
                                                )
                                              : Text(
                                                  "Display Name*",
                                                  style: GoogleFonts.nunitoSans(
                                                      fontSize: 14.sp,
                                                      color: ColorUtils
                                                          .HEADING_COLOR),
                                                )),
                                      TextFormField(
                                        controller: _displayNameController,
                                        cursorColor: ColorUtils.HEADING_COLOR,
                                        keyboardType: TextInputType.name,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(left: 8),
                                            hintText: "Enter Display Name"),
                                      ),
                                      const Divider(
                                        color: ColorUtils.VERTICAL_COLOR,
                                        endIndent: 10,
                                        indent: 10,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(13.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset("assets/images/man.png"),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                "Father's information",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 20.sp, color: ColorUtils.HEADER),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                         // height: MediaQuery.of(context).size.height / 0.87,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFCAD3FF)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //physics: NeverScrollableScrollPhysics(),
                            children: [
                              Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: _isfathername
                                      ? Text(
                                          "Father Name*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.RED_DARK),
                                        )
                                      : Text(
                                          "Father Name*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.HEADING_COLOR),
                                        )),
                              TextFormField(
                                controller: _fatherNameController,
                                cursorColor: ColorUtils.HEADING_COLOR,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: "Enter Father Name"),
                              ),
                              const Divider(
                                color: ColorUtils.VERTICAL_COLOR,
                                endIndent: 10,
                                indent: 10,
                              ),
                              Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: _isFatherEmail
                                      ? Text(
                                          "Email*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.RED_DARK),
                                        )
                                      : Text(
                                          "Email*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.HEADING_COLOR),
                                        )),
                              TextFormField(
                                controller: _fatherEmailController,
                                cursorColor: ColorUtils.HEADING_COLOR,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: "Enter Email Address"),
                              ),
                              const Divider(
                                color: ColorUtils.VERTICAL_COLOR,
                                endIndent: 10,
                                indent: 10,
                              ),
                              Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: _isFatherPhone
                                      ? Text(
                                          "Phone*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.RED_DARK),
                                        )
                                      : Text(
                                          "Phone*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.HEADING_COLOR),
                                        )),
                              TextFormField(
                                controller: _fatherPhoneController,
                                cursorColor: ColorUtils.HEADING_COLOR,
                                keyboardType: TextInputType.number,
                                maxLength: 12,
                                decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: "Enter Phone Number"),
                              ),
                              const Divider(
                                color: ColorUtils.VERTICAL_COLOR,
                                endIndent: 10,
                                indent: 10,
                              ),
                              Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: _adressOne
                                      ? Text(
                                          "Address 1*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.RED_DARK),
                                        )
                                      : Text(
                                          "Address 1*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.HEADING_COLOR),
                                        )),
                              TextFormField(
                                controller: _addressOnecontroller,
                                cursorColor: ColorUtils.HEADING_COLOR,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: "Enter Address 1"),
                              ),
                              const Divider(
                                color: ColorUtils.VERTICAL_COLOR,
                                endIndent: 10,
                                indent: 10,
                              ),
                              Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: _adresstwo
                                      ? Text(
                                          "Address 2*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.RED_DARK),
                                        )
                                      : Text(
                                          "Address 2*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.HEADING_COLOR),
                                        )),
                              TextFormField(
                                controller: _addressTwoController,
                                cursorColor: ColorUtils.HEADING_COLOR,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: "Enter Address 2"),
                              ),
                              const Divider(
                                color: ColorUtils.VERTICAL_COLOR,
                                endIndent: 10,
                                indent: 10,
                              ),
                              Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: _adressthree
                                      ? Text(
                                          "Address 3 (Optional)",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.RED_DARK),
                                        )
                                      : Text(
                                          "Address 3 (Optional)",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.HEADING_COLOR),
                                        )),
                              TextFormField(
                                controller: _addressThreeController,
                                cursorColor: ColorUtils.HEADING_COLOR,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: "Enter Address 3"),
                              ),
                              const Divider(
                                color: ColorUtils.VERTICAL_COLOR,
                                endIndent: 10,
                                indent: 10,
                              ),
                              Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: _zipcode
                                      ? Text(
                                          "Zip Code*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.RED_DARK),
                                        )
                                      : Text(
                                          "Zip Code*",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.HEADING_COLOR),
                                        )),
                              TextFormField(
                                controller: _zipCodeController,
                                cursorColor: ColorUtils.HEADING_COLOR,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true),
                                maxLength: 6,
                                decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: "Enter Zip code"),
                              ),
                              const Divider(
                                color: ColorUtils.VERTICAL_COLOR,
                                endIndent: 10,
                                indent: 10,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(13.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset("assets/images/girl.png"),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                "Mother Information",
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 20.sp, color: ColorUtils.HEADER),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height /2.15,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFCAD3FF)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            //physics: NeverScrollableScrollPhysics(),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: _motherName
                                      ? Text(
                                          "Mother Name",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.RED_DARK),
                                        )
                                      : Text(
                                          "Mother Name",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.HEADING_COLOR),
                                        )),
                              TextFormField(
                                controller: _motherNameController,
                                cursorColor: ColorUtils.HEADING_COLOR,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: "Enter Mother Name"),
                              ),
                              const Divider(
                                color: ColorUtils.VERTICAL_COLOR,
                                endIndent: 10,
                                indent: 10,
                              ),
                              Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: _motherEmail
                                      ? Text(
                                          "Email",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.RED_DARK),
                                        )
                                      : Text(
                                          "Email",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.HEADING_COLOR),
                                        )),
                              TextFormField(
                                controller: _motherEmailcontroller,
                                cursorColor: ColorUtils.HEADING_COLOR,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: "Enter Email Address"),
                              ),
                              const Divider(
                                color: ColorUtils.VERTICAL_COLOR,
                                endIndent: 10,
                                indent: 10,
                              ),
                              Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: _motherPhone
                                      ? Text(
                                          "Phone",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.RED_DARK),
                                        )
                                      : Text(
                                          "Phone",
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 14.sp,
                                              color: ColorUtils.HEADING_COLOR),
                                        )),
                              TextFormField(
                                controller: _motherPhoneController,
                                cursorColor: ColorUtils.HEADING_COLOR,
                                keyboardType: TextInputType.number,
                                maxLength: 12,
                                decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 8),
                                    hintText: "Enter Phone Number"),
                              ),
                              const Divider(
                                color: ColorUtils.VERTICAL_COLOR,
                                endIndent: 10,
                                indent: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        isUpdating
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: ColorUtils.RED,
                                ),
                              )
                            : Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (_displayNameController.text.toString().isNotEmpty &&
                                        _fatherEmailController.text
                                            .toString()
                                            .isNotEmpty &&
                                        _fatherEmailController.text
                                            .toString()
                                            .isNotEmpty &&
                                        _fatherPhoneController.text
                                            .toString()
                                            .isNotEmpty &&
                                        _addressOnecontroller.text
                                            .toString()
                                            .isNotEmpty &&
                                        _addressTwoController.text
                                            .toString()
                                            .isNotEmpty &&
                                        _zipCodeController.text
                                            .toString()
                                            .isNotEmpty) {
                                      if (RegExp(r'^[A-Za-z .]+$').hasMatch(
                                          _displayNameController.text
                                              .toString())) {
                                        if (RegExp(r'^[A-Za-z .]+$').hasMatch(
                                            _fatherNameController.text
                                                .toString())) {
                                          if (RegExp(r'^[a-z0-9@._-]+$').hasMatch(
                                                  _fatherEmailController.text
                                                      .toString().trim()) &&
                                              _fatherEmailController.text
                                                  .toString()
                                                  .contains("@")) {
                                            if (RegExp(r'^[0-9]+$').hasMatch(
                                                    _fatherPhoneController.text
                                                        .toString()) &&
                                                _fatherPhoneController.text
                                                        .toString()
                                                        .length >=
                                                    8) {
                                              if (RegExp(r'^[a-zA-Z. 0-9/,-]+$')
                                                  .hasMatch(
                                                      _addressOnecontroller.text
                                                          .toString())) {
                                                if (RegExp(r'^[a-zA-Z. 0-9/,-]+$')
                                                    .hasMatch(
                                                        _addressTwoController
                                                            .text
                                                            .toString())) {
                                                  if (RegExp(r'^[0-9]+$')
                                                      .hasMatch(
                                                          _zipCodeController
                                                              .text
                                                              .toString())) {
                                                    if (_addressThreeController
                                                            .text
                                                            .toString()
                                                            .isNotEmpty &&
                                                        _motherNameController
                                                            .text
                                                            .toString()
                                                            .isNotEmpty &&
                                                        _motherEmailcontroller
                                                            .text
                                                            .toString()
                                                            .isNotEmpty &&
                                                        _motherPhoneController
                                                            .text
                                                            .toString()
                                                            .isNotEmpty) {
                                                      if (RegExp(
                                                              r'^[a-zA-Z. 0-9/,-]+$')
                                                          .hasMatch(
                                                              _addressThreeController
                                                                  .text
                                                                  .toString())) {
                                                        if (RegExp(
                                                                r'^[A-Za-z .]+$')
                                                            .hasMatch(
                                                                _motherNameController
                                                                    .text
                                                                    .toString())) {
                                                          if (RegExp(r'^[a-z@._0-9-]+$')
                                                                  .hasMatch(
                                                                      _motherEmailcontroller
                                                                          .text
                                                                          .toString().trim()) &&
                                                              _motherEmailcontroller
                                                                  .text
                                                                  .toString()
                                                                  .contains(
                                                                      "@")) {
                                                            if (RegExp(r'^[0-9]+$')
                                                                    .hasMatch(
                                                                        _motherPhoneController
                                                                            .text
                                                                            .toString()) &&
                                                                _motherPhoneController
                                                                        .text
                                                                        .toString()
                                                                        .length >=
                                                                    8) {
                                                              setState(() {
                                                                isUpdating =
                                                                    true;
                                                                _isDisplayname =
                                                                    false;
                                                                _isfathername =
                                                                    false;
                                                                _isFatherEmail =
                                                                    false;
                                                                _isFatherPhone =
                                                                    false;
                                                                _adressOne =
                                                                    false;
                                                                _adresstwo =
                                                                    false;
                                                                _adressthree =
                                                                    false;
                                                                _zipcode =
                                                                    false;
                                                                _motherName =
                                                                    false;
                                                                _motherEmail =
                                                                    false;
                                                                _motherPhone =
                                                                    false;
                                                              });
                                                              submitDataToDocme();
                                                            } else {
                                                              setState(() {
                                                                _motherPhone =
                                                                    true;
                                                                Utils.showToastError(
                                                                        "Mother Phone Number is invalid")
                                                                    .show(
                                                                        context);
                                                              });
                                                            }
                                                          } else {
                                                            setState(() {
                                                              _motherEmail =
                                                                  true;
                                                              Utils.showToastError(
                                                                      "Mother Email is invalid")
                                                                  .show(
                                                                      context);
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            _motherName = true;
                                                            Utils.showToastError(
                                                                    "Mother Name is invalid")
                                                                .show(context);
                                                          });
                                                        }
                                                      } else {
                                                        setState(() {
                                                          _adressthree = true;
                                                          Utils.showToastError(
                                                                  "Address 3 is invalid")
                                                              .show(context);
                                                        });
                                                      }
                                                    } else {
                                                      setState(() {
                                                        isUpdating = true;
                                                        _isDisplayname = false;
                                                        _isfathername = false;
                                                        _isFatherEmail = false;
                                                        _isFatherPhone = false;
                                                        _adressOne = false;
                                                        _adresstwo = false;
                                                        _adressthree = false;
                                                        _zipcode = false;
                                                        _motherName = false;
                                                        _motherEmail = false;
                                                        _motherPhone = false;
                                                        _zipcode = false;
                                                      });
                                                      submitDataToDocme();
                                                    }
                                                  } else {
                                                    setState(() {
                                                      _zipcode = true;
                                                      Utils.showToastError(
                                                              "Zip Code is invalid")
                                                          .show(context);
                                                    });
                                                  }
                                                } else {
                                                  setState(() {
                                                    _adresstwo = true;
                                                    Utils.showToastError(
                                                            "Address 2 is invalid")
                                                        .show(context);
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  _adressOne = true;
                                                  Utils.showToastError(
                                                          "Address 1 is invalid")
                                                      .show(context);
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                _isFatherPhone = true;
                                                Utils.showToastError(
                                                        "Invalid Phone Number")
                                                    .show(context);
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              _isFatherEmail = true;
                                              Utils.showToastError(
                                                      "Father Email is invalid")
                                                  .show(context);
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            _isfathername = true;
                                            Utils.showToastError(
                                                    "Father Name is invalid")
                                                .show(context);
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          _isDisplayname = true;
                                          Utils.showToastError(
                                                  "Display Name is invalid")
                                              .show(context);
                                        });
                                      }
                                    } else {
                                      Utils.showToastError(
                                              "Please fill the required field marked as *")
                                          .show(context);
                                    }
                                  },
                                  child: SizedBox(
                                    height: 60.h,
                                    width: 327.w,
                                    child: Center(
                                      child: Image.asset(
                                          "assets/images/committedCalls.png"),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 340.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

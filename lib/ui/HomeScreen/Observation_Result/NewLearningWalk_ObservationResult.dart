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

class newLearningwalkResultpage extends StatefulWidget {
  var loginedUserName;
  String? images;
  String? name;
  String? Subject_name = '';
  String? Doneby = '';
  String? Date = '';
  String? Observerid;
  newLearningwalkResultpage({
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
  State<newLearningwalkResultpage> createState() => _newLearningwalkResultpageState();
}

class _newLearningwalkResultpageState extends State<newLearningwalkResultpage> {
  bool isSpinner = false;
  final _formKey = GlobalKey<FormState>();
  var nodata = ' ';

  var focusOfLearningwalkTextController = new TextEditingController();
  var questionstoaskPupilsTextController = new TextEditingController();
  var questionstoaskTeachersTextController = new TextEditingController();
  var whatwentwellTextController = new TextEditingController();
  var evenbetterifTextController = new TextEditingController();
  var remarksTextController = new TextEditingController();
  Map<String, dynamic>? ObservationResult;
  // Map<String, dynamic>? ObservationResultList;
  Map<String, dynamic>? ObservationResultList;
  var focusOfLW;
  var questionPupil;
  var questionTeacher;
  var whatWentWell;
  var evenBetterIf;
  var remarks;
  var class_id;
  var curriculum_id;
  var loId;
  var class_and_batch = '';
  var observer_id;
  var SCHOOL_id;
  var session_id;
  var user_id;
  var username;
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
    getNEWLWObservationResultdata();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    getNotification();
    super.initState();
  }
  final ScrollController _scrollControllerlw = ScrollController();
  final ScrollController _scrollControllerqp = ScrollController();
  final ScrollController _scrollControllerqt = ScrollController();
  final ScrollController _scrollControllerwww = ScrollController();
  final ScrollController _scrollControllerebi = ScrollController();
  final ScrollController _scrollControllerremark = ScrollController();
  Future getNEWLWObservationResultdata() async {
    print('calling__data');
    setState(() {
      isSpinner = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var schoolID = preferences.getString('school_id');
    print("____---shared$schoolID");
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var body = {
      "school_id": schoolID,
      "_id": widget.Observerid
    };
    print('-body__lwObservation$body');
    var request = await http.post(Uri.parse(ApiConstants.NewLearningWalkObservationResultlist),
        headers: headers, body: json.encode(body));
    var response = json.decode(request.body);
    // print('------------api response---------------$response');
    if (request.statusCode == 200) {
      ObservationResult = response;
      print('------------newlwapi response---------------$ObservationResult');
      ObservationResultList = response['data']['details'];
      print(
          '------------newlwapi ObservationResultList---------------$ObservationResultList');

      setState(() {
        focusOfLW = ObservationResult!['data']['details']['lw_focus'] ?? '';
        questionPupil =
            ObservationResult!['data']['details']['qs_to_puple'] ?? '';
        questionTeacher =
            ObservationResult!['data']['details']['qs_to_teacher'] ?? '';
        whatWentWell =
            ObservationResult!['data']['details']['what_went_well'] ?? '';
        evenBetterIf =
            ObservationResult!['data']['details']['even_better_if'] ?? '';
        remarks = ObservationResult!['data']['details']['notes'] ?? '';
        class_and_batch =
            ObservationResult!['data']['details']['class_batch_name'] ?? '';

        print('....focusOfLW$focusOfLW');
        print('....questionPupil$questionPupil');
        print('....questionTeacher$questionTeacher');
        print('....whatWentWell$whatWentWell');
        print('....evenBetterIf$evenBetterIf');
        print('....remarks$remarks');
      });
      focusOfLearningwalkTextController.text = focusOfLW;
      questionstoaskPupilsTextController.text = questionPupil;
      questionstoaskTeachersTextController.text = questionTeacher;
      whatwentwellTextController.text = whatWentWell;
      evenbetterifTextController.text = evenBetterIf;
      remarksTextController.text = remarks;
      setState(() {
        isSpinner = false;
      });
    }else{
      setState(() {
        isSpinner = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong'),backgroundColor: Colors.red,));
    }
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
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15,top: 10),
                        child: Text('Class: $class_and_batch',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600),),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Visibility(
                                    visible: focusOfLearningwalkTextController.text.isNotEmpty && focusOfLearningwalkTextController.text != null,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Focus Of Learning Walk',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: focusOfLearningwalkTextController.text.isNotEmpty && focusOfLearningwalkTextController.text != null,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _scrollControllerlw,
                                      radius: const Radius.circular(10),
                                      interactive: true,
                                      thickness: 2,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: focusOfLearningwalkTextController,
                                        cursorColor: Colors.grey,
                                        decoration: dropTextFieldDecoration,
                                        keyboardType: TextInputType.text,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Visibility(
                                    visible: questionstoaskPupilsTextController.text.isNotEmpty && questionstoaskPupilsTextController.text != null,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Questions To Ask Pupils',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: questionstoaskPupilsTextController.text.isNotEmpty && questionstoaskPupilsTextController.text != null,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _scrollControllerqp,
                                      radius: const Radius.circular(10),
                                      interactive: true,
                                      thickness: 2,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: questionstoaskPupilsTextController,
                                        cursorColor: Colors.grey,
                                        decoration: dropTextFieldDecoration,
                                        keyboardType: TextInputType.text,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Visibility(
                                    visible: questionstoaskTeachersTextController.text.isNotEmpty && questionstoaskTeachersTextController.text != null,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Questions To Ask Teachers',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: questionstoaskTeachersTextController.text.isNotEmpty && questionstoaskTeachersTextController.text != null,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _scrollControllerqt,
                                      radius: const Radius.circular(10),
                                      interactive: true,
                                      thickness: 2,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: questionstoaskTeachersTextController,
                                        cursorColor: Colors.grey,
                                        decoration: dropTextFieldDecoration,
                                        keyboardType: TextInputType.text,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Visibility(
                                    visible: whatwentwellTextController.text.isNotEmpty && whatwentwellTextController.text != null,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'What Went Well',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: whatwentwellTextController.text.isNotEmpty && whatwentwellTextController.text != null,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _scrollControllerwww,
                                      radius: const Radius.circular(10),
                                      interactive: true,
                                      thickness: 2,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: whatwentwellTextController,
                                        cursorColor: Colors.grey,
                                        decoration: dropTextFieldDecoration,
                                        keyboardType: TextInputType.text,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Visibility(
                                    visible: evenbetterifTextController.text.isNotEmpty && evenbetterifTextController.text != null,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Even Better If',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: evenbetterifTextController.text.isNotEmpty && evenbetterifTextController.text != null,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _scrollControllerebi,
                                      radius: const Radius.circular(10),
                                      interactive: true,
                                      thickness: 2,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: evenbetterifTextController,
                                        cursorColor: Colors.grey,
                                        decoration: dropTextFieldDecoration,
                                        keyboardType: TextInputType.text,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Visibility(
                                    visible: remarksTextController.text.isNotEmpty && remarksTextController.text != null,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Remarks',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: remarksTextController.text.isNotEmpty && remarksTextController.text != null,
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      controller: _scrollControllerremark,
                                      radius: const Radius.circular(10),
                                      interactive: true,
                                      thickness: 2,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: remarksTextController,
                                        cursorColor: Colors.grey,
                                        decoration: dropTextFieldDecoration,
                                        keyboardType: TextInputType.text,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ),
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
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:bmteacher/exports.dart';
import 'package:bmteacher/ui/HomeScreen/Observation_Result/Observation_Result.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Database/learningdatabase/learningdbhelper.dart';
import '../../Database/learningdatabase/learningmodel.dart';
import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../DrawerPageHOSLogin/drawer_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../LoginPage/hoslisting.dart';
import '../Rubrics/rubrics.dart';

class learningwalkIndicators extends StatefulWidget {
  var roleUnderLoginTeacher;
  var selectedteacher_Name;
  var selectedteacher_Id;
  var division_name;
  var division_id;
  String? teacherName;
  final String value;
  final String? curriculam_Id;
  String? class_id;
  String? teachername;
  String? class_Name;
  String? batchId;
  String? image;
  final String? schoolid;
  final String? Image;
  final String? subject_id;
  final String? subjectname;
  final String? teacherId;
  final String? HOS_id;
  final String? user_roleId;
  final String? username;
  final String? main_userId;
  final String? academicyear;
  var role_id;
  var loginname;
  var OB_ID;
  var teacherImage;
  final String? userid;
  final String? session_Id;
  final String? classname;
  List<dynamic>? teacherData;
  List<dynamic>? observationList;
  Map<String, dynamic>? learningData;
  learningwalkIndicators(
      {Key? key,
      this.session_Id,
      this.division_id,
      this.division_name,
      this.selectedteacher_Name,
      this.selectedteacher_Id,
      this.subjectname,
      this.username,
      this.role_id,
      this.user_roleId,
      this.loginname,
      this.main_userId,
      this.OB_ID,
      this.teacherImage,
      this.HOS_id,
      this.teacherData,
      required this.value,
      this.academicyear,
      this.schoolid,
      this.classname,
      this.subject_id,
      this.class_id,
      this.curriculam_Id,
      this.image,
      this.teacherId,
      this.batchId,
      this.Image,
      this.userid,
      this.observationList,
      this.teacherName,
      this.teachername,
      this.class_Name,
      this.learningData,
      this.roleUnderLoginTeacher})
      : super(key: key);

  @override
  State<learningwalkIndicators> createState() => _learningwalkIndicatorsState();
}

class _learningwalkIndicatorsState extends State<learningwalkIndicators> {
  String? class_batchName;
  Object? _focusoflwSelected;
  var count;
  String? schoolId;
  String? academicyear;
  String? userId;
  int val = -1;
  bool isSpinner = false;
  bool isChecked = false;
  bool isvalid = false;
  bool ischeck = false;
  Map<String, dynamic>? questionData;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? notificationResult;
  int Count = 0;
  Timer? timer;
  String? rollidpref;
  var rollidprefname;
  var selectedfocusofLW;
  bool showMessage = false;
  bool _isDataEntered = false;
  FocusNode _remarksFocus = FocusNode();

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
    rollidpref = preferences.getString("role_ids");
    rollidprefname = preferences.getStringList("role_name");
    print('rollidpref---->$rollidpref');
    print('rollidpref---->$rollidprefname');
    print('rollidpref---->${rollidprefname}');
    print('rollidpref---->${rollidprefname.runtimeType}');
    print('rollidpref---->${rollidpref.runtimeType}');
    for (var i = 0; i < rollidprefname.length; i++) {
      // print('rollidprefname[i]${rollidprefname[0]}');
      // print('rollidprefname[i]${rollidprefname[1]}');
      print('rollidprefname[i]${rollidprefname[i]}');
    }
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

  void getlist() {
    print(widget.teacherData);
    questionData = widget.learningData;
    // questionData!.forEach((key, value) {
    //   print('questionnnnnnnnn$key - $value');
    //
    // });
    questionData!['list'].forEach((vall) {
      print(vall['values']);
      vall['values'] = null;
    });
    // for (int i = 0;
    // i < questionData!['list'].length;
    // i++)
    // questionData!['list'][i]['values'] = 0;
    // print('${questionData!.forEach((key, value) { })}');
    print('lengthof que------------>${questionData!.length}');
    // print('-------------------------------------${widget.teacherName}');
  }

  getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    schoolId = preferences.getString('school_id');
    academicyear = preferences.getString("academic_year");
    userId = preferences.getString('userID');
    print('school data------------->${schoolId}');
    print('academic data------------->${academicyear}');
  }
  var focusOfLearningwalkTextController = new TextEditingController();
  var questionstoaskPupilsTextController = new TextEditingController();
  var questionstoaskTeachersTextController = new TextEditingController();
  var whatwentwellTextController = new TextEditingController();
  var evenbetterifTextController = new TextEditingController();
  var remarksTextController = new TextEditingController();
  List tempName = [];
  List tempNa = [];
  // Future questionListData() async {
  //   tempName.clear();
  //   setState(() {
  //     ischeck = false;
  //   });
  //   for (int quest = 0; quest < this.questionData!['list'].length; quest++) {
  //     var remarkData;
  //     var db_key;
  //     var alias;
  //     if (questionData!['list'][quest]['values'] == 0) {
  //       remarkData = "NA";
  //       db_key = "NA";
  //       alias = "NA";
  //     } else if (questionData!['list'][quest]['values'] == 3) {
  //       remarkData = "Weak";
  //       db_key = "Weak";
  //       alias = "Weak";
  //     } else if (questionData!['list'][quest]['values'] == 5) {
  //       remarkData = "Acceptable";
  //       db_key = "Acceptable";
  //       alias = "Acceptable";
  //     } else if (questionData!['list'][quest]['values'] == 7) {
  //       remarkData = "Good";
  //       db_key = "Good";
  //       alias = "Good";
  //     } else if (questionData!['list'][quest]['values'] == 9) {
  //       remarkData = "Very Good";
  //       db_key = "Very_good";
  //       alias = "Very good";
  //     } else if (questionData!['list'][quest]['values'] == 10) {
  //       remarkData = "Outstanding";
  //       db_key = "Outstanding";
  //       alias = "Outstanding";
  //     } else {
  //       remarkData = null;
  //       db_key = null;
  //       alias = null;
  //     }
  //     tempName.add({
  //       "name": questionData!['list'][quest]['indicator'],
  //       "remark": remarkData,
  //       "point": questionData!['list'][quest]['values'],
  //       "db_key": db_key,
  //       "alias": alias,
  //     });
  //   }
  // }

  // Future checkingList() async {
  //   print('11111111111${tempName.length}');
  //   print('11111111111${tempName}');
  //   for (int i = 0; i < tempName.length; i++) {
  //     // print('tempName${tempName[i]['remark']}');
  //     print("for loop");
  //     if (tempName[i]['remark'] != null) {
  //       print('--tempnameee---${tempName[i]['remark']}');
  //       setState(() {
  //         ischeck = false;
  //       });
  //       break;
  //     } else {
  //       setState(() {
  //         ischeck = true;
  //       });
  //     }
  //   }
  // }


  List<dynamic>? focusoflwData;
  String? initialfocuslwdata;
  focusoflw() async{
    setState(() {
      isSpinner = true;
    });

    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    var request = http.Request('POST', Uri.parse(ApiConstants.FocusOfLearningWalk));
    request.body =
        json.encode({
          "academic_year": widget.academicyear,
          "user_id": widget.userid,
        });
    request.headers.addAll(headers);

    print('---------focusoflwData--body--${request.body}');

    http.StreamedResponse response = await request.send();

    print('---------focusoflwData--statusCode--${response.statusCode}');
    if (response.statusCode == 200) {
      var resp = await response.stream.bytesToString();
      var decodedresp = json.decode(resp);
      focusoflwData = decodedresp['data']['details'];
      log('---------focusoflwData--${focusoflwData}');
      if (decodedresp['data']['details'].isNotEmpty){
        initialfocuslwdata =decodedresp['data']['details'][0];
        focusOfLearningwalkTextController.text = initialfocuslwdata!;
      }

      print('---------initialfocuslwdata--${initialfocuslwdata}');
      print('---------selectedfocusofLW--${selectedfocusofLW}');

      setState(() {
        isSpinner = false;
      });
    }
  }

  //Submit API
  SubmitRequest() async {
    // tempName.clear();
    // await questionListData();
    // await checkingList();

    // print('ischekkkkkkk----------$ischeck');
    // print('ischekkkkkkk----------${questionData!['list'][quest]['values']}');
      setState(() {
        isSpinner = true;
      });
      var url = Uri.parse(ApiConstants.LearningWalkSUbmit);
      Map<String,dynamic> bdy = {
        "academic_year":academicyear,
        "school_id":schoolId,
        "added_by":widget.userid,
        "added_date":DateTime.now().toLocal().toString(),
        "session_id":widget.session_Id,
        "curriculum_id":widget.curriculam_Id,
        "class_id":widget.class_id,
        "batch_id":widget.division_id,
        "teacher_id":widget.selectedteacher_Id ?? "" ,
        "teacher_name":widget.selectedteacher_Name ?? "",
        "lw_focus":focusOfLearningwalkTextController.text.isEmpty ? "" : focusOfLearningwalkTextController.text,
        "qs_to_puple":questionstoaskPupilsTextController.text.isEmpty ? "" : questionstoaskPupilsTextController.text,
        "qs_to_teacher":questionstoaskTeachersTextController.text.isEmpty ? "" : questionstoaskTeachersTextController.text,
        "what_went_well":whatwentwellTextController.text.isEmpty ? "" : whatwentwellTextController.text,
        "even_better_if":evenbetterifTextController.text.isEmpty ? "" : evenbetterifTextController.text,
        "sender_id":widget.userid,
        "observation_date" : DateTime.now().toLocal().toString(),
        "observer_roles" :"${widget.role_id}",
        "notes" : remarksTextController.text.isEmpty ? "" : remarksTextController.text,
        "app": true,
      };
      log("bbbbbooooddyyyyyyyylwsubmit--$bdy");
      var header = {
        "x-auth-token": "tq355lY3MJyd8Uj2ySzm",
        "Content-Type": "application/json",
      };
      var jsonresponse = await http.post(
        url,
        headers: header,
        body: json.encode(bdy),
      );
      print(jsonresponse);
      print(jsonresponse.statusCode);
      if (jsonresponse.statusCode == 200) {
        setState(() {
          isSpinner = false;
        });
        print('success');
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: AlertDialog(
                    title: Text('Learning Walk Submitted Successfully'),
                    // content: ListView.builder(itemBuilder: (ctx, index) {
                    //   return Text("${questionData!['list'][index]['values']}");
                    // },
                    //   itemCount: questionData!['list'].length,
                    // ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            for (var i = 0; i < rollidprefname.length; i++) {
                              // print('rollidprefname[i]${rollidprefname[0]}');
                              // print('rollidprefname[i]${rollidprefname[1]}');
                              print('rollidprefname[i]${rollidprefname[i]}');
                              if (rollidprefname[i] == 'Principal' ||
                                  rollidprefname[i] == 'Vice Principal' ||
                                  rollidprefname[i] ==
                                      'Academic Co-ordinator') {
                                NavigationUtils.goNextFinishAll(
                                    context,
                                    hoslisting(
                                      userID: userId,
                                      // loginedUserEmployeeNo: widget.loginEmployeeID,
                                      // designation: widget.designation,
                                      // schoolId: widget.schoolID,
                                      loginedUserName: widget.loginname,
                                      images: widget.image,
                                      loginname: widget.loginname,
                                      //academic_year: widget.academic_year,
                                      // roleUnderHos: employeeUnderHOS,
                                      //isAClassTeacher: newTeacherData,
                                    ));
                                break;
                              } else if (rollidprefname[i] == 'HOS' ||
                                  rollidprefname[i] == 'HOD' ||
                                  rollidprefname[i] == 'Supervisor') {
                                NavigationUtils.goNextFinishAll(
                                    context,
                                    DrawerPageForHos(
                                      userId: userId,
                                      roleUnderHos:
                                          widget.roleUnderLoginTeacher,
                                      // loginedUserEmployeeNo: widget.loginEmployeeID,
                                      // designation: widget.designation,
                                      // schoolId: widget.schoolID,
                                      loginedUserName: widget.loginname,
                                      images: widget.image,
                                      loginname: widget.loginname,
                                      //academic_year: widget.academic_year,
                                      // roleUnderHos: employeeUnderHOS,
                                      //isAClassTeacher: newTeacherData,
                                    ));
                                break;
                              }
                            }
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LeadershipListView(image: widget.image,roleUnderLoginTeacher: widget.roleUnderLoginTeacher,teachername: widget.teachername,usrId: userId,)));
                          },
                          child: Text('Go Back')),
                    ],
                  ),
                ));
      }

  }

  int charLengthFocusoflearningwalk = 0;
  int charLengthQuestiontoaskpupils = 0;
  int charLengthquestiontoaskTeacher = 0;
  int charLengthwhatwentwell = 0;
  int charLengthevenbettrif = 0;
  int charLengthremarks = 0;

  _onChangedFocusoflearningwalk(String value) {
    setState(() {
      charLengthFocusoflearningwalk = value.length;
    });
  }

  _onChangedQuestiontoaskpupils(String value) {
    setState(() {
      charLengthQuestiontoaskpupils = value.length;
    });
  }

  _onChangedquestiontoaskTeacher(String value) {
    setState(() {
      charLengthquestiontoaskTeacher = value.length;
    });
  }

  _onChangedwhatwentwell(String value) {
    setState(() {
      charLengthwhatwentwell = value.length;
    });
  }

  _onChangedevenbetterif(String value) {
    setState(() {
      charLengthevenbettrif = value.length;
    });
  }
  _onChangedremarks(String value) {
    setState(() {
      charLengthremarks = value.length;
    });
  }

  DateTime _selectedDate = DateTime.now();
  DateTime? _ObservationDate;
  String _pickedDate = 'Observation Date';
  DateTime initialDate = DateTime.now().subtract(Duration(days: 14));
  // Custom function to check if a day is selectable
  bool _isSelectable(DateTime day) {
    print('----------------day$day');
    // Allow dates up to the previous 2 weeks and avoid Sundays
    return day.weekday != DateTime.sunday;
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: initialDate,
  //     lastDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
  //     selectableDayPredicate: _isSelectable,
  //   );
  //
  //   if (picked != null ) {
  //     setState(() {
  //       _ObservationDate = picked;
  //       _pickedDate = '${picked.toString().split('-').last.split(' ').first}-${picked.toString().split('-')[1]}-${picked.toString().split('-').first}';
  //     });
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlist();
    getdata();
    focusoflw();
    getNotification();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    print('learning data--------------->${widget.learningData}');
    print('teacher name ------------->${widget.teacherName}');
    print('--------------rollid lw2------${widget.role_id}');
    print('--------------userid lw2------${widget.userid}');
    print('--------------userid lw2------${widget.roleUnderLoginTeacher}');
  }

  @override
  void didUpdateWidget(covariant learningwalkIndicators oldWidget) {
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
        //resizeToAvoidBottomInset: true,
        backgroundColor: ColorUtils.BACKGROUND,
        body: Form(
          key: _formKey,
          child: LoadingOverlay(
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
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    margin: EdgeInsets.only(
                      top: 100.h,
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ListView(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                            child: Text(
                              'Learning Walk',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 35.w, top: 20.h, right: 35.w, bottom: 20),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 20),
                              // height: 131.h,
                              width: 280.w,
                              decoration: BoxDecoration(
                                  color: Color(0xff18C7C7),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Color(0xFFD6E4FA)),
                                            color: Colors.white,
                                            // image: DecorationImage(
                                            //     image: NetworkImage(widget.teacherImage == ""
                                            //         ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                            //         : ApiConstants.IMAGE_BASE_URL +
                                            //         "${widget.teacherImage}"),
                                            //     fit: BoxFit.cover),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Center(child: Text('${widget.class_Name}${widget.division_name}')),
                                            // child: CachedNetworkImage(
                                            //   width: 50,
                                            //   height: 50,
                                            //   fit: BoxFit.fill,
                                            //   imageUrl:
                                            //       ApiConstants.IMAGE_BASE_URL +
                                            //           "${widget.teacherImage}",
                                            //   placeholder: (context, url) =>
                                            //       Center(
                                            //     child: Text(
                                            //       '${widget.teacherName!.split(' ')[0].toString()[0]}${widget.teacherName!.split(' ')[1].toString()[0]}',
                                            //       style: TextStyle(
                                            //           color: Color(0xFFB1BFFF),
                                            //           fontWeight:
                                            //               FontWeight.bold,
                                            //           fontSize: 20),
                                            //     ),
                                            //   ),
                                            //   errorWidget:
                                            //       (context, url, error) =>
                                            //           Center(
                                            //     child: Text(
                                            //       '${widget.teacherName!.split(' ')[0].toString()[0]}${widget.teacherName!.split(' ')[1].toString()[0]}',
                                            //       style: TextStyle(
                                            //           color: Color(0xFFB1BFFF),
                                            //           fontWeight:
                                            //               FontWeight.bold,
                                            //           fontSize: 20),
                                            //     ),
                                            //   ),
                                            // ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.w),
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 170.w,
                                                  child: Text(
                                                    'Class: ${widget.class_Name}'
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white,
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Text(
                                                 'Division: ${widget.division_name}'.toString(),
                                                  style: TextStyle(
                                                      color:Colors.white,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Container(
                                                  width: 200.w,
                                                  child: Text(
                                                    widget.selectedteacher_Name
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Row(
                              children: [
                                Container(
                                  height: 60.h,
                                  width: 180.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(230, 236, 254, 8)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // SizedBox(width: 5,),
                                        Icon(
                                          Icons.calendar_month_outlined,color: ColorUtils.COLOR_SEVEN,),
                                        // SizedBox(width: 10,),
                                        Text(
                                            '${DateTime.now().toString().split('-').last.split(' ').first}-${DateTime.now().toString().split('-')[1]}-${DateTime.now().toString().split('-').first}',
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: ColorUtils.COLOR_SEVEN),
                                        ),

                                      ],
                                    ),

                                ),

                              ],
                            ),

                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 35.w, right: 35.w, top: 20.h),
                            child: DropdownButtonFormField(
                              value: _focusoflwSelected,
                              isExpanded: true,
                              onChanged: (dynamic newVal) {
                                setState(() {
                                  {
                                    _isDataEntered = newVal.isNotEmpty;
                                    _focusoflwSelected = newVal;
                                    selectedfocusofLW = focusoflwData![int.parse(newVal)];
                                    print('selectedfocusofLW--------------------$selectedfocusofLW');
                                    focusOfLearningwalkTextController.text = selectedfocusofLW;
                                  }
                                });
                              },
                              decoration:
                              InputDecoration(
                                  hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.5),fontSize: 15),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 20.0),
                                  hintText: "Select Focus Of Learning Walk",
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
                              items: focusoflwData == null ? null : focusoflwData!
                                  .map<DropdownMenuItem<String>>((item) {
                                return DropdownMenuItem<String>(
                                  value:  focusoflwData!
                                      .indexOf(item)
                                      .toString(),
                                  child: Text(
                                    // ''
                                    '${item}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    // maxLines: 1,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 10.h,),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 35.w, left: 35.w, top: 20.h),
                            child: TextFormField(
                              controller: focusOfLearningwalkTextController,
                              maxLength: 1000,
                              validator: (val) => val!.isEmpty
                                  ? '  *Focus Of Learning Walk is required'
                                  : null,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black26),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 20.0),
                                  hintText: focusOfLearningwalkTextController.text.isNotEmpty ? null : "Focus Of Learning Walk*",
                                  label: focusOfLearningwalkTextController.text.isNotEmpty ? Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text('Focus Of Learning Walk*',style: TextStyle(fontWeight: FontWeight.w500),),
                                  ) : null ,
                                  counterText: "$charLengthFocusoflearningwalk/1000",
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
                                        BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  fillColor: Color.fromRGBO(230, 236, 254, 8),
                                  filled: true),
                              maxLines: 5,
                              onChanged: _onChangedFocusoflearningwalk,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Row(
                              children: [
                                CustomCheckbox(
                                  size: 35.0,
                                  iconSize: 15.0,
                                  borderRadius: BorderRadius.circular(8),
                                  checkIcon: Icon(Icons.done_rounded),
                                  borderColor: const Color(0xFF00BEA7),
                                  selectedColor: const Color(0xFF00BEA7),
                                  // isChecked: true,
                                  onChange:
                                  (bool value) {
                                    setState(() {
                                      ischeck = value;
                                    });
                                    questionstoaskTeachersTextController.clear();
                                    questionstoaskPupilsTextController.clear();
                                  },
                                ),
                                Text('UnInterrupted CheckBox',style: TextStyle(fontWeight: FontWeight.w600),)
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !ischeck,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 35.w, left: 35.w, top: 20.h),
                              child: TextFormField(
                                controller: questionstoaskPupilsTextController,
                                maxLength: 1000,
                                validator: (val) => val!.isEmpty
                                    ? '  *Questions To Ask Pupils is required'
                                    : null,
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.black26),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    hintText: questionstoaskPupilsTextController.text.isNotEmpty ? null : "Questions To Ask Pupils*",
                                    label: questionstoaskPupilsTextController.text.isNotEmpty ? Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: Text('Questions To Ask Pupils*',style: TextStyle(fontWeight: FontWeight.w500),),
                                    ) : null ,
                                    counterText: "$charLengthQuestiontoaskpupils/1000",
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
                                      BorderRadius.all(Radius.circular(30.0)),
                                    ),
                                    fillColor: Color.fromRGBO(230, 236, 254, 8),
                                    filled: true),
                                maxLines: 5,
                                onChanged: _onChangedQuestiontoaskpupils
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !ischeck,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 35.w, left: 35.w, top: 20.h),
                              child: TextFormField(
                                controller: questionstoaskTeachersTextController,
                                maxLength: 1000,
                                validator: (val) => val!.isEmpty
                                    ? '  *Questions To Ask Teachers is required'
                                    : null,

                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.black26),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    hintText: questionstoaskTeachersTextController.text.isNotEmpty ? null : "Questions To Ask Teachers*",
                                    label: questionstoaskTeachersTextController.text.isNotEmpty ? Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: Text('Questions To Ask Teachers*',style: TextStyle(fontWeight: FontWeight.w500),),
                                    ) : null ,
                                    counterText: "$charLengthquestiontoaskTeacher/1000",
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
                                      BorderRadius.all(Radius.circular(30.0)),
                                    ),
                                    fillColor: Color.fromRGBO(230, 236, 254, 8),
                                    filled: true),
                                maxLines: 5,
                                onChanged: _onChangedquestiontoaskTeacher,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 35.w, left: 35.w, top: 20.h),
                            child: TextFormField(
                              controller: whatwentwellTextController,
                              maxLength: 1000,
                              validator: (val) => val!.isEmpty
                                  ? '  *What Went Well is required'
                                  : null,

                              decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black26),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  hintText: whatwentwellTextController.text.isNotEmpty ? null : "What Went Well*",
                                  label: whatwentwellTextController.text.isNotEmpty ? Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text('What Went Well*',style: TextStyle(fontWeight: FontWeight.w500),),
                                  ) : null ,
                                  counterText: "$charLengthwhatwentwell/1000",
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
                                        BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  fillColor: Color.fromRGBO(230, 236, 254, 8),
                                  filled: true),
                              maxLines: 5,
                              onChanged: _onChangedwhatwentwell,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 35.w, left: 35.w, top: 20.h),
                            child: TextFormField(
                              controller: evenbetterifTextController,
                              maxLength: 1000,
                              validator: (val) => val!.isEmpty
                                  ? '  *Even Better If is required'
                                  : null,

                              decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black26),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  hintText: evenbetterifTextController.text.isNotEmpty ? null : "Even Better If*",
                                  label: evenbetterifTextController.text.isNotEmpty ? Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text('Even Better If*',style: TextStyle(fontWeight: FontWeight.w500),),
                                  ) : null ,
                                  // labelText: _isDataEntered ? 'Even better if' : 'Even better if',
                                  counterText: "$charLengthevenbettrif/1000",
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
                                        BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  fillColor: Color.fromRGBO(230, 236, 254, 8),
                                  filled: true),
                              maxLines: 5,
                              onChanged: _onChangedevenbetterif,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(
                                right: 35.w, left: 35.w, top: 20.h),
                            child: TextFormField(
                              controller: remarksTextController,
                              focusNode: _remarksFocus,
                              maxLength: 1000,

                              decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black26),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  hintText: remarksTextController.text.isNotEmpty ? null : "Remarks",
                                  label: remarksTextController.text.isNotEmpty ? Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text('Remarks',style: TextStyle(fontWeight: FontWeight.w500),),
                                  ) : null ,
                                  counterText: "$charLengthremarks/1000",
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
                                    BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                  fillColor: Color.fromRGBO(230, 236, 254, 8),
                                  filled: true),
                              maxLines: 5,
                              onChanged: _onChangedremarks,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                 if (_formKey.currentState!.validate()) {

                                   print('function submit');
                                   // if (isvalid) {
                                   var connectivityResult = await (Connectivity()
                                       .checkConnectivity());
                                   if (connectivityResult ==
                                       ConnectivityResult.none) {
                                     {
                                       //getLessonData();
                                       await addNote();
                                       // _submitedSuccessfully(context);
                                       focusOfLearningwalkTextController.clear();
                                       questionstoaskPupilsTextController.clear();
                                       questionstoaskTeachersTextController.clear();
                                       whatwentwellTextController.clear();
                                       evenbetterifTextController.clear();
                                       remarksTextController.clear();
                                     }
                                   } else {
                                     SubmitRequest();
                                   }
                                 } else {
                                   print('Validation not success');
                                 }
                                },
                                child: Container(
                                  height: 60.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      color: Color(0xff42C614),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  )),
                                ),
                              ),
                              SizedBox(width: 10,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                    height: 60.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.white)
                                      ),
                                    )),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 180.h,
                          )
                        ]))
              ])
            ]),
          ),
        ));
  }

  //The given below variables are for adding datas to Sql Db**********************
  var QuestionDb = [];
  List fieldDB = [];
  //SQL Adding********************************************************************
  // Future addnoteQuestionlist() async {
  //   setState(() {
  //     ischeck = false;
  //   });
  //   QuestionDb.clear();
  //   for (int quest = 0; quest < this.questionData!['list'].length; quest++) {
  //     // print("LEssndata");
  //     // print(quest);
  //     var remarkData;
  //     var db_key;
  //     var alias;
  //     if (questionData!['list'][quest]['values'] == 3) {
  //       remarkData = "Weak";
  //       db_key = "Weak";
  //       alias = "Weak";
  //     } else if (questionData!['list'][quest]['values'] == 5) {
  //       remarkData = "Acceptable";
  //       db_key = "Acceptable";
  //       alias = "Acceptable";
  //     } else if (questionData!['list'][quest]['values'] == 7) {
  //       remarkData = "Good";
  //       db_key = "Good";
  //       alias = "Good";
  //     } else if (questionData!['list'][quest]['values'] == 9) {
  //       remarkData = "Very Good";
  //       db_key = "Very_good";
  //       alias = "Very good";
  //     } else if (questionData!['list'][quest]['values'] == 10) {
  //       remarkData = "Outstanding";
  //       db_key = "Outstanding";
  //       alias = "Outstanding";
  //     } else if (questionData!['list'][quest]['values'] == 0) {
  //       remarkData = "NA";
  //       db_key = "NA";
  //       alias = "NA";
  //     } else {
  //       remarkData = null;
  //       db_key = null;
  //       alias = null;
  //     }
  //     QuestionDb.add({
  //       "name": questionData!['list'][quest]['indicator'],
  //       "remark": remarkData,
  //       "point": questionData!['list'][quest]['values'],
  //     });
  //
  //     // print(QuestionSample!['list'][quest]['values']);
  //   }
  // }

  // Future addnoteischeck() async {
  //   for (int i = 0; i < QuestionDb.length; i++) {
  //     print("for loop");
  //     if (QuestionDb[i]['remark'] != null) {
  //       print('${QuestionDb[i]['remark']}');
  //       setState(() {
  //         ischeck = false;
  //       });
  //       break;
  //     } else {
  //       setState(() {
  //         ischeck = true;
  //       });
  //     }
  //   }
  // }

  Future addNote() async {
    // await addnoteQuestionlist();
    // await addnoteischeck();
    // print('ischekkkkkkk----------$ischeck');
    
      setState(() {
        isSpinner = true;
      });
      // print(QuestionDb);
      // String jsonData = jsonEncode(QuestionDb);
      String roles = jsonEncode(widget.OB_ID);
      final note = Note(
    academic_year:academicyear,
    school_id:schoolId,
    added_by:userId,
    added_date:DateTime.now().toLocal().toString(),
    session_id:widget.session_Id,
    curriculum_id:widget.curriculam_Id,
    class_id:widget.class_id,
    batch_id:widget.division_id,
    teacher_id:widget.selectedteacher_Id ?? "",
    teacher_name:widget.selectedteacher_Name ?? "",
    lw_focus:focusOfLearningwalkTextController.text.isEmpty ? "" : focusOfLearningwalkTextController.text,
    qs_to_puple:questionstoaskPupilsTextController.text.isEmpty ? "" : questionstoaskPupilsTextController.text,
    qs_to_teacher:questionstoaskTeachersTextController.text.isEmpty ? "" : questionstoaskTeachersTextController.text,
    what_went_well:whatwentwellTextController.text.isEmpty ? "" : whatwentwellTextController.text,
    even_better_if:evenbetterifTextController.text.isEmpty ? "" : evenbetterifTextController.text,
    sender_id:userId,
    observation_date : DateTime.now().toLocal().toString(),
    observer_roles :"${widget.role_id}",
    notes : remarksTextController.text.isEmpty ? "" : remarksTextController.text,
    app: 1,
    );
      await NotesDatabase.instance.create(note);
      if (note == null) {
        _submitedfailed(context);
      } else {
        setState(() {
          _submitedSuccessfully(context);
        });

        focusOfLearningwalkTextController.clear();
        questionstoaskPupilsTextController.clear();
        questionstoaskTeachersTextController.clear();
        whatwentwellTextController.clear();
        evenbetterifTextController.clear();
        remarksTextController.clear();
      }

      setState(() {
        isSpinner = false;
      });
    // else {
    //   print("-----------object------------------");
    //   showDialog(
    //       barrierDismissible: false,
    //       context: context,
    //       builder: (_) => AlertDialog(
    //             title: Text('Please fill atleast a indicators to continue'),
    //             actions: [
    //               ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                 },
    //                 child: Text('OK'),
    //               ),
    //             ],
    //           ));
    // }
  }

//Alert Box for Submition success or fail***************************************
  _submitedSuccessfully(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              // return Future.value(false);
              return false;
            },
            child: AlertDialog(
              title: Text("Learning Walk Submitted Successfully"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      for (var i = 0; i < rollidprefname.length; i++) {
                        // print('rollidprefname[i]${rollidprefname[0]}');
                        // print('rollidprefname[i]${rollidprefname[1]}');
                        print('rollidprefname[i]${rollidprefname[i]}');
                        if (rollidprefname[i] == 'Principal' ||
                            rollidprefname[i] == 'Vice Principal') {
                          NavigationUtils.goNextFinishAll(
                              context,
                              hoslisting(
                                userID: userId,
                                // loginedUserEmployeeNo: widget.loginEmployeeID,
                                // designation: widget.designation,
                                // schoolId: widget.schoolID,
                                loginedUserName: widget.loginname,
                                images: widget.image,
                                loginname: widget.loginname,
                                //academic_year: widget.academic_year,
                                // roleUnderHos: employeeUnderHOS,
                                //isAClassTeacher: newTeacherData,
                              ));
                          break;
                        } else if (rollidprefname[i] == 'HOS' ||
                            rollidprefname[i] == 'HOD' ||
                            rollidprefname[i] == 'Supervisor') {
                          NavigationUtils.goNextFinishAll(
                              context,
                              DrawerPageForHos(
                                userId: userId,
                                roleUnderHos: widget.roleUnderLoginTeacher,
                                // loginedUserEmployeeNo: widget.loginEmployeeID,
                                // designation: widget.designation,
                                // schoolId: widget.schoolID,
                                loginedUserName: widget.loginname,
                                loginname: widget.loginname,
                                images: widget.image,
                                //academic_year: widget.academic_year,
                                // roleUnderHos: employeeUnderHOS,
                                //isAClassTeacher: newTeacherData,
                              ));
                          break;
                        }
                      }

                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LeadershipListView(image: widget.image,roleUnderLoginTeacher: widget.roleUnderLoginTeacher,teachername: widget.teachername,usrId: userId,)));
                    },
                    child: Text('Go Back')),
              ],
            ),
          );
        });
  }

  _submitedfailed(context) {
    return Alert(
      context: context,
      type: AlertType.error,
      title: "Failed to \nSubmit",
      style: AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          child: Text(
            "Retry",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            for (var i = 0; i < rollidprefname.length; i++) {
              // print('rollidprefname[i]${rollidprefname[0]}');
              // print('rollidprefname[i]${rollidprefname[1]}');
              print('rollidprefname[i]${rollidprefname[i]}');
              if (rollidprefname[i] == 'Principal' ||
                  rollidprefname[i] == 'Vice Principal' ||
                  rollidprefname[i] == 'Academic Co-ordinator') {
                NavigationUtils.goNextFinishAll(
                    context,
                    hoslisting(
                      userID: userId,
                      // loginedUserEmployeeNo: widget.loginEmployeeID,
                      // designation: widget.designation,
                      // schoolId: widget.schoolID,
                      loginedUserName: widget.loginname,
                      images: widget.image,
                      loginname: widget.loginname,
                      //academic_year: widget.academic_year,
                      // roleUnderHos: employeeUnderHOS,
                      //isAClassTeacher: newTeacherData,
                    ));
                break;
              } else if (rollidprefname[i] == 'HOS' ||
                  rollidprefname[i] == 'HOD' ||
                  rollidprefname[i] == 'Supervisor') {
                NavigationUtils.goNextFinishAll(
                    context,
                    DrawerPageForHos(
                      userId: userId,
                      // loginedUserEmployeeNo: widget.loginEmployeeID,
                      // designation: widget.designation,
                      // schoolId: widget.schoolID,
                      roleUnderHos: widget.roleUnderLoginTeacher,
                      loginedUserName: widget.loginname,
                      loginname: widget.loginname,
                      images: widget.image,
                      //academic_year: widget.academic_year,
                      // roleUnderHos: employeeUnderHOS,
                      //isAClassTeacher: newTeacherData,
                    ));
                break;
              }
            }

            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LeadershipListView(image: widget.image,roleUnderLoginTeacher: widget.roleUnderLoginTeacher,teachername: widget.teachername,usrId: userId,)));
          },
        )
      ],
    ).show();
  }

  bool validateandsave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}

class CustomCheckbox extends StatefulWidget {
  final Function? onChange;
  final bool? isChecked;
  final double? size;
  final double? iconSize;
  final Color? selectedColor;
  final Color? selectedIconColor;
  final Color? borderColor;
  final Icon? checkIcon;
  final BorderRadiusGeometry? borderRadius;
  const CustomCheckbox(
      {super.key,
        this.isChecked,
        this.onChange,
        this.size,
        this.iconSize,
        this.selectedColor,
        this.selectedIconColor,
        this.borderColor,
        this.checkIcon,
        this.borderRadius});
  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}
class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isSelected = false;
  @override
  void initState() {
    _isSelected = widget.isChecked ?? false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onChange!(_isSelected);
        });
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.all(4),
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            color: _isSelected
                ? widget.selectedColor ?? Colors.blue
                : Colors.transparent,
            borderRadius: widget.borderRadius,
            border: Border.all(
              color: widget.borderColor ?? Colors.black,
              width: 0.789,
            )),
        width: widget.size ?? 18,
        height: widget.size ?? 18,
        child: _isSelected
            ? Icon(
          Icons.check,
          color: widget.selectedIconColor ?? Colors.white,
          size: widget.iconSize ?? 14,
        )
            : null,
      ),
    );
  }
}

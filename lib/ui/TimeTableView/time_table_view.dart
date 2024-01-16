import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/time_table_database_helper.dart';
import '../../Network/api_constants.dart';
import '../../Notification/notification.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../LoginPage/login.dart';
import '../StudentList/new_student_list_view.dart';
import '../TimeTableList/friday.dart';
import '../TimeTableList/monday.dart';
import '../TimeTableList/saturday.dart';
import '../TimeTableList/thursday.dart';
import '../TimeTableList/tuesday.dart';
import '../TimeTableList/wednesday.dart';
import 'package:http/http.dart' as http;

class TimeTableView extends StatefulWidget {
  String? name;
  var classAndDivision;
  String? LogedInUserEmpCode;
  var LogedInUserDesig;
  var teacherData;
  String? school_id;
  String? user_id;
  String? images;
  var teacherClasses;
  var employeeUnderHos;
  String? academic_year;

  TimeTableView(
      {this.name,
        this.classAndDivision,
        this.LogedInUserDesig,
        this.LogedInUserEmpCode,
        this.teacherData,
        this.school_id,
        this.user_id,
        this.images,
        this.teacherClasses,
        this.employeeUnderHos,this.academic_year});

  @override
  _TimeTableViewState createState() => _TimeTableViewState();
}

class _TimeTableViewState extends State<TimeTableView> {
  // late List<TimeTableData> timeTable = [];

  //stt.SpeechToText _speech = stt.SpeechToText();
  //bool _isListening = false;
  final String _textSpeech = "Search Here";
  final _textController = TextEditingController();
  bool isListView = true;
  bool isCalenderSelectedOnMonday = false;
  bool isCalenderSelectedOnTuesday = false;
  bool isCalenderSelectedOnWednesday = false;
  bool isCalenderSelectedOnThursday = false;
  bool isCalenderSelectedOnFriday = false;
  bool isCalenderSelectedOnSaturday = false;

  List<Color> colorList = [ColorUtils.ONE, ColorUtils.TWO, ColorUtils.THREE];
  List filteredClass = [];
  List newResult = [];
  List filteredOtherClass = [];
  List newFilteredClass = [];
  int SelectedPage = 0;
  var classB = [];
  var newTeacherData;
  String? img;
  bool isSpinner = false;
  Timer? timer;

  Map<String, dynamic>? loginCredential;

  getCurrentDate() {
    final DateFormat formatter = DateFormat('d-MMMM-y');
    String createDate = formatter.format(DateTime.now());
    return createDate;
  }

  CurrentDate() {
    if (DateFormat('EEEE').format(DateTime.now()) == "Monday") {
      isCalenderSelectedOnMonday = true;
    } else if (DateFormat('EEEE').format(DateTime.now()) == "Tuesday") {
      isCalenderSelectedOnTuesday = true;
    } else if (DateFormat('EEEE').format(DateTime.now()) == "Wednesday") {
      isCalenderSelectedOnWednesday = true;
    } else if (DateFormat('EEEE').format(DateTime.now()) == "Thursday") {
      isCalenderSelectedOnThursday = true;
    } else if (DateFormat('EEEE').format(DateTime.now()) == "Friday") {
      isCalenderSelectedOnFriday = true;
    } else if (DateFormat('EEEE').format(DateTime.now()) == "Saturday") {
      isCalenderSelectedOnSaturday = true;
    }
  }

  Map<String, dynamic>? timeTableData;
  var modifiedTimeTable = [];

  Future theStudentTimeTable() async {
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.TIME_TABLE));
    request.body = json.encode({
      "school_id": widget.school_id,
      "academic_year": widget.academic_year,
      "teacher_id": widget.user_id
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var timeTable = await response.stream.bytesToString();

      setState(() {
        timeTableData = json.decode(timeTable);
      });
      print("the time table is $timeTableData");

      for (var index = 0;
      index < timeTableData!["data"]["resultArray"].length;
      index++) {
        for (var ind = 0;
        ind <
            timeTableData!["data"]["resultArray"][index]["timeTable"]
                .length;
        ind++) {
          for (var j = 0;
          j <
              timeTableData!["data"]["resultArray"][index]["timeTable"][ind]
              ["class_details"]
                  .length;
          j++) {
            if (timeTableData!["data"]["resultArray"][index]["timeTable"][ind]
            ["class_details"] !=
                null ||
                timeTableData!["data"]["resultArray"][index]["timeTable"][ind]
                ["class_details"]
                    .isNotEmpty) {
              modifiedTimeTable.add({
                "session_id": timeTableData!["data"]["resultArray"][index]
                ["timeTable"][ind]["class_details"][j]["details"]
                ["session_id"],
                "class_id": timeTableData!["data"]["resultArray"][index]
                ["timeTable"][ind]["class_details"][j]["details"]
                ["class_id"],
                "batch_id": timeTableData!["data"]["resultArray"][index]
                ["timeTable"][ind]["class_details"][j]["details"]
                ["batch_id"],
                "curriculum_id": timeTableData!["data"]["resultArray"][index]
                ["timeTable"][ind]["class_details"][j]["details"]
                ["curriculum_id"],
                "batchName": timeTableData!["data"]["resultArray"][index]
                ["timeTable"][ind]["batchName"],
                "timeString": timeTableData!["data"]["resultArray"][index]
                ["timeTable"][ind]["timeString"],
                "subject": timeTableData!["data"]["resultArray"][index]
                ["timeTable"][ind]["subject"]
              });
            }
          }
        }
      }
      // addToLocalDb();
      print("The modified Time Table is $modifiedTimeTable");

      log("$timeTableData");

      log("the saturday time table is ${timeTableData!["data"]["resultArray"][6]["timeTable"]}");
    } else {
      print(response.reasonPhrase);
    }
  }

  Widget _daySelectedPage() {
    if (timeTableData != null) {
      if (isCalenderSelectedOnMonday == true && timeTableData != null) {
        return Monday(
          timeTable: timeTableData!["data"]["resultArray"][1]["timeTable"],
          school_id: widget.school_id,
          name: widget.name,
          selectedDate: getCurrentDate(),
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      } else if (isCalenderSelectedOnTuesday == true &&
          timeTableData != null) {
        return Tuesday(
          timeTable: timeTableData!["data"]["resultArray"][2]["timeTable"],
          school_id: widget.school_id,
          selectedDate: getCurrentDate(),
          name: widget.name,
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      } else if (isCalenderSelectedOnWednesday == true &&
          timeTableData != null) {
        return Wednesday(
          timeTable: timeTableData!["data"]["resultArray"][3]["timeTable"],
          school_id: widget.school_id,
          selectedDate: getCurrentDate(),
          name: widget.name,
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      } else if (isCalenderSelectedOnThursday == true &&
          timeTableData != null) {
        return Thursday(
          timeTable: timeTableData!["data"]["resultArray"][4]["timeTable"],
          school_id: widget.school_id,
          selectedDate: getCurrentDate(),
          name: widget.name,
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      } else if (isCalenderSelectedOnFriday == true &&
          timeTableData != null) {
        return Friday(
          timeTable: timeTableData!["data"]["resultArray"][5]["timeTable"],
          school_id: widget.school_id,
          selectedDate: getCurrentDate(),
          name: widget.name,
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      } else if (isCalenderSelectedOnSaturday == true &&
          timeTableData != null) {
        return Saturday(
          timeTable: timeTableData!["data"]["resultArray"][6]["timeTable"],
          school_id: widget.school_id,
          selectedDate: getCurrentDate(),
          name: widget.name,
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      }else{
        return Container();
      }
    }
    else if (widget.teacherClasses != null) {
      if (isCalenderSelectedOnMonday == true &&
          widget.teacherClasses != null) {
        return Monday(
          timeTable: timeTableData!["data"]["resultArray"][1]["timeTable"],
          school_id: widget.school_id,
          name: widget.name,
          selectedDate: getCurrentDate(),
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      } else if (isCalenderSelectedOnTuesday == true &&
          widget.teacherClasses != null) {
        return Tuesday(
          timeTable: timeTableData!["data"]["resultArray"][2]["timeTable"],
          school_id: widget.school_id,
          selectedDate: getCurrentDate(),
          name: widget.name,
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      } else if (isCalenderSelectedOnWednesday == true &&
          widget.teacherClasses != null) {
        return Wednesday(
          timeTable: timeTableData!["data"]["resultArray"][3]["timeTable"],
          school_id: widget.school_id,
          selectedDate: getCurrentDate(),
          name: widget.name,
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      } else if (isCalenderSelectedOnThursday == true &&
          widget.teacherClasses != null) {
        return Thursday(
          timeTable: timeTableData!["data"]["resultArray"][4]["timeTable"],
          school_id: widget.school_id,
          selectedDate: getCurrentDate(),
          name: widget.name,
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      } else if (isCalenderSelectedOnFriday == true &&
          widget.teacherData != null) {
        return Friday(
          timeTable: timeTableData!["data"]["resultArray"][5]["timeTable"],
          school_id: widget.school_id,
          selectedDate: getCurrentDate(),
          name: widget.name,
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      } else if (isCalenderSelectedOnSaturday == true &&
          widget.teacherData != null) {
        return Saturday(
          timeTable: timeTableData!["data"]["resultArray"][6]["timeTable"],
          school_id: widget.school_id,
          selectedDate: getCurrentDate(),
          name: widget.name,
          images: widget.images,
          academic_year: widget.academic_year,
          userId: widget.user_id,
          employeeNumber: widget.LogedInUserEmpCode,
          teacherClasses: widget.teacherClasses,
        );
      }else {
        return Container();
      }
    }
    return Container();
  }

  // Future addToLocalDb() async {
  //   print("database created");
  //
  //   var monday = jsonEncode(timeTableData!["data"]["resultArray"][1]["timeTable"]);
  //   var tuesday = jsonEncode(timeTableData!["data"]["resultArray"][2]["timeTable"]);
  //   var wednsday = jsonEncode(timeTableData!["data"]["resultArray"][3]["timeTable"]);
  //   var thursday = jsonEncode(timeTableData!["data"]["resultArray"][4]["timeTable"]);
  //   var friday = jsonEncode(timeTableData!["data"]["resultArray"][5]["timeTable"]);
  //   var saturday = jsonEncode(timeTableData!["data"]["resultArray"][6]["timeTable"]);
  //   var defaultTimeTable = jsonEncode(widget.teacherClasses);
  //
  //   final timeTable = TimeTableData(
  //       monday: monday,
  //       tuesday: tuesday,
  //       wednesday: wednsday,
  //       thursday: thursday,
  //       friday: friday,
  //       saturday: saturday,
  //       defaultData: defaultTimeTable
  //   );
  //   await TimeTableDatabase.instance.create(timeTable);
  // }

  // List _filteredClass = [];
  // _searchFunction(){
  //   _filteredClass = [];
  //   for(int i = 0; i < widget.classAndDivision.length; i++){
  //     var item = widget.classAndDivision[i];
  //     if(item.toLowerCase().contains(_textController.text.toLowerCase())){
  //       _filteredClass.add(item);
  //     }
  //     setState(() {
  //
  //     });
  //   }
  // }

  // void onListen() async {
  //   if (!_isListening) {
  //     bool available = await _speech.initialize(
  //         debugLogging: true,
  //         onStatus: (val) => print("onStatus $val"),
  //         onError: (val) => print("onStatus $val"));
  //     if (available) {
  //       setState(() {
  //         _isListening = true;
  //       });
  //       _speech.listen(
  //           onResult: (val) => setState(() {
  //                 _textSpeech = val.recognizedWords;
  //               }));
  //     }
  //   } else {
  //     setState(() {
  //       _isListening = false;
  //       _speech.stop();
  //     });
  //   }
  // }

  Map<String, dynamic>? notificationResult;
  int Count = 0;

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

      for(var index = 0; index < notificationResult!["data"]["details"]["recentNotifications"].length; index++){
        if(notificationResult!["data"]["details"]["recentNotifications"][index]["status"] == "active"){
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




  @override
  void initState() {
   theStudentTimeTable();
   timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
   print(count);
   getNotification();
    log("the modified timetable is ${widget.teacherData}");
    super.initState();
    CurrentDate();
    // _speech = stt.SpeechToText();
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue : Colors.lightBlueAccent,
        ),
      );
    },
  );

  // Future getTimeTableDatabase() async {
  //   this.timeTable = await TimeTableDatabase.instance.readAllNotes();
  // }

  // isDataExist() async {
  //   var result = await Connectivity().checkConnectivity();
  //   if(result == await ConnectivityResult.mobile){
  //     print("data not exist $timeTable");
  //     theStudentTimeTable();
  //   }else if(result == await ConnectivityResult.wifi){
  //     print("data not exist $timeTable");
  //     theStudentTimeTable();
  //   }else if(result == await ConnectivityResult.none){
  //     // getTimeTableDatabase();
  //     print("data exist $timeTable");
  //   }
  // }
  var subColorList = [
    ColorUtils.SUBCOLOR_ONE,
    ColorUtils.SUBCOLOR_TWO,
    ColorUtils.SUBCOLOR_THREE,
    ColorUtils.SUBCOLOR_FOUR,
    ColorUtils.SUBCOLOR_FIVE,
    ColorUtils.SUBCOLOR_SIX,
    ColorUtils.SUBCOLOR_ONE,
    ColorUtils.SUBCOLOR_TWO,
    ColorUtils.SUBCOLOR_THREE,
    ColorUtils.SUBCOLOR_FOUR,
    ColorUtils.SUBCOLOR_FIVE,
    ColorUtils.SUBCOLOR_SIX,
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.BACKGROUND,
      body: ListView(
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
                          image: widget.images,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: badges.Badge(
                          position: badges.BadgePosition.bottomEnd(end: -7, bottom: 12),
                          badgeContent: count == null ? Text("") : Text(count.toString(), style: TextStyle(color: Colors.white),),

                          child: SvgPicture.asset("assets/images/bell.svg")
                      ),
                    ),
                  ),
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFD6E4FA)),
                      image: DecorationImage(
                          image: NetworkImage(widget.images == "" ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg" : ApiConstants.IMAGE_BASE_URL +"${widget.images}"),
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
              timeTableData == null || timeTableData!.isEmpty
                  ? Container(
                  margin:
                  EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                      Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(child: CircularProgressIndicator(color: ColorUtils.RED,)))
                  : Container(
                  margin:
                  EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                      Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: teacherTimeTable()),
            ],
          )
        ],
      ),
    );
  }

  Widget isClassTeacher() {
    if (modifiedTimeTable == null ||
        modifiedTimeTable.isEmpty && widget.teacherData == null ||
        (widget.teacherData?.isEmpty ?? true)) {
      print("all empty");
      return Text("");
    } else if (modifiedTimeTable == null ||
        modifiedTimeTable.isEmpty && widget.teacherData != null ||
        (widget.teacherData).isNotEmpty) {
      if(widget.teacherData.length == 1){
        print("one empty");
        return Container(
          width: 120.w,
          height: 37.h,
          decoration: BoxDecoration(
              color: ColorUtils.MAIN_COLOR,
              borderRadius: BorderRadius.circular(8.r)),
          child: GestureDetector(
            onTap: () {
              NavigationUtils.goNext(
                  context,
                  StudentListView(
                    name: widget.name.toString(),
                    images: widget.images,
                    ClassAndBatch: widget.teacherData[0]["class"],
                    subjectName: widget.teacherData[0]["subjects"],
                    LoginedUserEmployeeCode: widget.LogedInUserEmpCode.toString(),
                    selectedDate: getCurrentDate(),
                    school_id: widget.school_id,
                    academic_year: widget.academic_year,
                    userId: widget.user_id,
                    // timeString: modifiedTimeTable[0]["timeString"].replaceAll("[", " ")
                    //     .replaceAll("]", " "),
                    className: widget.teacherData[0]["class"],
                    curriculam_id: widget.teacherData[0]["curriculumId"],
                    session_id: widget.teacherData[0]["session_id"],
                    class_id: widget.teacherData[0]["class_id"],
                    batch_id: widget.teacherData[0]["batch_id"],
                  ));
            },
            child: Row(
              children: [
                SizedBox(
                  width: 6.w,
                ),
                Container(
                  width: 70.w,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      "My Class",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: ColorUtils.WHITE),
                    ),
                  ),
                ),
                Container(
                  width: 38.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                      color: ColorUtils.SUB_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(50.r))),
                  child: Center(
                    child: Text(
                      widget.teacherData == null
                          ? " "
                          : widget.teacherData[0]["class"],
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }else{
        return Row(
          children: [
            Container(
              width: 70.w,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  "My Class",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,color: Colors.blueGrey),
                ),
              ),
            ),
            Container(
              width: 78.w,
              height: 40.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for(var index = 0; index< widget.teacherData.length; index++)
                    GestureDetector(
                      onTap: (){
                        NavigationUtils.goNext(
                            context,
                            StudentListView(
                              name: widget.name,
                              images: widget.images,
                              ClassAndBatch: widget.teacherData[index]["class"],
                              subjectName: widget.teacherData[index]["subjects"],
                              LoginedUserEmployeeCode: widget.LogedInUserEmpCode,
                              selectedDate: getCurrentDate(),
                              school_id: widget.school_id,
                              academic_year: widget.academic_year,
                              userId: widget.user_id,
                              // timeString: modifiedTimeTable[0]["timeString"].replaceAll("[", " ")
                              //     .replaceAll("]", " "),
                              className: widget.teacherData[index]["class"],
                              curriculam_id: widget.teacherData[index]["curriculumId"],
                              session_id: widget.teacherData[index]["session_id"],
                              class_id: widget.teacherData[index]["class_id"],
                              batch_id: widget.teacherData[index]["batch_id"],
                            ));
                      },
                      child: Container(
                        margin: EdgeInsets.all(2),
                        width: 30.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                            color: subColorList[index],
                            borderRadius: BorderRadius.all(Radius.circular(50.r))),
                        child: Center(
                          child: Text(
                            widget.teacherData == null
                                ? " "
                                : widget.teacherData[index]["class"],
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }
    } else if (modifiedTimeTable != null ||
        modifiedTimeTable.isNotEmpty && widget.teacherData == null ||
        (widget.teacherData).isEmpty) {
      print("2 empty");
      return Container(
        width: 110.w,
        height: 34.h,
        decoration: BoxDecoration(
            color: ColorUtils.MAIN_COLOR,
            borderRadius: BorderRadius.circular(8.r)),
        child: GestureDetector(
          onTap: () {
            NavigationUtils.goNext(
                context,
                StudentListView(
                  name: widget.name,
                  images: widget.images,
                  ClassAndBatch: modifiedTimeTable[0]["batchName"],
                  subjectName: modifiedTimeTable[0]["subject"],
                  LoginedUserEmployeeCode: widget.LogedInUserEmpCode,
                  selectedDate: getCurrentDate(),
                  school_id: widget.school_id,
                  academic_year: widget.academic_year,
                  userId: widget.user_id,
                  timeString: modifiedTimeTable[0]["timeString"]
                      .replaceAll("[", " ")
                      .replaceAll("]", " "),
                  className: modifiedTimeTable[0]["batchName"],
                  curriculam_id: modifiedTimeTable[0]["curriculum_id"],
                  session_id: modifiedTimeTable[0]["session_id"],
                  class_id: modifiedTimeTable[0]["class_id"],
                  batch_id: modifiedTimeTable[0]["batch_id"],
                ));
          },
          child: Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Container(
                width: 70.w,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "My Class",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: ColorUtils.WHITE),
                  ),
                ),
              ),
              Container(
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
                    color: ColorUtils.SUB_COLOR,
                    borderRadius: BorderRadius.all(Radius.circular(50.r))),
                child: Center(
                  child: Text(
                    modifiedTimeTable[0]["batchName"],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Text("");
  }

  Widget teacherTimeTable() {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      width: 500.w,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "My Timetable",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: isClassTeacher(),
            )
          ],
        ),
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 60.w,
                  height: 70.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        primary: isCalenderSelectedOnMonday == false
                            ? Colors.white
                            : ColorUtils.DARK_BLUE,
                        elevation: isCalenderSelectedOnMonday == false ? 0 : 15,
                        side: BorderSide(
                          width: 1.w,
                          color: isCalenderSelectedOnMonday == false
                              ? ColorUtils.BORDER_COLOR
                              : ColorUtils.DARK_BLUE,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isCalenderSelectedOnTuesday = false;
                          isCalenderSelectedOnWednesday = false;
                          isCalenderSelectedOnThursday = false;
                          isCalenderSelectedOnFriday = false;
                          isCalenderSelectedOnSaturday = false;
                          if (isCalenderSelectedOnMonday == false) {
                            isCalenderSelectedOnMonday = true;
                          }
                        });
                      },
                      child: Text(
                        "Mon",
                        style: TextStyle(
                            color: isCalenderSelectedOnMonday == false
                                ? ColorUtils.DATE_COLOR
                                : Colors.white,
                            fontSize: 11.sp),
                      )),
                ),
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 60.w,
                  height: 70.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        primary: isCalenderSelectedOnTuesday == false
                            ? Colors.white
                            : ColorUtils.DARK_BLUE,
                        elevation: isCalenderSelectedOnTuesday == false ? 0 : 8,
                        side: BorderSide(
                          width: 1.w,
                          color: isCalenderSelectedOnTuesday == false
                              ? ColorUtils.BORDER_COLOR
                              : ColorUtils.DARK_BLUE,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isCalenderSelectedOnMonday = false;
                          isCalenderSelectedOnWednesday = false;
                          isCalenderSelectedOnThursday = false;
                          isCalenderSelectedOnFriday = false;
                          isCalenderSelectedOnSaturday = false;
                          if (isCalenderSelectedOnTuesday == false) {
                            isCalenderSelectedOnTuesday = true;
                          }
                        });
                      },
                      child: Text(
                        "Tue",
                        style: TextStyle(
                            color: isCalenderSelectedOnTuesday == false
                                ? ColorUtils.DATE_COLOR
                                : Colors.white,
                            fontSize: 11.sp),
                      )),
                ),
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 60.w,
                  height: 70.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        primary: isCalenderSelectedOnWednesday == false
                            ? Colors.white
                            : ColorUtils.DARK_BLUE,
                        elevation:
                        isCalenderSelectedOnWednesday == false ? 0 : 8,
                        side: BorderSide(
                          width: 1.w,
                          color: isCalenderSelectedOnWednesday == false
                              ? ColorUtils.BORDER_COLOR
                              : ColorUtils.DARK_BLUE,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isCalenderSelectedOnMonday = false;
                          isCalenderSelectedOnTuesday = false;
                          isCalenderSelectedOnThursday = false;
                          isCalenderSelectedOnFriday = false;
                          isCalenderSelectedOnSaturday = false;
                          if (isCalenderSelectedOnWednesday == false) {
                            isCalenderSelectedOnWednesday = true;
                          }
                        });
                      },
                      child: Text(
                        "Wed",
                        style: TextStyle(
                            color: isCalenderSelectedOnWednesday == false
                                ? ColorUtils.DATE_COLOR
                                : Colors.white,
                            fontSize: 11.sp),
                      )),
                ),
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 60.w,
                  height: 70.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        primary: isCalenderSelectedOnThursday == false
                            ? Colors.white
                            : ColorUtils.DARK_BLUE,
                        elevation:
                        isCalenderSelectedOnThursday == false ? 0 : 8,
                        side: BorderSide(
                          width: 1.w,
                          color: isCalenderSelectedOnThursday == false
                              ? ColorUtils.BORDER_COLOR
                              : ColorUtils.DARK_BLUE,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isCalenderSelectedOnMonday = false;
                          isCalenderSelectedOnTuesday = false;
                          isCalenderSelectedOnWednesday = false;
                          isCalenderSelectedOnFriday = false;
                          isCalenderSelectedOnSaturday = false;
                          if (isCalenderSelectedOnThursday == false) {
                            isCalenderSelectedOnThursday = true;
                          }
                        });
                      },
                      child: Text(
                        "Thu",
                        style: TextStyle(
                            color: isCalenderSelectedOnThursday == false
                                ? ColorUtils.DATE_COLOR
                                : Colors.white,
                            fontSize: 11.sp),
                      )),
                ),
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 60.w,
                  height: 70.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        primary: isCalenderSelectedOnFriday == false
                            ? Colors.white
                            : ColorUtils.DARK_BLUE,
                        elevation: isCalenderSelectedOnFriday == false ? 0 : 8,
                        side: BorderSide(
                          width: 1.w,
                          color: isCalenderSelectedOnFriday == false
                              ? ColorUtils.BORDER_COLOR
                              : ColorUtils.DARK_BLUE,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isCalenderSelectedOnMonday = false;
                          isCalenderSelectedOnTuesday = false;
                          isCalenderSelectedOnWednesday = false;
                          isCalenderSelectedOnThursday = false;
                          isCalenderSelectedOnSaturday = false;
                          if (isCalenderSelectedOnFriday == false) {
                            isCalenderSelectedOnFriday = true;
                          }
                        });
                      },
                      child: Text(
                        "Fri",
                        style: TextStyle(
                            color: isCalenderSelectedOnFriday == false
                                ? ColorUtils.DATE_COLOR
                                : Colors.white,
                            fontSize: 11.sp),
                      )),
                ),
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 60.w,
                  height: 70.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        primary: isCalenderSelectedOnSaturday == false
                            ? Colors.white
                            : ColorUtils.DARK_BLUE,
                        elevation:
                        isCalenderSelectedOnSaturday == false ? 0 : 8,
                        side: BorderSide(
                          width: 1.w,
                          color: isCalenderSelectedOnSaturday == false
                              ? ColorUtils.BORDER_COLOR
                              : ColorUtils.DARK_BLUE,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isCalenderSelectedOnMonday = false;
                          isCalenderSelectedOnTuesday = false;
                          isCalenderSelectedOnWednesday = false;
                          isCalenderSelectedOnThursday = false;
                          isCalenderSelectedOnFriday = false;
                          if (isCalenderSelectedOnSaturday == false) {
                            isCalenderSelectedOnSaturday = true;
                          }
                          print(isCalenderSelectedOnSaturday);
                        });
                      },
                      child: Text(
                        "Sat",
                        style: TextStyle(
                            color: isCalenderSelectedOnSaturday == false
                                ? ColorUtils.DATE_COLOR
                                : Colors.white,
                            fontSize: 11.sp),
                      )),
                ),
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        _daySelectedPage(),
        SizedBox(
          height: 130.h,
        )
      ]),
    );
  }

  _logout(context) {
    return Alert(
      context: context,
      type: AlertType.info,
      title: "Are you sure you want to logout",
      style: const AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          color: ColorUtils.BLUE,
          child: const Text(
            "yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            await TimeTableDatabase.instance.delete();
            SharedPreferences preferences =
            await SharedPreferences.getInstance();
            preferences.remove("email");
            preferences.remove('userID');
            preferences.remove('employeeNumber');
            preferences.remove('name');
            preferences.remove('designation');
            preferences.remove("classData");
            preferences.remove("employeeData");
            preferences.remove("teacherData");
            preferences.remove("school_id");
            preferences.remove("images");
            preferences.remove("teacher");
            preferences.remove("hos");
            NavigationUtils.goNextFinishAll(context, LoginPage());
          },
          // print(widget.academicyear);
          //width: 120,
        ),
        DialogButton(
          color: ColorUtils.BLUE,
          child: const Text(
            "No",
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

  _checkInternet(context) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "No Internet",
      style: const AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          child: const Text(
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

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
}

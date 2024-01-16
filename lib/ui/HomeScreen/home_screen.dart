import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_version_plus/new_version_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:badges/badges.dart' as badges;
import '../../exports.dart';
import 'Leave_Approval/leave_approval.dart';

class HomeScreen extends StatefulWidget {
  String? name;
  var classAndDivision;
  // bool? notclassteacher ;
  String? LogedInUserEmpCode;
  var LogedInUserDesig;
  var teacherData;
  String? school_id;
  String? user_id;
  String? images;
  // var teacherClasses;
  List teacherClasses = [];
  var employeeUnderHos;
  var notclassteacher;
  String? academic_year;

  HomeScreen(
      {this.name,
      this.classAndDivision,
      this.notclassteacher,
      this.LogedInUserDesig,
      this.LogedInUserEmpCode,
      this.teacherData,
      this.school_id,
      this.user_id,
      this.images,
      required this.teacherClasses,
      // this.teacherClasses,
      this.employeeUnderHos,
      this.academic_year});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late List<TimeTableData> timeTable = [];

  bool _isListening = false;
  String? _textSpeech = "Search Here";
  final _textController = TextEditingController();
  List searchedStudentName = [];
  List newResult = [];
  var loginname;
  var newStudentList = [];
  bool isCalenderSelectedOnMonday = false;
  bool isCalenderSelectedOnTuesday = false;
  bool isCalenderSelectedOnWednesday = false;
  bool isCalenderSelectedOnThursday = false;
  bool isCalenderSelectedOnFriday = false;
  bool isCalenderSelectedOnSaturday = false;
  stt.SpeechToText _speech = stt.SpeechToText();
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

  getCurrentDate() {
    final DateFormat formatter = DateFormat('d-MMMM-y');
    String createDate = formatter.format(DateTime.now());
    return createDate;
  }

  void onListen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          debugLogging: true,
          onStatus: (val) => print("the onStatus $val"),
          onError: (val) => print("onerror $val"));
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
            onResult: (val) => setState(() {
                  _textSpeech = val.recognizedWords;
                  _textController.text = _textSpeech!;
                }));
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  Map<String, dynamic>? theTimeTableData;

  timeTable() async {
    var header = {
      "x-auth-token": "tq355lY3MJyd8Uj2ySzm",
      "Content-Type": "application/json"
    };

    var request = http.Request('POST', Uri.parse(ApiConstants.TIME_TABLE));
    request.body = json.encode({
      "school_id": widget.school_id,
      "academic_year": widget.academic_year,
      "teacher_id": widget.user_id
    });

    request.headers.addAll(header);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonResponse = await response.stream.bytesToString();
      setState(() {
        theTimeTableData = json.decode(jsonResponse);
      });
    }
  }

  Widget timeTableList() {
    if (theTimeTableData != null) {
      if (theTimeTableData!["data"]["resultArray"] == null) {
        print("the data is null");
        return Container();
      } else if (isCalenderSelectedOnMonday == true &&
          theTimeTableData!["data"]["resultArray"][0]["timeTable"] != null) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount:
                theTimeTableData!["data"]["resultArray"][1]["timeTable"].length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: GestureDetector(
                    onTap: () {
                      theTimeTableData!["data"]["resultArray"][1]["timeTable"]
                                  [index]["class_details"] ==
                              null
                          ? NavigationUtils.goNext(
                              context,
                              NonTeacherStudentList(
                                name: widget.name,
                                images: widget.images,
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                selectedDate: getCurrentDate(),
                                userId: widget.user_id,
                                // timeString: ourTimeTable[index]
                                // ["timeString"]
                                //     .replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["batch_id"],
                              ))
                          : NavigationUtils.goNext(
                              context,
                              StudentListView(
                                name: widget.name,
                                images: widget.images,
                                ClassAndBatch: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["batchName"],
                                subjectName: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["subject"],
                                LoginedUserEmployeeCode:
                                    widget.LogedInUserEmpCode,
                                selectedDate: getCurrentDate(),
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                userId: widget.user_id,
                                // timeString: modifiedTimeTable[0]["timeString"].replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][1]["timeTable"][index]
                                    ["batch_id"],
                              ));
                    },
                    child: _defaultTimeTable(
                        theTimeTableData!["data"]["resultArray"][1]["timeTable"]
                            [index]["batchName"],
                        theTimeTableData!["data"]["resultArray"][1]["timeTable"]
                            [index]["subject"],
                        mainColorList[index],
                        subColorList[index]),
                  ));
            });
      } else if (isCalenderSelectedOnMonday == true &&
          theTimeTableData!["data"]["resultArray"][2]["timeTable"] != null) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount:
                theTimeTableData!["data"]["resultArray"][2]["timeTable"].length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: GestureDetector(
                    onTap: () {
                      theTimeTableData!["data"]["resultArray"][2]["timeTable"]
                                  [index]["class_details"] ==
                              null
                          ? NavigationUtils.goNext(
                              context,
                              NonTeacherStudentList(
                                name: widget.name,
                                images: widget.images,
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                selectedDate: getCurrentDate(),
                                userId: widget.user_id,
                                // timeString: ourTimeTable[index]
                                // ["timeString"]
                                //     .replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["batch_id"],
                              ))
                          : NavigationUtils.goNext(
                              context,
                              StudentListView(
                                name: widget.name,
                                images: widget.images,
                                ClassAndBatch: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["batchName"],
                                subjectName: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["subject"],
                                LoginedUserEmployeeCode:
                                    widget.LogedInUserEmpCode,
                                selectedDate: getCurrentDate(),
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                userId: widget.user_id,
                                // timeString: modifiedTimeTable[0]["timeString"].replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][2]["timeTable"][index]
                                    ["batch_id"],
                              ));
                    },
                    child: _defaultTimeTable(
                        theTimeTableData!["data"]["resultArray"][2]["timeTable"]
                            [index]["batchName"],
                        theTimeTableData!["data"]["resultArray"][2]["timeTable"]
                            [index]["subject"],
                        mainColorList[index],
                        subColorList[index]),
                  ));
            });
      } else if (isCalenderSelectedOnMonday == true &&
          theTimeTableData!["data"]["resultArray"][3]["timeTable"] != null) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount:
                theTimeTableData!["data"]["resultArray"][3]["timeTable"].length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: GestureDetector(
                    onTap: () {
                      theTimeTableData!["data"]["resultArray"][3]["timeTable"]
                                  [index]["class_details"] ==
                              null
                          ? NavigationUtils.goNext(
                              context,
                              NonTeacherStudentList(
                                name: widget.name,
                                images: widget.images,
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                selectedDate: getCurrentDate(),
                                userId: widget.user_id,
                                // timeString: ourTimeTable[index]
                                // ["timeString"]
                                //     .replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["batch_id"],
                              ))
                          : NavigationUtils.goNext(
                              context,
                              StudentListView(
                                name: widget.name,
                                images: widget.images,
                                ClassAndBatch: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["batchName"],
                                subjectName: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["subject"],
                                LoginedUserEmployeeCode:
                                    widget.LogedInUserEmpCode,
                                selectedDate: getCurrentDate(),
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                userId: widget.user_id,
                                // timeString: modifiedTimeTable[0]["timeString"].replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][3]["timeTable"][index]
                                    ["batch_id"],
                              ));
                    },
                    child: _defaultTimeTable(
                        theTimeTableData!["data"]["resultArray"][3]["timeTable"]
                            [index]["batchName"],
                        theTimeTableData!["data"]["resultArray"][3]["timeTable"]
                            [index]["subject"],
                        mainColorList[index],
                        subColorList[index]),
                  ));
            });
      } else if (isCalenderSelectedOnMonday == true &&
          theTimeTableData!["data"]["resultArray"][4]["timeTable"] != null) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount:
                theTimeTableData!["data"]["resultArray"][4]["timeTable"].length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: GestureDetector(
                    onTap: () {
                      theTimeTableData!["data"]["resultArray"][4]["timeTable"]
                                  [index]["class_details"] ==
                              null
                          ? NavigationUtils.goNext(
                              context,
                              NonTeacherStudentList(
                                name: widget.name,
                                images: widget.images,
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                selectedDate: getCurrentDate(),
                                userId: widget.user_id,
                                // timeString: ourTimeTable[index]
                                // ["timeString"]
                                //     .replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["batch_id"],
                              ))
                          : NavigationUtils.goNext(
                              context,
                              StudentListView(
                                name: widget.name,
                                images: widget.images,
                                ClassAndBatch: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["batchName"],
                                subjectName: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["subject"],
                                LoginedUserEmployeeCode:
                                    widget.LogedInUserEmpCode,
                                selectedDate: getCurrentDate(),
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                userId: widget.user_id,
                                // timeString: modifiedTimeTable[0]["timeString"].replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][4]["timeTable"][index]
                                    ["batch_id"],
                              ));
                    },
                    child: _defaultTimeTable(
                        theTimeTableData!["data"]["resultArray"][4]["timeTable"]
                            [index]["batchName"],
                        theTimeTableData!["data"]["resultArray"][4]["timeTable"]
                            [index]["subject"],
                        mainColorList[index],
                        subColorList[index]),
                  ));
            });
      } else if (isCalenderSelectedOnMonday == true &&
          theTimeTableData!["data"]["resultArray"][5]["timeTable"] != null) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount:
                theTimeTableData!["data"]["resultArray"][5]["timeTable"].length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: GestureDetector(
                    onTap: () {
                      theTimeTableData!["data"]["resultArray"][5]["timeTable"]
                                  [index]["class_details"] ==
                              null
                          ? NavigationUtils.goNext(
                              context,
                              NonTeacherStudentList(
                                name: widget.name,
                                images: widget.images,
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                selectedDate: getCurrentDate(),
                                userId: widget.user_id,
                                // timeString: ourTimeTable[index]
                                // ["timeString"]
                                //     .replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["batch_id"],
                              ))
                          : NavigationUtils.goNext(
                              context,
                              StudentListView(
                                name: widget.name,
                                images: widget.images,
                                ClassAndBatch: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["batchName"],
                                subjectName: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["subject"],
                                LoginedUserEmployeeCode:
                                    widget.LogedInUserEmpCode,
                                selectedDate: getCurrentDate(),
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                userId: widget.user_id,
                                // timeString: modifiedTimeTable[0]["timeString"].replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][5]["timeTable"][index]
                                    ["batch_id"],
                              ));
                    },
                    child: _defaultTimeTable(
                        theTimeTableData!["data"]["resultArray"][5]["timeTable"]
                            [index]["batchName"],
                        theTimeTableData!["data"]["resultArray"][5]["timeTable"]
                            [index]["subject"],
                        mainColorList[index],
                        subColorList[index]),
                  ));
            });
      } else if (isCalenderSelectedOnMonday == true &&
          theTimeTableData!["data"]["resultArray"][6]["timeTable"] != null) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount:
                theTimeTableData!["data"]["resultArray"][6]["timeTable"].length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: GestureDetector(
                    onTap: () {
                      theTimeTableData!["data"]["resultArray"][6]["timeTable"]
                                  [index]["class_details"] ==
                              null
                          ? NavigationUtils.goNext(
                              context,
                              NonTeacherStudentList(
                                name: widget.name,
                                images: widget.images,
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                selectedDate: getCurrentDate(),
                                userId: widget.user_id,
                                // timeString: ourTimeTable[index]
                                // ["timeString"]
                                //     .replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["batch_id"],
                              ))
                          : NavigationUtils.goNext(
                              context,
                              StudentListView(
                                name: widget.name,
                                images: widget.images,
                                ClassAndBatch: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["batchName"],
                                subjectName: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["subject"],
                                LoginedUserEmployeeCode:
                                    widget.LogedInUserEmpCode,
                                selectedDate: getCurrentDate(),
                                school_id: widget.school_id,
                                academic_year: widget.academic_year,
                                userId: widget.user_id,
                                // timeString: modifiedTimeTable[0]["timeString"].replaceAll("[", " ")
                                //     .replaceAll("]", " "),
                                className: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["batchName"],
                                curriculam_id: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["curriculum_id"],
                                session_id: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["session_id"],
                                class_id: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["class_id"],
                                batch_id: theTimeTableData!["data"]
                                        ["resultArray"][6]["timeTable"][index]
                                    ["batch_id"],
                              ));
                    },
                    child: _defaultTimeTable(
                        theTimeTableData!["data"]["resultArray"][6]["timeTable"]
                            [index]["batchName"],
                        theTimeTableData!["data"]["resultArray"][6]["timeTable"]
                            [index]["subject"],
                        mainColorList[index],
                        subColorList[index]),
                  ));
            });
      } else {
        return Container();
      }
    }
    return Container();
  }

  Map<String, dynamic>? notificationResult;
  int Count = 0;

  getNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    loginname = preferences.getString('name');
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

  var count;

  getCount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      count = preferences.get("count");
    });
  }

  Timer? timer;

  @override
  void initState() {
    timeTable();
    print('widgetwidgetwidgetwidget${widget.teacherData}');
    print('newTeanotclassteachercherDatahomescreeeen${widget.notclassteacher}');
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    getNotification();
    CurrentDate();
    // _speech = stt.SpeechToText();
    _checkNewVersion();
    super.initState();
  }

  void _checkNewVersion() async {
    final newVersion = NewVersionPlus(
        iOSId: "com.educore.bmteacher", androidId: "com.educore.bmteacher");
    final status = await newVersion.getVersionStatus();
    if (status?.localVersion != status?.storeVersion) {
      newVersion.showUpdateDialog(
          context: context,
          versionStatus: status!,
          dialogTitle: 'Update NIMS Teacher?',
          dialogText: 'Latest Version: ${status.storeVersion} \n'
              ' \nCurrent version: ${status.localVersion} \n'
              ' \nNIMS Teacher recommends that you update to the latest version.To get the best from your Device, Please keep your App up to Date.',
          updateButtonText: 'UPDATE NOW',
          dismissButtonText: 'Maybe Later',
          allowDismissal: true,
          dismissAction: () {
            Navigator.pop(context);
          },
          launchModeVersion: LaunchModeVersion.normal);
    }
  }

  Widget isAClassTeacher() {
    if (widget.teacherData == null) {
      return Text("");
    } else if (widget.teacherData.length == 1) {
      return Row(
        children: [
          GestureDetector(
              onTap: () => NavigationUtils.goNext(
                  context,
                  leaveApproval(
                    images: widget.images,
                    name: widget.name,
                    selectedDate: getCurrentDate(),
                    drawer: false,
                  )),
              child: Container(
                height: 40.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Leave Approval",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                        color: ColorUtils.WHITE),
                  ),
                ),
              )),
          Container(
            margin: EdgeInsets.only(right: 10.w),
            width: 120.w,
            height: 37.h,
            decoration: BoxDecoration(
                // color: ColorUtils.MAIN_COLOR,
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
                      LoginedUserEmployeeCode:
                          widget.LogedInUserEmpCode.toString(),
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
                    width: 8.w,
                  ),
                  Container(
                    width: 65.w,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "My Class",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                            color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  Container(
                    width: 35.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                        color: ColorUtils.SUB_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(100.r))),
                    child: Center(
                      child: Text(
                        widget.teacherData == null
                            ? " "
                            : widget.teacherData[0]["class"],
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (widget.teacherData.length > 1) {
      return Row(
        children: [
          GestureDetector(
              onTap: () => NavigationUtils.goNext(
                  context,
                  leaveApproval(
                    images: widget.images,
                    name: widget.name,
                    selectedDate: getCurrentDate(),
                    drawer: false,
                  )),
              child: Container(
                height: 40.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Leave Approval",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                        color: ColorUtils.WHITE),
                  ),
                ),
              )),

          SizedBox(
            width: 8.w,
          ),
          Container(
            width: 60.w,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                "My Class",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    color: Colors.blueGrey),
              ),
            ),
          ),
          Container(
            width: 80.w,
            height: 40.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var index = 0; index < widget.teacherData.length; index++)
                  GestureDetector(
                    onTap: () {
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
                            curriculam_id: widget.teacherData[index]
                                ["curriculumId"],
                            session_id: widget.teacherData[index]["session_id"],
                            class_id: widget.teacherData[index]["class_id"],
                            batch_id: widget.teacherData[index]["batch_id"],
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.all(2),
                      width: 35.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          color: subColorList[index],
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.r))),
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
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                margin: EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20, top: 15, bottom: 20, right: 10),
                            child: Text(
                              "My Classes",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          //    GestureDetector(
                          //     onTap: ()=> NavigationUtils.goNext(
                          //         context,
                          //         leaveApproval(
                          //           images: widget.images,
                          //           name: widget.name,
                          //           selectedDate: getCurrentDate(),
                          //         )),
                          //     child: Container(
                          //       height: 40.h,
                          //       width: 100.w,
                          //       decoration: BoxDecoration(
                          //           color: Colors.red,
                          //           borderRadius: BorderRadius.circular(10)
                          //       ),
                          //       child: Center(
                          //         child: Text(
                          //           "Leave Approval",
                          //           style: TextStyle(
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: 11.sp,
                          //               color: ColorUtils.WHITE),
                          //         ),
                          //       ),
                          //     )
                          // ),
                          isAClassTeacher()
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: TextFormField(
                        controller: _textController,
                        onChanged: (value) {
                          // var newValue = _isListening
                          //     ? toBeginningOfSentenceCase(
                          //             _textController.text.toLowerCase())
                          //         .toString()
                          //     : toBeginningOfSentenceCase(value.toLowerCase())
                          //         .toString();
                          var newValue = _isListening
                              ? _textController.text.toLowerCase().toString()
                              : value.toLowerCase().toString();
                          setState(() {
                            // newResult = widget.teacherClasses
                            //     .where((element) =>
                            //         element["class"].contains("${newValue}") ||
                            //         element["subjects"]
                            //             .contains("${(newValue)}"))
                            //     .toList();
                            newResult = widget.teacherClasses
                                .where((element) =>
                                    element["class"]
                                        .toString()
                                        .toLowerCase()
                                        .replaceAll(' ', '')
                                        .startsWith('${newValue}') ||
                                    element["class"]
                                        .toString()
                                        .toLowerCase()
                                        .startsWith('${newValue}') ||
                                    element["subjects"]
                                        .toString()
                                        .toLowerCase()
                                        .replaceAll(' ', '')
                                        .startsWith('${newValue}') ||
                                    element["subjects"]
                                        .toString()
                                        .toLowerCase()
                                        .startsWith('${newValue}'))
                                .toList();

                            print('------new---value----$newValue');
                            print('-w-h-e-r-e----element$newResult');
                          });
                        },
                        validator: (val) =>
                            val!.isEmpty ? 'Enter the Topic' : null,
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.grey),
                            hintText:
                                _isListening ? "Listening..." : "Search Here",
                            prefixIcon: const Icon(
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
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(2.0),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(230, 236, 254, 8),
                                  width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(230, 236, 254, 8),
                                  width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            fillColor: const Color.fromRGBO(230, 236, 254, 8),
                            filled: true),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    timeTableList(),

                    newResult.isEmpty && widget.teacherClasses.isEmpty
                            ? Expanded(child:
                    Center(child: Image.asset("assets/images/nodata.gif")))
                            : Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: _textController.text
                                            .toString()
                                            .isNotEmpty
                                        ? newResult.length
                                        : widget.teacherClasses.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return Container(
                                          margin: EdgeInsets.only(bottom: 8.h),
                                          child: GestureDetector(
                                            onTap: () {
                                              widget.teacherClasses[index][
                                                          "is_Class_teacher"] ==
                                                      null
                                                  ? NavigationUtils.goNext(
                                                      context,
                                                      NonTeacherStudentList(
                                                        name: widget.name,
                                                        images: widget.images,
                                                        school_id:
                                                            widget.school_id,
                                                        academic_year: widget
                                                            .academic_year,
                                                        selectedDate:
                                                            getCurrentDate(),
                                                        userId: widget.user_id,
                                                        // timeString: ourTimeTable[index]
                                                        // ["timeString"]
                                                        //     .replaceAll("[", " ")
                                                        //     .replaceAll("]", " "),
                                                        className: widget
                                                                .teacherClasses[
                                                            index]["class"],
                                                        curriculam_id:
                                                            widget.teacherClasses[
                                                                    index][
                                                                "curriculumId"],
                                                        session_id: widget
                                                                .teacherClasses[
                                                            index]["session_id"],
                                                        class_id: widget
                                                                .teacherClasses[
                                                            index]["class_id"],
                                                        batch_id: widget
                                                                .teacherClasses[
                                                            index]["batch_id"],
                                                      ))
                                                  : NavigationUtils.goNext(
                                                      context,
                                                      StudentListView(
                                                        name: widget.name,
                                                        images: widget.images,
                                                        school_id:
                                                            widget.school_id,
                                                        LoginedUserEmployeeCode:
                                                            widget
                                                                .LogedInUserEmpCode,
                                                        subjectName: _textController
                                                                .text
                                                                .toString()
                                                                .isNotEmpty
                                                            ? newResult[index]
                                                                ["subjects"]
                                                            : widget.teacherClasses[
                                                                    index]
                                                                ["subjects"],
                                                        ClassAndBatch:
                                                            _textController.text
                                                                    .toString()
                                                                    .isNotEmpty
                                                                ? newResult[
                                                                        index]
                                                                    ["class"]
                                                                : widget.teacherClasses[
                                                                        index]
                                                                    ["class"],
                                                        academic_year: widget
                                                            .academic_year,
                                                        selectedDate:
                                                            getCurrentDate(),
                                                        userId: widget.user_id,
                                                        // timeString: teacherClass[index]
                                                        // ["timeString"]
                                                        //     .replaceAll("[", " ")
                                                        //     .replaceAll("]", " "),
                                                        className: _textController
                                                                .text
                                                                .toString()
                                                                .isNotEmpty
                                                            ? newResult[index]
                                                                ["class"]
                                                            : widget.teacherClasses[
                                                                index]["class"],
                                                        curriculam_id: _textController
                                                                .text
                                                                .toString()
                                                                .isNotEmpty
                                                            ? newResult[index]
                                                                ["curriculumId"]
                                                            : widget.teacherClasses[
                                                                    index][
                                                                "curriculumId"],
                                                        session_id: _textController
                                                                .text
                                                                .toString()
                                                                .isNotEmpty
                                                            ? newResult[index]
                                                                ["session_id"]
                                                            : widget.teacherClasses[
                                                                    index]
                                                                ["session_id"],
                                                        class_id: _textController
                                                                .text
                                                                .toString()
                                                                .isNotEmpty
                                                            ? newResult[index]
                                                                ["class_id"]
                                                            : widget.teacherClasses[
                                                                    index]
                                                                ["class_id"],
                                                        batch_id: _textController
                                                                .text
                                                                .toString()
                                                                .isNotEmpty
                                                            ? newResult[index]
                                                                ["batch_id"]
                                                            : widget.teacherClasses[
                                                                    index]
                                                                ["batch_id"],
                                                      ));
                                            },
                                            child: width <= 580
                                                ? DefaultTimeTableView(
                                                    classAndBatch: _textController
                                                            .text
                                                            .toString()
                                                            .isNotEmpty
                                                        ? newResult[index]
                                                            ["class"]
                                                        : widget.teacherClasses[
                                                            index]["class"],
                                                    Subjects: _textController
                                                            .text
                                                            .toString()
                                                            .isNotEmpty
                                                        ? newResult[index]
                                                            ["subjects"]
                                                        : widget.teacherClasses[
                                                            index]["subjects"],
                                                    subcolor:
                                                        subColorList[index],
                                                    maincolor:
                                                        mainColorList[index],
                                                  )
                                                : HomeScreenTabView(
                                                    classAndBatch: _textController
                                                            .text
                                                            .toString()
                                                            .isNotEmpty
                                                        ? newResult[index]
                                                            ["class"]
                                                        : widget.teacherClasses[
                                                            index]["class"],
                                                    Subjects: _textController
                                                            .text
                                                            .toString()
                                                            .isNotEmpty
                                                        ? newResult[index]
                                                            ["subjects"]
                                                        : widget.teacherClasses[
                                                            index]["subjects"],
                                                    subcolor:
                                                        subColorList[index],
                                                    maincolor:
                                                        mainColorList[index],
                                                  ),
                                          ));
                                    })),
                    SizedBox(
                      height: 145.h,
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget timeTableForTheDay(
          String batchName, String subject, Color mainColor, Color subColor) =>
      Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
            width: 333.w,
            height: 70.h,
            decoration: BoxDecoration(
                color: mainColor, borderRadius: BorderRadius.circular(8.r)),
            child: Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      color: subColor,
                      borderRadius: BorderRadius.all(Radius.circular(50.r))),
                  child: Center(
                    child: Text(
                      batchName,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 250.w,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      subject,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: ColorUtils.WHITE),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );

  Widget _defaultTimeTable(
          String batchName, String subject, Color mainColor, Color subColor) =>
      Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
            width: 333.w,
            height: 70.h,
            decoration: BoxDecoration(
                color: mainColor, borderRadius: BorderRadius.circular(8.r)),
            child: Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      color: subColor,
                      borderRadius: BorderRadius.all(Radius.circular(50.r))),
                  child: Center(
                    child: Text(
                      batchName,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 250.w,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      subject,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: ColorUtils.WHITE),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );

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

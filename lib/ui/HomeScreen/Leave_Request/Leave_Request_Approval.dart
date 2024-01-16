
import 'dart:async';
import 'dart:io' as io;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;
import '../../../exports.dart';
import '../../History/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
class leaverequestapproval extends StatefulWidget {
  var roleUnderLoginTeacher;
  var teacherClasses;
  String? academic_year;
  var studentimage;
  var newTeacherData;
  var loginedUserName;
  String? images;
  String? name;
  var studentNAME;
  var studentADMNO;
  var classANDbatch;
  var studenTID;
  var sTUDENTCLASSNAME;
  var studentBatch;
  var sessionIDSS;
  var curriculamIDSS;
  var classIDSS;
  var batchIDSS;
  var curriculamNAmeess;
  var sessionNAmeess;
  var teacherData;
  leaverequestapproval(
      {Key? key,
      this.teacherData,
      this.teacherClasses,
      this.images,
      this.newTeacherData,
      this.studentimage,
      this.academic_year,
      this.classIDSS,
      this.batchIDSS,
      this.curriculamNAmeess,
      this.sessionNAmeess,
      this.sessionIDSS,
      this.curriculamIDSS,
      this.sTUDENTCLASSNAME,
      this.studentBatch,
      this.studenTID,
      this.classANDbatch,
      this.studentADMNO,
      this.studentNAME,
      this.name,
      this.loginedUserName,
      this.roleUnderLoginTeacher})
      : super(key: key);

  @override
  State<leaverequestapproval> createState() => _leaverequestapprovalState();
}

class _leaverequestapprovalState extends State<leaverequestapproval> {
  // FilePickerResult? result;
  int Count = 0;
  Map<String, dynamic>? notificationResult;
  Timer? timer;
  var result;
  String fileName = '';
  var fromDate = 'DD-MM-YYYY';
  var toDate = 'DD-MM-YYYY';
  DateFormat _examformatter = DateFormat('dd-MM-yyyy');
  DateFormat _examFFormatter = DateFormat('yyyy-MM-dd');
  var _leaveReasonController = new TextEditingController();
  io.File file = io.File(' ');
  bool isSpinner = false;
  bool _buttonloading = false;
  final dio = Dio();
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
  var count;
  DateTime? pickedFrom;
  DateTime? pickedTo;
  var filepathname;
  bool fileloading = false;

  uploadFile() async {
    print('fn callim');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var userID = preferences.getString('userID');
      var postUri = Uri.parse(ApiConstants.Fileupload);
      var request = new http.MultipartRequest("POST", postUri);
      request.fields['userPath'] = '$userID/leaveDocs/';
      request.files.add(new http.MultipartFile.fromBytes('file', await file.readAsBytes(), ));

      request.send().then((response) {
        print('response.......$response');
        if (response.statusCode == 200) print("Uploaded!");
      });
    }catch(e){
      print(e);
    }

  }

  Future<void>fileimageupload()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var request = http.MultipartRequest('POST', Uri.parse('https://teamsqa4000.educore.guru/server-uploads'));
    request.fields.addAll({
      'userPath': '/$userID/leaveDocs/'
    });
    request.files.add(await http.MultipartFile.fromPath('file',file.path,contentType: MediaType.parse(lookupMimeType('${file.path}')!)));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('----------------------');
      print(await response.stream.bytesToString());
      print('------------------');
    }
    else {
      print(response.reasonPhrase);
    }
  }

  filesaver()async{
    // setState(() {
    //   fileloading = true;
    // });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    String fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName,contentType: MediaType.parse(lookupMimeType('${file.path}')!)),
    'userPath':  '$userID/leaveDocs/'
    });
    print('...,,,,,,${fileName}');
    final response = await dio.post(ApiConstants.Fileupload, data: formData,);
    //filepathname = response;

    print(response.statusCode);
    if(response.statusCode == 200){
      setState(() {
        filepathname = response;
        print('filepathname-----$filepathname');
        fileloading = false;
      });

    }

    print('resppponce-----$response');

  }

  submitleavestudents()async{

    setState(() {
      isSpinner = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var schoolID = preferences.getString('school_id');
    var academicyear = preferences.getString('academic_year');
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    // if(file!= null){
    //   List<int> imageBytes = file.readAsBytesSync();
    //   String baseimage = base64Encode(imageBytes);
    //  }

    var body = {
    "classes": {
    "session_id": widget.sessionIDSS,
    "session_name": widget.sessionNAmeess,
    "curriculum_id": widget.curriculamIDSS,
    "curriculum_name": widget.curriculamNAmeess,
    "class_id": widget.classIDSS,
    "class_name": widget.sTUDENTCLASSNAME.toString().split(" ")[0] ,
    "batch_id": widget.batchIDSS,
    "batch_name": widget.sTUDENTCLASSNAME.toString().split(" ")[1],
    },
    "student": {
    "_id": widget.studenTID,
    "name": widget.studentNAME,
    },
    "reason": _leaveReasonController.text,
    "academic_year": academicyear,
    "startDate": DateFormat('dd-MM-yyyy').format(DateTime.parse(_examFFormatter.format(pickedFrom!))),
    "endDate": DateFormat('dd-MM-yyyy').format(DateTime.parse(_examFFormatter.format(pickedTo!))),
    "school_id": schoolID,
    "submittedBy": userID,
    "submittedRoleId": "teacher",
    "studentId": widget.studenTID,
    "documentPath":file != null ? filepathname.toString(): '',
    // "documentPath":(file != null)?file.path:'ikjuhikj',
    };
   log('--bo--dyyy---${body}');
    var request = await http.post(Uri.parse(ApiConstants.LeaveRequestCreate),
        headers: headers, body: json.encode(body));
    print(request.body);
    var response = json.decode(request.body);
    if (response['status']['code'] == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           content: Text('${response['data']['message']}'),backgroundColor: Colors.green,));
    }
    print('-__--__--__--${response['data']['message']}');
    setState(() {
      isSpinner = false;
    });
  }


  void initState() {
    getNotification();
    // isAClassTeacher();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    super.initState();
  }
  @override
  void didUpdateWidget(covariant leaverequestapproval oldWidget) {
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

  Future<Null> _selectFromDate(BuildContext context) async
  {
    pickedFrom = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: new DateTime.now(),
      // lastDate: new DateTime(2025),
      lastDate:  DateTime(DateTime.now().year + 1),
    );
    fromDate = _examformatter.format(pickedFrom!);
    print(fromDate);
  setState(() {
    toDate = 'DD-MM-YYYY';
  });
  }
  Future<Null> _selectToDate(BuildContext context) async
  {
    print(pickedFrom);
    pickedTo = await showDatePicker(
      context: context,
      initialDate: pickedFrom!.add(Duration(days: 0)),
      firstDate: pickedFrom!.add(Duration(days: 0)),
      // lastDate: new DateTime(2025),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    toDate = _examformatter.format(pickedTo!);
  }
  // Future<Null> _selectedFromDate(BuildContext context)async
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.BACKGROUND,
      body: ListView(
        // physics: NeverScrollableScrollPhysics(),
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
                          name: widget.loginedUserName,
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
                margin: EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w,),
                // height: 640.h,
                height: MediaQuery.of(context).size.height-110,
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
                            Text('Leave Apply',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                            SizedBox(
                              width: 120.w,
                            ),
                            // Row(
                            //   children: [
                            //     SizedBox(
                            //       width: 20.w,
                            //       height: 20.h,
                            //       child: Image.asset(
                            //           "assets/images/studentCalender.png"),
                            //     ),
                                // SizedBox(
                                //   width: 5.w,
                                // ),
                                // Text(
                                //   widget.selectedDate.toString(),
                                //   style: TextStyle(fontSize: 12.sp),
                                // ),
                                // SizedBox(
                                //   width: 5.w,
                                // ),
                                // widget.timeString == null ? Text(" ") : Text(
                                //     widget.timeString.toString().split("-")[0],
                                //     style: TextStyle(fontSize: 12.sp))
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5,0,20,10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Center(
                              child: Container(
                                width: 150.w,
                                height: 150.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Color(0xFFD6E4FA)),

                                ),
                                child:ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fill,
                                    imageUrl: ApiConstants.IMAGE_BASE_URL +"${widget.studentimage}",
                                    placeholder: (context, url) => Center(
                                      child: Text(
                                        '${widget.studentNAME!.split(' ')[0].toString()[0]}${widget.studentNAME.split(' ')[1].toString()[0]}',
                                        style: TextStyle(
                                            color: Color(0xFFB1BFFF),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>   Center(
                                      child: Text(
                                        '${widget.studentNAME!.split(' ')[0].toString()[0]}${widget.studentNAME.split(' ')[1].toString()[0]}',
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
                              height: 20.h,
                            ),
                            Center(child: Text(widget.studentNAME,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w700),)),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                'Admission No : ${widget.studentADMNO}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),
                            ),),
                            SizedBox(
                              height: 15.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                'Class : ${widget.sTUDENTCLASSNAME}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),
                              ),),
                            SizedBox(
                              height: 5.h,
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: 5.w),
                              child: Row(
                                children: [
                                  Text('From : ${fromDate}',style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600)),
                                  IconButton( icon: Icon(Icons.calendar_month,color: Colors.blue[900],size: 20,),
                                    onPressed: (){
                                      _selectFromDate(context);
                                    },),
                                  // SizedBox(
                                  //   width: 5.w,
                                  // ),
                                  Text('To : ${toDate}',style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600)),
                                  IconButton( icon: Icon(Icons.calendar_month,color: Colors.blue[900],size: 20,),
                                  onPressed: (){
                                    _selectToDate(context);
                                  },)
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text('Reason',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600)),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextFormField(
                                maxLength: 60,
                                validator: (val) =>
                                val!.isEmpty ? '  *Enter the Reason' : null,
                                controller: _leaveReasonController,
                                cursorColor: Colors.grey,
                                decoration: dropTextFieldDecoration,
                                keyboardType: TextInputType.text,
                                maxLines: 5,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(primary: Colors.grey,),
                                    onPressed: () async{
                                      setState(() {
                                        _buttonloading = true;
                                      });
                                      result = await FilePicker.platform.pickFiles(allowMultiple: true );
                                      if (result == null) {
                                        print("No file selected");
                                      } else {
                                        setState(() {
                                        });
                                        print("No file selected${result}");
                                        file = io.File(result.files.single.path);
                                        fileName = file.path.split('/').last;
                                        print('file.path${file.path}');
                                        print('file.fileNameh${fileName}');
                                        print(lookupMimeType('${file.path}'));
                                        if (file != null){
                                          await filesaver();
                                          // uploadFile();
                                          // fileimageupload();
                                        }
                                        // result?.files.forEach((element) {
                                        //   print('elementttname${element.name}');
                                        //   print('elementttname${element}');
                                        //   File file = File(element);
                                        //   print(file.path);
                                        // });
                                      }
                                      setState(() {
                                        _buttonloading = false;
                                      });
                                    },
                                    child:  Container(
                                      width: 90.w,
                                      child: Row(
                                        children: [
                                          Icon(Icons.attach_file_outlined,size: 20,),
                                          SizedBox(width: 2.w,),
                                          Text('Attach File',style: TextStyle(fontSize: 12),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                (fileloading = true) ?Container(
                                    width: 180.w,
                                    child:  Text(fileName,style: TextStyle(fontSize: 12),)):
                                Container(
                                    width: 180.w,
                                    child:  Text('No File Selected',style: TextStyle(fontSize: 12),)),
                              ],
                            ),
                            SizedBox(height: 20.h,),
                            Row(
                              children: [
                                SizedBox(
                                  width: 75.w,
                                ),
                                _buttonloading? Container(
                                    height: 40.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(color: Colors.red,),
                                      ),
                                    )) :  GestureDetector(
                                  onTap:(){
                                    if(pickedFrom == null){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select From Date'),backgroundColor: Colors.red,));
                                    }else if(pickedTo == null){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select To Date'),backgroundColor: Colors.red,));
                                    }else
                                    if(_leaveReasonController.text.isEmpty){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter the reason'),backgroundColor: Colors.red,));
                                    }else{
                                      if (result == null) {
                                        print("No file selected");
                                        submitleavestudents();
                                      }else if(result != null && filepathname == null){
                                        return;
                                      }else{
                                        submitleavestudents();
                                      }
                                      print('..............$fileloading');

                                    }
                                },
                                  child: Container(
                                      height: 40.h,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Apply',
                                          style:
                                          TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                      height: 40.h,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Cancel',
                                          style:
                                          TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      )),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 250.h,
                      // ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../Network/api_constants.dart';
import '../../../Utils/color_utils.dart';
import '../../../exports.dart';
import '../../History/constant.dart';

import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;
import 'All_leave.dart';
import 'Approved_leave.dart';
import 'Leave_Approval.dart';
import 'image_viewer.dart';

class leaveApproval extends StatefulWidget {
  String? images;
  String? name;
  String? timeString;
  String? selectedDate;
  var loginname;
  bool? drawer;
  leaveApproval(
      {this.images,
      this.selectedDate,
      this.timeString,
      this.loginname,
      this.name,
      this.drawer,
      Key? key})
      : super(key: key);

  @override
  State<leaveApproval> createState() => _leaveApprovalState();
}

class _leaveApprovalState extends State<leaveApproval> {
  int Count = 0;
  bool isSpinner = false;
  int _selectedIndex = 0;
  bool widgetLoader = false;
  Map<String, dynamic>? notificationResult;
  Timer? timer;
  // bool _drawer = false;
  bool keyboardEnabled = false;
  var studentDataasforleave = [];
  var leaveapprovelist = [];
  var academicYEAR;
  var leaveId;
  var _reasontextController = new TextEditingController();
  var approve;
  var approved;
  var reject;
  var rejected;
  List<Map> leaveapproallist = [];
  bool _isListening = false;
  List newResult = [];
  List<Map> _pages = [];
  var _searchController = TextEditingController();
  //for adding data in leaveapprovallist
  var nAME;
  var fromDATE;
  var toDATE;
  var totalDAYS;
  var cLASSES;
  var bATCHES;
  var leaveREASON;
  var appliedDATE;
  var adMISSIONnO;
  var lEAVEiD;
  var aCADEMICyEAR;
  var sTUDiMAGE;
  var nodata = ' ';
  String? rollidpref;
  var rollidprefname;
  DateFormat _examformatter = DateFormat('dd/MM/yyyy');
  getPreferenceData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // count = preferences.get("count");
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
      // print('rollidprefname[i]${rollidprefname[i]}');
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
        print('....notificationResult$notificationResult');
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

  Map<String, dynamic>? leaveData;
  // _navigator() {
  //   for(var i = 0; i<rollidprefname.length; i++){
  //
  //     print('rollidprefname[i]${rollidprefname[i]}');
  //     if(rollidprefname[i] == 'Teacher'||rollidprefname[i] == 'Principal' || rollidprefname[i] == 'Vice Principal' || rollidprefname[i] == 'HOS' || rollidprefname[i] == 'HOD'|| rollidprefname[i] == 'Supervisor'){
  //       // setState(() {
  //       //   _drawer = true;
  //       // });
  //       print('-------drawerrrr1$_drawer');
  //       if( rollidprefname[i] == 'Teacher'){
  //         setState(() {
  //           _drawer = false;
  //         });
  //         print('-------drawerrrr2$_drawer');
  //         // Navigator.of(context).pop();
  //         break;
  //       }else
  //         {
  //
  //           setState(() {
  //             _drawer = true;
  //           });
  //           print('-------drawerrrr3$_drawer');
  //           // break;
  //         }
  //
  //       // ZoomDrawer.of(context)!.toggle();
  //       // break;
  //     }
  //     // else if( rollidprefname[i] == 'Teacher'){
  //     //
  //     //   print('-------drawerrrr4$_drawer');
  //     //   setState(() {
  //     //     _drawer = false;
  //     //   });
  //     //   // Navigator.of(context).pop();
  //     //   break;
  //     // };
  //
  //   print('-------drawerrrr5$_drawer');};
  // }
  Future getleavedata() async {
    print('callingdetdata');
    setState(() {
      leaveapprovelist = [];
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
    print('-b_b-o_o-d_d-y_y$body');
    var request = await http.post(Uri.parse(ApiConstants.LeaveApproval),
        headers: headers, body: json.encode(body));
    var response = json.decode(request.body);
    // print('------------api response---------------$response');
    leaveData = response;
    print('------------api response---------------$leaveData');
    studentDataasforleave = leaveData!['data']['pendings'];
    _pages = [
      {
        "page": LeaveApprovall(studentDataasforleave: leaveData!['data']['pendings'])
      },
      {
        "page": ApprovedLeave(studentDataasforleave: leaveData!['data']['apprved_or_rejected'])
      },
      {
        "page": All_Leave(studentDataasforleave: leaveData!['data']['allLeaves'])
      },
    ];
    if (studentDataasforleave.isEmpty) {
      setState(() {
        widgetLoader = true;
        isSpinner = false;
      });
      nodata = 'No Data';
    }

    // academicYEAR = studentDataasforleave[0]['academic_year'];
    // leaveId = studentDataasforleave[i]['academic_year'];
    print(
        '------------studentDataasforleave---------------${studentDataasforleave}');
    // print(
        // '------------studentDataasforleaveacc---------------${studentDataasforleave[0]['academic_year']}');
    // for (var i=0; i<studentDataasforleave.length; i++){
    //   //print('${leaveData[i][]}')
    //   print('runtimetype-------${studentDataasforleave[i]['applyDate'].runtimeType}');
    // }

    // for (var i = 0; i < studentDataasforleave.length; i++) {
    //   if (studentDataasforleave[i]['studentName'] != null &&
    //       studentDataasforleave[i]['class'] != null &&
    //       studentDataasforleave[i]['batch'] != null &&
    //       studentDataasforleave[i]['applyDate'] != null &&
    //       // int.parse(studentDataasforleave[i]['days']) < 4 &&
    //       studentDataasforleave[i]['status'] == 'pending') {
    //     leaveapprovelist.add({
    //       "class": studentDataasforleave[i]['class'],
    //       "admissionnumber": studentDataasforleave[i]['admission_number'],
    //       "batch": studentDataasforleave[i]['batch'],
    //       "days": studentDataasforleave[i]['days'],
    //       "endDate": studentDataasforleave[i]['endDate'],
    //       "studentname": studentDataasforleave[i]['studentName'],
    //       "startDate": studentDataasforleave[i]['startDate'],
    //       "applyDate": studentDataasforleave[i]['applyDate'],
    //       "academic_year": studentDataasforleave[i]['academic_year'],
    //       "leaveid": studentDataasforleave[i]['_id'],
    //       "reason": studentDataasforleave[i]['reason'],
    //       "profileImage": studentDataasforleave[i]['profileImage'] ?? ' ',
    //       "documentPath": studentDataasforleave[i]['documentPath'] ?? ' ',
    //     });
    //   }
    //
    //   // print('reason${studentDataasforleave[i]['reason']}');
    //   // print('_id${studentDataasforleave[i]['_id']}');
    //   // print('academic_year${studentDataasforleave[i]['academic_year']}');
    //   // print('applyDate${studentDataasforleave[i]['applyDate']}');
    //   // print('startDate${studentDataasforleave[i]['startDate']}');
    //   // print('studentName${studentDataasforleave[i]['studentName']}');
    //   // print('endDate${studentDataasforleave[i]['endDate']}');
    //   // print('days${studentDataasforleave[i]['days']}');
    //   // print('batch${studentDataasforleave[i]['batch']}');
    //   // print('admission_number${studentDataasforleave[i]['admission_number']}');
    //   // print('class${studentDataasforleave[i]['class']}');
    // }
    // print('leaveapprovelist-----------$leaveapprovelist');
    setState(() {
      newResult = studentDataasforleave;
    });
    // newResult = leaveapprovelist;
    print('newResult-----------$newResult');
    if (newResult.isEmpty) {
      nodata = 'No Data';
    }
    setState(() {
      widgetLoader = true;
      isSpinner = false;
    });
  }

  Future submitleavedata(
      {String? acadYEAR,
      String? leaveIds,
      String? apprve,
      String? approved,
      String? Approved,
      String? Approve,
      }) async {
    setState(() {
      isSpinner = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var schoolID = preferences.getString('school_id');
    var academicyear = preferences.getString('academic_year');
    print("____---shared$schoolID");
    print("____---user$userID");
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var body = {
      "user_id": userID,
      "school_id": schoolID,
      "academic_year": acadYEAR,
      "leaveID": leaveIds,
      "approvedBy": userID,
      "actionItem": {
        "actionItem": apprve,
        // "actionItem": Approve,
        // "actionstatus": Approved,
        "actionstatus": approved,
        "commentItem": _reasontextController.text
      },
      "commentItem": _reasontextController.text
    };
    print('---b-o-d-y-lleeaavve--${body}');
    var request = await http.post(Uri.parse(ApiConstants.LeaveApprovalRequest),
        headers: headers, body: json.encode(body));
    var response = json.decode(request.body);
    if (response['status']['code'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response['data']['message']}'),
      ));
    }

    //log('----------reqbdyy${request.body}');
    log('----------rsssssbdyy${response}');
    setState(() {
      isSpinner = false;
    });
  }
  Future<void> _initialize() async {
    // await getleavedata();
    await getNotification();
    // _navigator();
  }
  Future<dynamic> _checkKeyboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? data = prefs.getBool("keyboard");
    if (data != null) {
      setState(() {
        keyboardEnabled = true;
      });
    } else {
      setState(() {
        keyboardEnabled = false;
      });
    }
  }

  Future<void> _pageInit() async {
    await _checkKeyboard();
    if (!keyboardEnabled) {
      await getleavedata();
    }
  }
  void initState() {
    _initialize();
    print('leaveeeee');
    // getleavedata();
    // getNotification();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    super.initState();
  }

  var count;

  @override
  void didUpdateWidget(covariant leaveApproval oldWidget) {
    _pageInit();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => getPreferenceData());
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _pageInit();
    super.didChangeDependencies();
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
                        onTap: () {
                          // print('------------------$_drawer');
                          widget.drawer! ? ZoomDrawer.of(context)!.toggle() : Navigator.of(context).pop()  ;
                        },
                        child:
                        Container(
                            margin: const EdgeInsets.all(6),
                            child:
                            widget.drawer! ? Image.asset("assets/images/newmenu.png") : Image.asset("assets/images/goback.png")   )
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
                        child:badges.Badge(
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
                              GestureDetector(
                                onTap: () {
                                  setState(() => _selectedIndex = 0);
                                },
                                child: Container(
                                    height: 40.h,
                                    width: 90.w,
                                    decoration: BoxDecoration(
                                        color: _selectedIndex == 0 ? Colors.red[500] : Colors.grey[500],
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                          'Approval',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                              color: ColorUtils.WHITE),
                                        ))),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _selectedIndex = 1);

                                },
                                child: Container(
                                  height: 40.h,
                                  width: 150.w,
                                  decoration: BoxDecoration(
                                      color: _selectedIndex == 1 ? Colors.red[500] : Colors.grey[500],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "Approved/Rejected",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          color: ColorUtils.WHITE),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _selectedIndex = 2);

                                },
                                child: Container(
                                  height: 40.h,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                      color: _selectedIndex == 2 ? Colors.red[500] : Colors.grey[500],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "All",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          color: ColorUtils.WHITE),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        isSpinner
                            ? Container()
                            : widgetLoader
                            ? _pages[_selectedIndex]['page'] as Widget
                            : Container(),

                        SizedBox(
                          height: 150.h,
                        )
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

  Widget _leaveApproval(
          {String? studimage,
          int? i,
          String? leaveId,
          String? document,
          bool? mypendings,
          String? academicyear,
          String? admissionNuMber,
          String? studentNAme,
          String? fromdate,
          String? todate,
          int? totaldays,
          String? classNaMe,
          String? batchNaMe,
          String? leavereason,
          String? applieddate}) =>
      Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          // Divider(color: Colors.black26,height: 2.h,),

          GestureDetector(
            onTap: () async {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back_outlined)),
                      SizedBox(
                        width: 35.w,
                      ),
                      Text(
                        'Leave Approval',
                        style: TextStyle(fontSize: 22.sp),
                      ),
                    ],
                  ),
                  content: Container(
                    height: attchIconsize(type: document.toString().split(".").last),
                    // width: 300.w,
                    child: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(studentNAme!, style: TextStyle(fontSize: 18.sp)),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text('Class: ${classNaMe! + " " + batchNaMe!}',
                              style: TextStyle(fontSize: 14)),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text('Reason : ${leavereason!}',
                              style: TextStyle(fontSize: 14)),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                              "Applied On: ${applieddate!.split('T')[0].split('-').last}-${applieddate.split('T')[0].split('-')[1]}-${applieddate.split('T')[0].split('-').first}",
                              style: TextStyle(fontSize: 14)),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              Text(
                                // "From: ${fromdate!.split('T')[0]}",
                                "From: ${fromdate!.split('T')[0].split('-').last}-${fromdate.split('T')[0].split('-')[1]}-${fromdate.split('T')[0].split('-').first}",
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                width: 40.w,
                              ),
                              Text(
                                "To: ${todate!.split('T')[0].split('-').last}-${todate.split('T')[0].split('-')[1]}-${todate.split('T')[0].split('-').first}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          (document != null)
                              ? Row(
                                  children: [
                                    Text('Document :',
                                        style: TextStyle(fontSize: 14)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => imageviewer(
                                                document: document,
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        height: 100.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(ApiConstants
                                                        .IMAGE_BASE_URL +
                                                    "${document}")),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        // child: CachedNetworkImage(
                                        //   imageUrl: ApiConstants.IMAGE_BASE_URL +"${document}",
                                        //   placeholder: (context, url) => Text(
                                        //     '',
                                        //     style: TextStyle(
                                        //         color: Color(0xFFB1BFFF),
                                        //         fontWeight: FontWeight.bold,
                                        //         fontSize: 20),
                                        //   ),
                                        //   errorWidget: (context, url, error) =>   Text(
                                        //     '',
                                        //     style: TextStyle(
                                        //         color: Color(0xFFB1BFFF),
                                        //         fontWeight: FontWeight.bold,
                                        //         fontSize: 20),
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          // if(int.parse(totaldays!) < 4)
                          Text(
                            'Remarks',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          // if(int.parse(totaldays) < 4)
                          TextFormField(
                            maxLength: 150,
                            validator: (val) =>
                                val!.isEmpty ? '  *Enter the Reason' : null,
                            controller: _reasontextController,
                            cursorColor: Colors.grey,
                            decoration: dropTextFieldDecoration,
                            keyboardType: TextInputType.text,
                            maxLines: 5,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 40.w,
                              ),
                              // if(int.parse(totaldays!) < 4)
                              GestureDetector(
                                onTap: () {
                                  print('approvedddddddd');
                                  Navigator.pop(context);
                                  submitleavedata(
                                          acadYEAR: academicyear,
                                          leaveIds: leaveId,
                                          apprve: 'Approve',
                                          // Approve: 'Approve',
                                          // Approved: 'Approved',
                                          approved: 'Approved',
                                  )
                                      .then((_) => getleavedata());
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => leaveApproval(
                                  //           images: widget.images,
                                  //           name: widget.name,
                                  //         )));
                                  _reasontextController.clear();
                                },
                                child: Container(
                                    height: 40.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Approve',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    )),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              // if(int.parse(totaldays) < 4)
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  submitleavedata(
                                          acadYEAR: academicyear,
                                          leaveIds: leaveId,
                                          apprve: 'Reject',
                                          approved: 'Rejected')
                                      .then((_) => getleavedata());
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => leaveApproval(
                                  //           images: widget.images,
                                  //           name: widget.name,
                                  //         )));
                                  _reasontextController.clear();
                                },
                                child: Container(
                                    height: 40.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Reject',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              padding: EdgeInsets.fromLTRB(5, 20, 10, 10),
              width: MediaQuery.of(context).size.width,
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
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFFD6E4FA)),
                        ),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                ApiConstants.IMAGE_BASE_URL + "${studimage}",
                            placeholder: (context, url) => Text(
                              '${studentNAme!.split(' ')[0].toString()[0]}${studentNAme.split(' ')[1].toString()[0]}',
                              style: TextStyle(
                                  color: Color(0xFFB1BFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            errorWidget: (context, url, error) => Text(
                              '${studentNAme!.split(' ')[0].toString()[0]}${studentNAme.split(' ')[1].toString()[0]}',
                              style: TextStyle(
                                  color: Color(0xFFB1BFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   child:Container(
                      //       width: 50.w,
                      //       height: 50.h,
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         border: Border.all(color: Color(0xFFD6E4FA)),
                      //         image: DecorationImage(
                      //           image: NetworkImage(studimage == ""
                      //               ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                      //               : ApiConstants.IMAGE_BASE_URL +
                      //                   "${studimage}"),
                      //         ),
                      //       ),
                      //     ),
                      //   ),

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
                                style: TextStyle(fontSize: 13),
                              )),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              Text(
                                admissionNuMber!,
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(
                                width: 60.w,
                              ),
                              Text(
                                'Class: ${classNaMe! + " " + batchNaMe!}',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: [
                              Text(
                                "From: ${fromdate!.split('T')[0].split('-').last}-${fromdate.split('T')[0].split('-')[1]}-${fromdate.split('T')[0].split('-').first}",
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "To: ${todate!.split('T')[0].split('-').last}-${todate.split('T')[0].split('-')[1]}-${todate.split('T')[0].split('-').first}",
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Center(
                                    child: Text(
                                  '$totaldays',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13),
                                )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          (document != null)
                              ? Row(
                                  children: [
                                    Text('Document :'),
                                    Container(
                                      height: 50.h,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  ApiConstants.IMAGE_BASE_URL +
                                                      "${document}")),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      // child: CachedNetworkImage(
                                      //   imageUrl: ApiConstants.IMAGE_BASE_URL +"${document}",
                                      //   placeholder: (context, url) => Text(
                                      //     '',
                                      //     style: TextStyle(
                                      //         color: Color(0xFFB1BFFF),
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 20),
                                      //   ),
                                      //   errorWidget: (context, url, error) =>   Text(
                                      //     '',
                                      //     style: TextStyle(
                                      //         color: Color(0xFFB1BFFF),
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 20),
                                      //   ),
                                      // ),
                                    ),
                                  ],
                                )
                              : Container(),
                          if(mypendings == true)
                            Padding(
                              padding: const EdgeInsets.only(left: 140),
                              child: Container(
                                  height: 40.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      color: Colors.red[500],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                            color: ColorUtils.WHITE),
                                      ))),
                            ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      );
  double attchIconsize({String? type, String? document}) {
    if (type == 'jpg' || type == 'jpeg' || type == 'png') {
      return 500.h;
    } else if (type == 'pdf') {
      return 400.h;
    } else {
      return 400.h;
    }
  }
}

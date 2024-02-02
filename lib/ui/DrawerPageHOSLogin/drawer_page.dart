import 'dart:developer';

import 'package:matomo_tracker/matomo_tracker.dart';

import '../../Database/database_helper.dart';
import '../../Database/database_model.dart';
import '../../exports.dart';
import '../HomeScreen/Leave_Approval/leave_approval.dart';
import '../Leadership/Leadership.dart';
import '../Report/report_list_view.dart';
import 'menu_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:convert';
import 'menu_page.dart';

class DrawerPageForHos extends StatefulWidget {
  String? userId;
  String? HOSID;
  String? HOSNAME;
  String? loginedUserEmployeeNo;
  String? loginedUserName;
  var designation;
  String? schoolId;
  String? images;
  String? email;
  String? academic_year;
  var roleUnderHos;
  var Empcodee;
  var isAClassTeacher;
  var role_id;
  var loginname;
  var loginroleid;
  bool? admin;
  var loginRoleid;
  DrawerPageForHos(
      {Key? key,
      this.loginedUserName,
      this.loginname,
      this.loginRoleid,
      this.admin,
      this.loginroleid,
      this.HOSNAME,
      this.designation,
      this.userId,
      this.HOSID,
      this.role_id,
      this.Empcodee,
      this.loginedUserEmployeeNo,
      this.schoolId,
      this.images,
      this.email,
      this.academic_year,
      this.roleUnderHos,
      this.isAClassTeacher})
      : super(key: key);

  @override
  _DrawerPageForHosState createState() => _DrawerPageForHosState();
}

class _DrawerPageForHosState extends State<DrawerPageForHos> {
  final drawerController = ZoomDrawerController();
  MenuItem currentItem = MenuItems.Leadership;
  //late List<LoginData> loginData;

  @override
  void initState() {
    // print('role_iddrawerpAGEHOS${widget.role_id}');
    print('11111111111111');
    // print('userIdwidget${widget.userId}');
    print('userIdEmp${widget.Empcodee}');
    MatomoTracker().initialize(
      siteId: 5,
      url: 'https://log.bmark.in/',
      visitorId: widget.email,
    );

    log("${widget.isAClassTeacher}");
    // print(widget.email);
    // getUserLoginCredentials();
    super.initState();
  }

  logData() {
    print("log created");
  }

  // isDataExist(){
  //   if(loginData == null){
  //     print("data not exist");
  //     getUserLoginCredentials();
  //   }else{
  //     print("data exist");
  //   }
  // }

  var classB = [];
  var teacherData = [];
  var duplicateTeacherData = [];
  var newTeacherData;
  String? img;
  bool isSpinner = false;

  Map<String, dynamic>? loginCredential;

  var employeeUnderHOS = [];

  Future addToLocalDb() async {
    print("database created");

    String newTeacherData = jsonEncode(teacherData);
    String newEmployeeData = jsonEncode(employeeUnderHOS);
    String newOtherTeacherData = jsonEncode(classB);
    print("newEmployeeData${newEmployeeData}");
    final loginData = LoginData(
        onlyTeacherData: newTeacherData,
        otherTeacherData: newOtherTeacherData,
        employeeUnderHead: newEmployeeData);
    await LoginDatabase.instance.create(loginData);
  }

  getCurrentDate() {
    final DateFormat formatter = DateFormat('d-MMMM-y');
    String createDate = formatter.format(DateTime.now());
    return createDate;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        controller: drawerController,
        style: DrawerStyle.Style1,
        mainScreen:Stack(
          children: [
            getScreen(),
            // Positioned(
            //   bottom: 10,
            //   right: 10,
            //   child: FloatingActionButton(onPressed:(){},child: Text('+'),
            //   ),
            // ),
          ],
        ),
        menuScreen: Builder(builder: (context) {
          return MenuPage(
              loginname:widget.loginname,
              ptofileImage: widget.images,
              name: widget.loginedUserName,
              currentItem: currentItem,
              isAClassTeacher: widget.isAClassTeacher,
              onSelected: (item) {
                setState(() {
                  currentItem = item;
                });
                ZoomDrawer.of(context)!.close();
              });
        }),
        borderRadius: 24.r,
        showShadow: true,
        angle: 0.0,
        backgroundColor: ColorUtils.BLUE,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.easeInBack,
      ),
    );
  }

  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.Leadership:
        return LeadershipListView(
          HOSNAME:widget.HOSNAME,
          loginname:widget.loginname,
          roleUnderLoginTeacher: widget.roleUnderHos,
          teachername: widget.loginedUserName,
          image: widget.images,
          usrId: widget.userId,
          role_id: widget.role_id,
          Empcodee: employeeUnderHOS,
          admin:widget.admin,
          loginRoleid: widget.loginRoleid ,
        );
      case MenuItems.Reports:
        return ReportListView(
          HOSNAME:widget.HOSNAME,
          loginname:widget.loginname,
          HOSID:widget.HOSID,
          Empcodee: widget.roleUnderHos,
          teacherName: widget.loginedUserName,
          image: widget.images,
        );
      case MenuItems.Leave:
        return  leaveApproval(
          images: widget.images,
          name: widget.loginname?? widget.loginedUserName,
          loginname:widget.loginname,
          selectedDate: getCurrentDate(),
          drawer: true,
        );
      // case MenuItems.activities:
      //   return ActivityListView(
      //     name: widget.name,
      //     EmployeeCode: widget.loginedUserEmployeeNo,
      //   );
      // case MenuItems.reports:
      //   return ReportListView(
      //     roleUnderLoginTeacher: employeeUnderHOS,
      //     teacherName: widget.name,
      //   );
      // case MenuItems.profile:
      //   return ProfilePage();
      default:
        return ReportListView(
          HOSNAME:widget.HOSNAME,
          HOSID:widget.HOSID,
          loginname:widget.loginname,
          Empcodee: employeeUnderHOS,
          teacherName: widget.loginedUserName,
          image: widget.images,
        );
    }
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
}


import 'package:bmteacher/ui/HomeScreen/choice.dart';
import 'package:bmteacher/ui/HomeScreen/drawer_page.dart';
import 'package:bmteacher/ui/LoginPage/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/navigation_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _removeKeyboard();
    Future.delayed(Duration(milliseconds: 3000), () => _goNext());
  }
  _removeKeyboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("keyboard");
  }

  void _goNext() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var email = preferences.getString("email");
    var userID = preferences.getString('userID');
    var loginEmployeeNumber = preferences.getString('employeeNumber');
    var name = preferences.getString('name');
    var designation = preferences.getString('designation');
    var school_Id = preferences.getString('school_id');
    var images = preferences.getString('images');
    var teacher = preferences.getString('teacher');
    var hos = preferences.getString('hos');
    var user = preferences.getString('email');
    var academicYear = preferences.getString('academic_year');
    print(designation);

    print("the teacher is $teacher");
    print("the hos is $hos");

    if (teacher != null) {
      NavigationUtils.goNextFinishAll(
          context,
          DrawerPage(
              userId: userID,
              loginedUserEmployeeNo: loginEmployeeNumber,
              designation: designation,
              schoolId: school_Id,
              loginedUserName: name,
              email: user,
              images: images,
          academic_year: academicYear,));
    } else if (hos != null) {
      NavigationUtils.goNextFinishAll(
          context,
          ChoicePage(
            userID: userID,
            designation: designation,
            name: name,
            image: images,
            email: user,
            loginEmployeeID: loginEmployeeNumber,
            schoolID: school_Id,
            academic_year: academicYear,
          ));
    } else {
      NavigationUtils.goNextFinishAll(context, LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4B53D9),
      body: Center(
        child: Container(
          width: 100.w,
          height: 100.h,
          child:  SvgPicture.asset("assets/images/splashscreenmainlogo.svg"),
        ),
      )
    );
  }
}

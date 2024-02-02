import 'dart:convert';
import 'dart:io';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/utils.dart';
import '../ForgotPassword/forgot_password.dart';
import '../HomeScreen/choice.dart';
import '../HomeScreen/drawer_page.dart';
import 'google_signin_api.dart';
import 'hoslisting.dart';

class LoginPage extends StatefulWidget {
  var role_id;

  LoginPage({Key? key, this.role_id}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? _usernameController;
  TextEditingController? _passwordController;

  bool isSpinner = false;
  bool googleSignIn = false;
  FocusNode? _usernameFocusNode;
  FocusNode? _passwordFocusNode;
  bool _obscureText = true;
  String? employeeNumbers;
  String? userIds;
  String? names;
  String? schoolIds;
  String? images;
  var designation = [];
  var loginRoleid;


  List<String> rolename = [];

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue : Colors.lightBlueAccent,
        ),
      );
    },
  );

  final spinkitNew = SpinKitWave(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
          decoration: BoxDecoration(
        color: index.isEven ? Colors.blue : Colors.lightBlueAccent,
      ));
    },
  );

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    // _progressDialog = ProgressDialog(context);
  }

  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    _usernameFocusNode?.dispose();
    _passwordFocusNode?.dispose();
    super.dispose();
  }

  Map<String, dynamic>? loginData;

  Future getUserdata() async {
    print("OK");
    String? userName = _usernameController!.text;
    String? _password = _passwordController!.text;
    if (userName.isEmpty) {
      Utils.showToastError("Please enter username").show(context);
      print("username empty");
      return;
    }

    if (_password.isEmpty) {
      Utils.showToastError("Please enter password").show(context);
      return;
    }

    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _checkInternet(context);
      setState(() {
        isSpinner = false;
      });
    } else {
      String username = userName.trim();
      String password = _password;

      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.LOGIN_URL));
      request.body = json.encode({
        "username": username,
        "password": password,
      });
      request.headers.addAll(headers);

      print('loginboddyyy${request.body}');

      http.StreamedResponse response = await request.send();

      print("mobile");
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        loginData = json.decode(responseData);
        APICacheDBModel cacheDBModel = APICacheDBModel(
            key: "loginApi", syncData: json.encode(responseData));
        await APICacheManager().addCacheData(cacheDBModel);
        var employeeNumber = loginData!["data"]["data"][0]["employeeNo"];
        var userId = loginData!["data"]["data"][0]["user_id"];
        var email = loginData!["data"]["data"][0]["username"];
        var name = loginData!["data"]["data"][0]["name"];
        var image = loginData!["data"]["data"][0]["image"];
        var schoolId = loginData!["data"]["data"][0]["school_id"];
        var academic_year = loginData!["data"]["data"][0]["academic_year"];
        var rOLEID = loginData!["data"]["data"][0]["all_roles_array"];
        loginRoleid = loginData!["data"]["data"][0]["role_ids"];
        rOLEID.forEach((e) {
          rolename.add(e['name']);
        });

        print('---------role_ids-----${loginData!["data"]["data"][0]["role_ids"]}');
        print(loginData!["data"]["data"][0]["all_roles_array"].length);
        print(
            'all rore login${loginData!["data"]["data"][0]["all_roles_array"].runtimeType}');

        for (var i = 0;
            i < loginData!["data"]["data"][0]["all_roles_array"].length;
            i++) {
          var desig =
              loginData!["data"]["data"][0]["all_roles_array"][i]["name"];
          designation.add(desig);
        }
        // var designation1 =
        //     loginData!["data"]["data"][0]["all_roles_array"][0]["name"];
        // var designation2 =
        //     loginData!["data"]["data"][0]["all_roles_array"][1]["name"];

        employeeNumbers = employeeNumber;
        userIds = userId;
        print('------------userIds--------------$userIds');
        names = name;
        images = image;
        schoolIds = schoolId;

        print(userIds);
        print("the login employee number is $employeeNumbers");
        print("the login employee number is $employeeNumbers");

        //getUserLoginCredentials();

        SharedPreferences preference = await SharedPreferences.getInstance();
        preference.setString('email', '$username');
        preference.setString('userID', '$userIds');
        preference.setString('employeeNumber', '$employeeNumbers');
        preference.setString('name', '$names');
        preference.setString('designation', '$designation');
        preference.setString('school_id', '$schoolIds');
        preference.setString('images', '$images');
        preference.setString('email', '$email');
        preference.setString('academic_year', '$academic_year');
        preference.setString('role_ids', "$rOLEID");
        preference.setStringList('role_name', rolename);
        preference.setString('role_ids', json.encode(loginRoleid));
        print('roll_ids--------->${loginData!["data"]["data"][0]["role_ids"]}');
        print('employee-------Numbers${employeeNumbers}');
        print('rOLEID-------rOLEID${rOLEID}');
        print('rOLEID----pref---rOLEID${preference.getString('role_ids')}');

        if (schoolIds == "CPpbKPQTcuG97i3kv") {
          preference.setString(
              "school_token", "7a9d733269d23bc35b04b56dc855d330");
          if (loginData!["data"]["data"][0]["role_ids"].length != 0) {
            if (loginData!["data"]["data"][0]["role_ids"]
                .contains("rolepri12") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role12123") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("62690f2b15f336042ba786786")) {
              preference.setString('principal', "you are principal");
              print("you are only principal 04");
              NavigationUtils.goNextFinishAll(
                  context,
                  hoslisting(
                    loginroleid:loginData!["data"]["data"][0]["role_ids"],
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    images: images,
                    email: email,
                    academic_year: academic_year,
                    role_id: loginData!["data"]["data"][0]["all_roles_array"],
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234") || loginData!["data"]["data"][0]["role_ids"]
                .contains("v2QNTPPvPQK6T") &&
                    loginData!["data"]["data"][0]["role_ids"]
                        .contains("role12123rqwer")) {
              preference.setString('hos', "you are hos");
              print("you are only hos 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: email,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234")|| loginData!["data"]["data"][0]["role_ids"]
                .contains("v2QNTPPvPQK6T")) {
              preference.setString('hos', "i am a hos");
              print("this is only the hos 01");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: email,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            } else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role12123rqwer")) {
              preference.setString('teacher', "i am a teacher");
              print("this is only the teacher 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  DrawerPage(
                    userId: userIds,
                    loginedUserEmployeeNo: employeeNumbers,
                    designation: designation,
                    schoolId: schoolIds,
                    loginedUserName: names,
                    images: images,
                    email: email,
                    academic_year: academic_year,
                    roll_id: widget.role_id,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else {
              _submitFailed(context);
              setState(() {
                isSpinner = false;
              });
            }
          }

        }
        if (schoolIds == "ps4vyLJhQvPZjfxaH") {
          preference.setString(
              "school_token", "99d351fe9165be1c0cf35fa0a0885c17");

          if (loginData!["data"]["data"][0]["role_ids"].length != 0) {
            if (loginData!["data"]["data"][0]["role_ids"]
                .contains("rolepri12") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role12123") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("62690f2b15f336042ba786786")) {
              preference.setString('principal', "you are principal");
              print("you are only principal 04");
              NavigationUtils.goNextFinishAll(
                  context,
                  hoslisting(
                    loginroleid:loginData!["data"]["data"][0]["role_ids"],
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    images: images,
                    email: email,
                    academic_year: academic_year,
                    role_id: loginData!["data"]["data"][0]["all_roles_array"],
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234") || loginData!["data"]["data"][0]["role_ids"]
                .contains("5d8b3b701dad2f60218cbe46")  &&
                    loginData!["data"]["data"][0]["role_ids"]
                        .contains("role12123rqwer")) {
              preference.setString('hos', "you are hos");
              print("you are only hos 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: email,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234")|| loginData!["data"]["data"][0]["role_ids"]
                .contains("5d8b3b701dad2f60218cbe46")) {
              preference.setString('hos', "i am a hos");
              print("this is only the hos 01");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: email,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }     else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role12123rqwer")) {
              preference.setString('teacher', "i am a teacher");
              print("this is only the teacher 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  DrawerPage(
                    userId: userIds,
                    loginedUserEmployeeNo: employeeNumbers,
                    designation: designation,
                    schoolId: schoolIds,
                    loginedUserName: names,
                    images: images,
                    email: email,
                    academic_year: academic_year,
                    roll_id: widget.role_id,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else {
              _submitFailed(context);
              setState(() {
                isSpinner = false;
              });
            }
          }

        }
        if (schoolIds == "m2LMtqaESFZf6xDE8") {
          print(
              '-------dtget-------${loginData!["data"]["data"][0]["role_ids"].contains("rolepri12")}');
          print('-------eyhe-------${loginData!["data"]["data"][0]["role_ids"]}');
          print('-------eyhe-------${loginData!["data"]["data"][0]["role_ids"]}');
          preference.setString(
              "school_token", "47e2b919b8551d762e1dd1f5769b66ba");

          if (loginData!["data"]["data"][0]["role_ids"].length != 0) {
            if (loginData!["data"]["data"][0]["role_ids"]
                .contains("rolepri12") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role12123") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("62690f2b15f336042ba786786")) {
              preference.setString('principal', "you are principal");
              print("you are only principal 04");
              NavigationUtils.goNextFinishAll(
                  context,
                  hoslisting(
                    loginroleid:loginData!["data"]["data"][0]["role_ids"],
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    images: images,
                    email: email,
                    academic_year: academic_year,
                    role_id: loginData!["data"]["data"][0]["all_roles_array"],
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234") || loginData!["data"]["data"][0]["role_ids"]
                .contains("Eqt48DDGmQx8P")  &&
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role12123rqwer")) {
              preference.setString('hos', "you are hos");
              print("you are only hos 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: email,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234") || loginData!["data"]["data"][0]["role_ids"]
                .contains("Eqt48DDGmQx8P")) {
              preference.setString('hos', "i am a hos");
              print("this is only the hos 01");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: email,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }     else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role12123rqwer")) {
              preference.setString('teacher', "i am a teacher");
              print("this is only the teacher 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  DrawerPage(
                    userId: userIds,
                    loginedUserEmployeeNo: employeeNumbers,
                    designation: designation,
                    schoolId: schoolIds,
                    loginedUserName: names,
                    images: images,
                    email: email,
                    academic_year: academic_year,
                    roll_id: widget.role_id,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else {
              _submitFailed(context);
              setState(() {
                isSpinner = false;
              });
            }
          }
        }

        if (schoolIds == "2FwuqhgeoKt6SQiCG") {
          preference.setString(
              "school_token", "0ae409a7d98dde57b35a4643d2354906");

          if (loginData!["data"]["data"][0]["role_ids"].length != 0) {
            if (loginData!["data"]["data"][0]["role_ids"]
                .contains("rolepri12") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role12123") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("62690f2b15f336042ba786786")) {
              preference.setString('principal', "you are principal");
              print("you are only principal 04");
              NavigationUtils.goNextFinishAll(
                  context,
                  hoslisting(
                    loginroleid:loginData!["data"]["data"][0]["role_ids"],
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    images: images,
                    email: email,
                    academic_year: academic_year,
                    role_id: loginData!["data"]["data"][0]["all_roles_array"],
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234") || loginData!["data"]["data"][0]["role_ids"]
                .contains("v2QNTPPvPQK6T")  &&
                    loginData!["data"]["data"][0]["role_ids"]
                        .contains("role12123rqwer")) {
              preference.setString('hos', "you are hos");
              print("you are only hos 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: email,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234")|| loginData!["data"]["data"][0]["role_ids"]
                .contains("v2QNTPPvPQK6T")) {
              preference.setString('hos', "i am a hos");
              print("this is only the hos 01");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: email,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }     else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role12123rqwer")) {
              preference.setString('teacher', "i am a teacher");
              print("this is only the teacher 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  DrawerPage(
                    userId: userIds,
                    loginedUserEmployeeNo: employeeNumbers,
                    designation: designation,
                    schoolId: schoolIds,
                    loginedUserName: names,
                    images: images,
                    email: email,
                    academic_year: academic_year,
                    roll_id: widget.role_id,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else {
              _submitFailed(context);
              setState(() {
                isSpinner = false;
              });
            }
          }
        }

        setState(() {
          isSpinner = false;
        });
      } else {
        print(response.reasonPhrase);
        _submitFailed(context);
        setState(() {
          isSpinner = false;
        });
      }
    }

  }

  Future getGoogleUserdata() async {
    print("OK");

    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _checkInternet(context);
      setState(() {
        isSpinner = false;
      });
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var user = preferences.getString("GoogleUser");
      var headers = {
        'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse(ApiConstants.GOOGLE_SIGN_IN));
      request.body = json.encode({
        "username": user,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        loginData = json.decode(responseData);
        var userId = loginData!["data"]["data"][0]["user_id"];
        var name = loginData!["data"]["data"][0]["name"];
        var image = loginData!["data"]["data"][0]["image"];
        var employeeNumber = loginData!["data"]["data"][0]["employeeNo"];
        var schoolId = loginData!["data"]["data"][0]["school_id"];
        var academic_year = loginData!["data"]["data"][0]["academic_year"];
        print(loginData!["data"]["data"][0]["all_roles_array"].length);
        for (var i = 0;
            i < loginData!["data"]["data"][0]["all_roles_array"].length;
            i++) {
          var desig =
              loginData!["data"]["data"][0]["all_roles_array"][i]["name"];
          designation.add(desig);
        }

        employeeNumbers = employeeNumber;
        userIds = userId;
        print('------------userIds--------------$userIds');
        names = name;
        images = image;
        schoolIds = schoolId;
        print(userIds);

        print("the login employee number is $loginData");
        SharedPreferences preference = await SharedPreferences.getInstance();
        preference.setString('email', '$user');
        preference.setString('userID', '$userIds');
        preference.setString('employeeNumber', '$employeeNumbers');
        preference.setString('name', '$names');
        preference.setString('designation', '$designation');
        preference.setString('school_id', '$schoolIds');
        preference.setString('images', '$images');
        preference.setString('academic_year', '$academic_year');
        preference.setString('role_ids', '$loginRoleid');
        //getUserLoginCredentials();

        if (schoolIds == "CPpbKPQTcuG97i3kv") {
          preference.setString(
              "school_token", "7a9d733269d23bc35b04b56dc855d330");
          if (loginData!["data"]["data"][0]["role_ids"].length != 0) {
            if (loginData!["data"]["data"][0]["role_ids"]
                .contains("rolepri12") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role12123") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("62690f2b15f336042ba786786")) {
              preference.setString('principal', "you are principal");
              print("you are only principal 04");
              NavigationUtils.goNextFinishAll(
                  context,
                  hoslisting(
                    loginroleid:loginData!["data"]["data"][0]["role_ids"],
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    images: images,
                    email: user,
                    academic_year: academic_year,
                    role_id: loginData!["data"]["data"][0]["all_roles_array"],
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234") || loginData!["data"]["data"][0]["role_ids"]
                .contains("v2QNTPPvPQK6T")  &&
                    loginData!["data"]["data"][0]["role_ids"]
                        .contains("role12123rqwer")) {
              preference.setString('hos', "you are hos");
              print("you are only hos 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: user,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234")|| loginData!["data"]["data"][0]["role_ids"]
                .contains("v2QNTPPvPQK6T") ) {
              preference.setString('hos', "i am a hos");
              print("this is only the hos 01");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: user,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }     else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role12123rqwer")) {
              preference.setString('teacher', "i am a teacher");
              print("this is only the teacher 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  DrawerPage(
                    userId: userIds,
                    loginedUserEmployeeNo: employeeNumbers,
                    designation: designation,
                    schoolId: schoolIds,
                    loginedUserName: names,
                    images: images,
                    email: user,
                    academic_year: academic_year,
                    roll_id: widget.role_id,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else {
              _submitFailed(context);
              setState(() {
                isSpinner = false;
              });
            }
          }
        }
        if (schoolIds == "ps4vyLJhQvPZjfxaH") {
          preference.setString(
              "school_token", "99d351fe9165be1c0cf35fa0a0885c17");
          if (loginData!["data"]["data"][0]["role_ids"].length != 0) {
            if (loginData!["data"]["data"][0]["role_ids"]
                .contains("rolepri12") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role12123") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("62690f2b15f336042ba786786")) {
              preference.setString('principal', "you are principal");
              print("you are only principal 04");
              NavigationUtils.goNextFinishAll(
                  context,
                  hoslisting(
                    loginroleid:loginData!["data"]["data"][0]["role_ids"],
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    images: images,
                    email: user,
                    academic_year: academic_year,
                    role_id: loginData!["data"]["data"][0]["all_roles_array"],
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234") || loginData!["data"]["data"][0]["role_ids"]
                .contains("5d8b3b701dad2f60218cbe46")  &&
                    loginData!["data"]["data"][0]["role_ids"]
                        .contains("role12123rqwer")) {
              preference.setString('hos', "you are hos");
              print("you are only hos 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: user,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234") || loginData!["data"]["data"][0]["role_ids"]
                .contains("5d8b3b701dad2f60218cbe46")) {
              preference.setString('hos', "i am a hos");
              print("this is only the hos 01");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: user,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }     else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role12123rqwer")) {
              preference.setString('teacher', "i am a teacher");
              print("this is only the teacher 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  DrawerPage(
                    userId: userIds,
                    loginedUserEmployeeNo: employeeNumbers,
                    designation: designation,
                    schoolId: schoolIds,
                    loginedUserName: names,
                    images: images,
                    email: user,
                    academic_year: academic_year,
                    roll_id: widget.role_id,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else {
              _submitFailed(context);
              setState(() {
                isSpinner = false;
              });
            }
          }
        }
        if (schoolIds == "m2LMtqaESFZf6xDE8") {
          preference.setString(
              "school_token", "47e2b919b8551d762e1dd1f5769b66ba");
          if (loginData!["data"]["data"][0]["role_ids"].length != 0) {
            if (loginData!["data"]["data"][0]["role_ids"]
                .contains("rolepri12") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role12123") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("62690f2b15f336042ba786786")) {
              preference.setString('principal', "you are principal");
              print("you are only principal 04");
              NavigationUtils.goNextFinishAll(
                  context,
                  hoslisting(
                    loginroleid:loginData!["data"]["data"][0]["role_ids"],
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    images: images,
                    email: user,
                    academic_year: academic_year,
                    role_id: loginData!["data"]["data"][0]["all_roles_array"],
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234") || loginData!["data"]["data"][0]["role_ids"]
                .contains("Eqt48DDGmQx8P")  &&
                    loginData!["data"]["data"][0]["role_ids"]
                        .contains("role12123rqwer")) {
              preference.setString('hos', "you are hos");
              print("you are only hos 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: user,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234") || loginData!["data"]["data"][0]["role_ids"]
                .contains("Eqt48DDGmQx8P")) {
              preference.setString('hos', "i am a hos");
              print("this is only the hos 01");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: user,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }     else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role12123rqwer")) {
              preference.setString('teacher', "i am a teacher");
              print("this is only the teacher 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  DrawerPage(
                    userId: userIds,
                    loginedUserEmployeeNo: employeeNumbers,
                    designation: designation,
                    schoolId: schoolIds,
                    loginedUserName: names,
                    images: images,
                    email: user,
                    academic_year: academic_year,
                    roll_id: widget.role_id,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else {
              _submitFailed(context);
              setState(() {
                isSpinner = false;
              });
            }
          }
        }

        if (schoolIds == "2FwuqhgeoKt6SQiCG") {
          preference.setString(
              "school_token", "0ae409a7d98dde57b35a4643d2354906");
          if (loginData!["data"]["data"][0]["role_ids"].length != 0) {
            if (loginData!["data"]["data"][0]["role_ids"]
                .contains("rolepri12") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role12123") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("62690f2b15f336042ba786786")) {
              preference.setString('principal', "you are principal");
              print("you are only principal 04");
              NavigationUtils.goNextFinishAll(
                  context,
                  hoslisting(
                    loginroleid:loginData!["data"]["data"][0]["role_ids"],
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    images: images,
                    email: user,
                    academic_year: academic_year,
                    role_id: loginData!["data"]["data"][0]["all_roles_array"],
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234")  || loginData!["data"]["data"][0]["role_ids"]
                .contains("v2QNTPPvPQK6T") &&
                    loginData!["data"]["data"][0]["role_ids"]
                        .contains("role12123rqwer")) {
              preference.setString('hos', "you are hos");
              print("you are only hos 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: user,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role121235") ||
                loginData!["data"]["data"][0]["role_ids"]
                    .contains("role121234")  || loginData!["data"]["data"][0]["role_ids"]
                .contains("v2QNTPPvPQK6T") ) {
              preference.setString('hos', "i am a hos");
              print("this is only the hos 01");
              NavigationUtils.goNextFinishAll(
                  context,
                  ChoicePage(
                    userID: userIds,
                    loginEmployeeID: employeeNumbers,
                    designation: designation,
                    name: names,
                    schoolID: schoolIds,
                    image: images,
                    email: user,
                    academic_year: academic_year,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }     else if (loginData!["data"]["data"][0]["role_ids"]
                .contains("role12123rqwer")) {
              preference.setString('teacher', "i am a teacher");
              print("this is only the teacher 03");
              NavigationUtils.goNextFinishAll(
                  context,
                  DrawerPage(
                    userId: userIds,
                    loginedUserEmployeeNo: employeeNumbers,
                    designation: designation,
                    schoolId: schoolIds,
                    loginedUserName: names,
                    images: images,
                    email: user,
                    academic_year: academic_year,
                    roll_id: widget.role_id,
                    usermailid: loginData!["data"]["data"][0]["username"],
                  ));
            }
            else {
              _submitFailed(context);
              setState(() {
                isSpinner = false;
              });
            }
          }
        }
        setState(() {
          isSpinner = false;
        });
      } else {
        _submitFailed(context);
        setState(() {
          isSpinner = false;
        });
      }
    }
  }

  String? GoogleUser;

  Future signIn() async {
    print("wkjekw");
    if (await GoogleSignInApi.isSignedIn()) {
      await GoogleSignInApi.logout();
    }
    final Guser = await GoogleSignInApi.login();
    print(Guser!.email);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('GoogleUser', Guser.email.toString());
    //  print(preferences.getString('GoogleUser'));
    GoogleUser = preferences.getString('GoogleUser');

    try {
      if (Guser.email.isEmpty) {
        print("No User found");
        _submitFailed(context);
        setState(() {
          isSpinner = true;
        });
      } else {
        setState(() {
          isSpinner = true;
        });
        getGoogleUserdata();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: ColorUtils.BACKGROUND,
          body: ListView(
            children: [
              Stack(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        "assets/images/header.png",
                        fit: BoxFit.fill,
                      )),
                  Container(
                    margin:
                        EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                    // width: 550.w,
                    // height: 650.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                        borderRadius: BorderRadius.all(Radius.circular(20.r))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 200.w,
                            height: 200.h,
                            child:
                                Lottie.asset("assets/images/loginimage.json"),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 38.w),
                              child: Text("Hello",
                                  style: TextStyle(
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ColorUtils.BLACK_GREY,
                                      fontFamily: "WorkSans")),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 38.w),
                              child: Text("Sign in to your account",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: ColorUtils.BLACK_GREY100,
                                      fontFamily: "WorkSans Light")),
                            ),
                            Center(
                                child: GestureDetector(
                              onTap: () {
                                signIn();
                              },
                              child: Container(
                                  width: 287.w,
                                  margin: EdgeInsets.only(right: 30.w),
                                  child: isSpinner
                                      ? Text("")
                                      : Image.asset(
                                          "assets/images/googleButton.png")),
                            )),
                          ],
                        ),
                        isSpinner
                            ? Text("")
                            : Container(
                                // margin: EdgeInsets.only(left: 35.w),
                                child: Center(
                                    child: Image.asset(
                                        "assets/images/oroptional.png")),
                              ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.h, vertical: 2.w),
                          child: TextFormField(
                            controller: _usernameController,
                            autofillHints: [AutofillHints.username],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Username',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.h, vertical: 5.w),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            obscureText: _obscureText,
                            controller: _passwordController,
                            autofillHints: [AutofillHints.password],
                            onEditingComplete: () =>
                                TextInput.finishAutofillContext(),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Password',
                                suffixIcon: _obscureText
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureText = false;
                                          });
                                        },
                                        child: Icon(Icons.visibility_off))
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscureText = true;
                                          });
                                        },
                                        child: Icon(Icons.visibility))),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              NavigationUtils.goNext(context, ForgotPassword()),
                          child: Container(
                            margin: EdgeInsets.only(left: 230.w, top: 10.h),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(fontSize: 9.sp),
                            ),
                          ),
                        ),
                        Center(
                            child: GestureDetector(
                                onTap: () async {
                                  if (_usernameController!.text.isEmpty ||
                                      _passwordController!.text.isEmpty) {
                                    Utils.showToastError(
                                            "Please fill the required fields")
                                        .show(context);
                                  } else {
                                    setState(() {
                                      isSpinner = true;
                                    });
                                    var isCacheExist = await APICacheManager()
                                        .isAPICacheKeyExist("loginApiResp");
                                    if (isCacheExist) {
                                      print('cache delete con');
                                      await APICacheManager()
                                          .deleteCache('loginApiResp');
                                    }
                                    getUserdata();
                                  }
                                },
                                child: isSpinner
                                    ? Container(
                                        width: 100.w,
                                        height: 100.h,
                                        margin: EdgeInsets.only(top: 10.h),
                                        child: Image.asset(
                                            "assets/images/loader3.gif"),
                                      )
                                    : Container(
                                        width: 287.w,
                                        height: 48.h,
                                        margin: EdgeInsets.only(top: 30.h),
                                        child: Image.asset(
                                            "assets/images/loginButton.png")))),
                        SizedBox(
                          height: 10.h,
                        ),
                        Center(
                          child: Text(
                            'Version ${ApiConstants.Version}',
                            style: TextStyle(
                                color: Colors.blueGrey, fontSize: 10.sp),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }

  _checkInternet(context) {
    return Alert(
      onWillPopActive: true,
      context: context,
      type: AlertType.warning,
      title: "Please Check Your Internet Connection",
      style: AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          child: Text(
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

  _notAuthorized(context) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "You are not authorized to access this application",
      style: AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          child: Text(
            "Try again",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.pop(context);
            designation.clear();
            await GoogleSignInApi.logout();
          },
          // print(widget.academicyear);
          //width: 120,
        )
      ],
    ).show();
  }

  _submitFailed(context) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "Invalid Username/Password! Please Try Again",
      style: AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          child: Text(
            "Try again",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.pop(context);
            designation.clear();
            await GoogleSignInApi.logout();
          },
          // print(widget.academicyear);
          //width: 120,
        )
      ],
    ).show();
  }
}

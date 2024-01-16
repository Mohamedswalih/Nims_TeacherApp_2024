import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Database/time_table_database_helper.dart';
import '../Network/api_constants.dart';
import '../Utils/color_utils.dart';
import '../Utils/navigation_utils.dart';
import '../ui/LoginPage/login.dart';

class NotificationPage extends StatefulWidget {
  String? name;
  String? image;

  NotificationPage({Key? key, this.image, this.name}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = false;

  Map<String, dynamic>? notificationResult;

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
        isLoading = false;
      });
      log('Notification$notificationResult');
    } else {
      print(response.reasonPhrase);
    }
  }

  markAsReadNotification(String notificationId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('PUT', Uri.parse(ApiConstants.UPDATE_NOTIFICATION));
    request.body =
        json.encode({"user_id": userID, "notification_id": notificationId});

    log(request.body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print(response.statusCode);
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      setState(() {
        getNotification();
        //isLoading=false;
      });
    } else {
      print(response.reasonPhrase);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.BACKGROUND,
      body: LoadingOverlay(
        color: Colors.white,
        isLoading: isLoading,
        opacity: 0.6,
        progressIndicator: const CircularProgressIndicator(
          color: ColorUtils.RED,
        ),
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
                                  fontSize: 17.sp,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            width: 120.w,
                            height: 40.h,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.name.toString(),
                                style: TextStyle(
                                    fontFamily: "WorkSans",
                                    fontSize: 18.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 120.w,
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
                  margin: EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                  width: 500.w,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.notifications_none_sharp,
                                  color: ColorUtils.SEARCH_TEXT_COLOR,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "Notifications",
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: ColorUtils.SEARCH_TEXT_COLOR),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      notificationResult == null
                          ? Center(
                              child: CircularProgressIndicator(
                              color: ColorUtils.RED,
                            ))
                          : notificationResult!["data"]["details"]
                                      ["recentNotifications"] ==
                                  null
                              ? Container(
                                  margin:
                                      EdgeInsets.only(left: 30.w, right: 30.w),
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children: const [
                                      Center(
                                        child: Text(
                                          "No Notifications for you",
                                          style: TextStyle(
                                              color:
                                                  ColorUtils.SEARCH_TEXT_COLOR),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: notificationResult!["data"]
                                              ["details"]["recentNotifications"]
                                          .length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //SizedBox(height: 10.h,),
                                            Container(
                                              margin: EdgeInsets.all(8.0),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              //margin: EdgeInsets.only(left: 20.w, right: 20.w),
                                              decoration: BoxDecoration(
                                                  color: notificationResult![
                                                                          "data"]
                                                                      ["details"]
                                                                  [
                                                                  "recentNotifications"][index]
                                                              ["status"] ==
                                                          "active"
                                                      ? Color(0xFFECF1FF)
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color: Color(0xFFCAD3FF)),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10.r))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${notificationResult!["data"]["details"]["recentNotifications"][index]["msg"]}",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // Container(
                                                        //   margin:  EdgeInsets.all(4),
                                                        //   child: Text(notificationResult!["data"]["details"]["recentNotifications"][index]["status"],
                                                        //     style: TextStyle(color: ColorUtils.SEARCH_TEXT_COLOR),
                                                        //   ),
                                                        // ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: Text(
                                                            "${notificationResult!['data']
                                                            [
                                                            'details']
                                                            [
                                                            'recentNotifications']
                                                            [
                                                            index]['gen-date']
                                                                .split("T")[0].toString().split('-').last}-${notificationResult!['data']
                                                            [
                                                            'details']
                                                            [
                                                            'recentNotifications']
                                                            [
                                                            index]['gen-date']
                                                                .split("T")[0].toString().split('-')[1]}-${ notificationResult!['data']
                                                            [
                                                            'details']
                                                            [
                                                            'recentNotifications']
                                                            [
                                                            index]['gen-date']
                                                                .split("T")[0].toString().split('-').first}",
                                                            style: TextStyle(
                                                                color: ColorUtils
                                                                    .SEARCH_TEXT_COLOR),
                                                          ),
                                                        ),
                                                        notificationResult!["data"][
                                                                            "details"]
                                                                        [
                                                                        "recentNotifications"][index]
                                                                    [
                                                                    "status"] ==
                                                                "active"
                                                            ? ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        primary:
                                                                            Color(
                                                                                0xFFECF1FF)),
                                                                onPressed:
                                                                    () async {
                                                                  setState(() {
                                                                    isLoading =
                                                                        true;
                                                                    notificationResult!["data"]["details"]["recentNotifications"][index]
                                                                            [
                                                                            "status"] =
                                                                        'inactive';
                                                                  });
                                                                  print(
                                                                      'is Active--->${notificationResult!["data"]["details"]["recentNotifications"][index]["status"]}');
                                                                  markAsReadNotification(notificationResult!["data"]
                                                                              [
                                                                              "details"]
                                                                          [
                                                                          "recentNotifications"]
                                                                      [
                                                                      index]["_id"]);
                                                                  SharedPreferences
                                                                      preference =
                                                                      await SharedPreferences
                                                                          .getInstance();
                                                                  var count =
                                                                      preference
                                                                          .getInt(
                                                                              "count");
                                                                  var newResult =
                                                                      count! -
                                                                          1;
                                                                  preference.setInt(
                                                                      "count",
                                                                      newResult);
                                                                  print(
                                                                      newResult);
                                                                },
                                                                child: Text(
                                                                  "Mark as Read",
                                                                  style: TextStyle(
                                                                      color: ColorUtils
                                                                          .RED),
                                                                ))
                                                            : Text("")
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      })),
                      SizedBox(
                        height: 160.h,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
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
}

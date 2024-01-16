
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

import '../../Notification/notification.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import 'activity_callnotanswer.dart';
import 'activity_committed.dart';
import 'activity_misbehave.dart';
import 'activity_wrongorinvalid.dart';

class ActivityListView extends StatefulWidget {
  String? EmployeeCode;
  String? name;

  ActivityListView({Key? key, this.EmployeeCode, this.name}) : super(key: key);

  @override
  _ActivityListViewState createState() => _ActivityListViewState();
}

class _ActivityListViewState extends State<ActivityListView>
    with TickerProviderStateMixin {
  bool calender = true;
  bool call = false;
  bool invalid = false;
  bool misbe = false;

  String _getTitle() {
    if (selectedbutton == 0) {
      return "Committed Date";
    } else if (selectedbutton == 1) {
      return "Call not answered";
    } else if (selectedbutton == 2) {
      return "Wrong or invalid number";
    } else if (selectedbutton == 3) {
      return "Misbehaviour";
    }
    return "";
  }

  Widget _getMenuItem() {
    if (selectedbutton == 0) {
      return ActivityCommitted(
        LoginedInEmployeeCode: widget.EmployeeCode,
      );
    } else if (selectedbutton == 1) {
      return ActivityCallNotAnswered(
        LoginedInEmployeeCode: widget.EmployeeCode,
      );
    } else if (selectedbutton == 2) {
      return ActivityWrongNumber(
        LoginedInEmployeeCode: widget.EmployeeCode,
      );
    } else if (selectedbutton == 3) {
      return ActivityMisbehave(
        LoginedInEmployeeCode: widget.EmployeeCode,
      );
    }
    return Container();
  }

  @override
  void initState() {
    super.initState();
    selectedbutton = 0;
  }

  int? selectedbutton;

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
                                  fontSize: 20.sp,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70.w,
                  ),
                  GestureDetector(
                    onTap: () =>
                        NavigationUtils.goNext(context, NotificationPage()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset("assets/images/bellIcon.svg"),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.r)),
                        side: BorderSide(width: 2, color: Colors.white)),
                    margin: EdgeInsets.only(top: 5.h),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50.r)),
                        child: Image.asset(
                          "assets/images/nancy.png",
                          width: 50.w,
                          height: 50.h,
                          fit: BoxFit.fill,
                        )),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 30.w, top: 100.h, right: 30.w),
                width: 500.w,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Activities",
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary:
                                calender ? Colors.blueAccent : Colors.white,
                          ),
                          child: Container(
                              width: 45.w,
                              height: 45.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/vectorthree.png",
                                ),
                              )),
                          onPressed: () {
                            setState(() {
                              call = false;
                              invalid = false;
                              misbe = false;
                              if (calender == false) {
                                calender = true;
                              }
                              selectedbutton = 0;
                            });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: call ? Colors.blueAccent : Colors.white,
                          ),
                          child: Container(
                              width: 45.w,
                              height: 45.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/vectortwo.png",
                                ),
                              )),
                          onPressed: () {
                            setState(() {
                              calender = false;
                              invalid = false;
                              misbe = false;
                              if (call == false) {
                                call = true;
                              }
                              selectedbutton = 1;
                            });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: invalid ? Colors.blueAccent : Colors.white,
                          ),
                          child: Container(
                              width: 45.w,
                              height: 45.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/vectorfour.png",
                                ),
                              )),
                          onPressed: () {
                            setState(() {
                              call = false;
                              calender = false;
                              misbe = false;
                              if (invalid == false) {
                                invalid = true;
                              }
                              selectedbutton = 2;
                            });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            primary: misbe ? Colors.blueAccent : Colors.white,
                          ),
                          child: Container(
                              width: 45.w,
                              height: 45.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/vectorone.png",
                                ),
                              )),
                          onPressed: () {
                            setState(() {
                              call = false;
                              invalid = false;
                              calender = false;
                              if (misbe == false) {
                                misbe = true;
                              }
                              selectedbutton = 3;
                            });
                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Text(
                        _getTitle(),
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 16.sp),
                      ),
                    ),
                    Expanded(
                        child: Consumer(
                            builder: (context, tab, child) => _getMenuItem())),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // Widget _getCommittedText(ActivityTab selectedMenu) => Text(
  //   _getTitle(),
  //   style: TextStyle(
  //       color: ColorUtils.BLUE,
  //       fontSize: Utils.getFontSize(16),
  //       fontFamily: Constants.axiforma,
  //       fontWeight: FontWeight.w500),
  // );

}

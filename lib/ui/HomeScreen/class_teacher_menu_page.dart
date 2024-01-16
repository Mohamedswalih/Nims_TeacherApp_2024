
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../LoginPage/login.dart';
import '../StudentProfileEdit/student_profile_list_view.dart';
import 'menu_model.dart';

class TeacherItems {
  static const myClasses = MenuItem("My Classes", Icons.class_outlined);
  static const timeTable = MenuItem("My Timetable", Icons.timeline_outlined);
  static const Leave = MenuItem("Apply Leave", Icons.badge_outlined);
  static const ObservatioResult = MenuItem("Observation Result", Icons.badge_outlined);
  // static const Chat = MenuItem("Chat", Icons.chat_bubble_outline);

  //static const  manageProfile = MenuItem("Manage Profile", Icons.edit);
  //static const profile = MenuItem("Profile", Icons.account_circle_outlined);

  static const all = <MenuItem>[
    myClasses,
    timeTable,
    Leave,
    ObservatioResult,
    // Chat,
    //manageProfile
    //reports,
    // profile
  ];
}

class TeacherMenuPage extends StatefulWidget {
  final MenuItem? currentItem;
  final ValueChanged<MenuItem>? onSelected;
  String? name;
  String? ptofileImage;
  var isAClassTeacher;
  var academicYear;
  var user_id;
  var schoolId;

  TeacherMenuPage(
      {this.currentItem,
      this.onSelected,
      this.name,
      this.ptofileImage,
      this.isAClassTeacher,
      this.academicYear,
      this.user_id,
      this.schoolId});

  @override
  _TeacherMenuPageState createState() => _TeacherMenuPageState();
}

class _TeacherMenuPageState extends State<TeacherMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.fill,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DrawerHeader(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
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
                          height: 70.h,
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
                    SizedBox(
                      width: 60.w,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.r)),
                          side: BorderSide(width: 2, color: Colors.white)),
                      margin: EdgeInsets.only(top: 5.h),
                      child: Container(
                        width: 49.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(ApiConstants.IMAGE_BASE_URL +
                                  "${widget.ptofileImage}"),
                              fit: BoxFit.fill),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 20.w),
                  child: Image.asset("assets/images/dashboard.png")),
              ...TeacherItems.all.map(buildMenuItem).toList(),
              widget.isAClassTeacher == null
                  ? Text("")
                  : widget.isAClassTeacher.length == 1
                      ? GestureDetector(
                          onTap: () {
                            NavigationUtils.goNext(
                                context,
                                StudentProfileListView(
                                  ClassAndBatch: widget.isAClassTeacher[0]
                                      ["class"],
                                  name: widget.name,
                                  image: widget.ptofileImage,
                                  academicYear: widget.academicYear,
                                  userId: widget.user_id,
                                  classId: widget.isAClassTeacher[0]
                                      ["class_id"],
                                  batchId: widget.isAClassTeacher[0]
                                      ["batch_id"],
                                  curriculumId: widget.isAClassTeacher[0]
                                      ["curriculumId"],
                                  schoolId: widget.schoolId,
                                  sessionId: widget.isAClassTeacher[0]
                                      ["session_id"],
                                ));
                          },
                          child: Container(
                            width: 150.w,
                            height: 50.h,
                            margin: EdgeInsets.only(left: 18.w),
                            child: Row(
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 13.w,
                                ),
                                Container(
                                  child: Text(
                                    "Manage Profile",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : ExpansionTile(
                          title: Transform.translate(
                            offset: Offset(-16, 0),
                            child: Text(
                              "Manage Profile",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ),
                          leading: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.isAClassTeacher.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      NavigationUtils.goNext(
                                          context,
                                          StudentProfileListView(
                                            ClassAndBatch:
                                                widget.isAClassTeacher[index]
                                                    ["class"],
                                            name: widget.name,
                                            image: widget.ptofileImage,
                                            academicYear: widget.academicYear,
                                            userId: widget.user_id,
                                            classId:
                                                widget.isAClassTeacher[index]
                                                    ["class_id"],
                                            batchId:
                                                widget.isAClassTeacher[index]
                                                    ["batch_id"],
                                            curriculumId:
                                                widget.isAClassTeacher[index]
                                                    ["curriculumId"],
                                            schoolId: widget.schoolId,
                                            sessionId:
                                                widget.isAClassTeacher[index]
                                                    ["session_id"],
                                          ));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 170.w,
                                                ),
                                                Text(
                                                  widget.isAClassTeacher[index]
                                                      ["class"],
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                const Icon(
                                                  Icons.navigate_next,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  );
                                })
                          ],
                        ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  _logout(context);
                },
                child: Container(
                  width: 100.w,
                  height: 50.h,
                  margin: EdgeInsets.only(left: 20.w),
                  child: Row(
                    children: [
                      Container(
                        child: Image.asset("assets/images/signoutIcon.png"),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                        child: Text(
                          "Sign Out",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
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
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.remove("school_token");
            preferences.remove("count");
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

  Widget buildMenuItem(MenuItem item) {
    return ListTileTheme(
      selectedColor: Colors.white,
      child: ListTile(
        selectedTileColor: Colors.black26,
        selected: widget.currentItem == item,
        minLeadingWidth: 20.w,
        leading: Icon(
          item.icons,
          color: Colors.white,
        ),
        title: Text(
          item.title,
          style: TextStyle(color: Colors.white),
        ),
        onTap: () => widget.onSelected!(item),
      ),
    );
  }
}

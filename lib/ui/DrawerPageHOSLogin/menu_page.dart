
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../LoginPage/login.dart';
import 'menu_model.dart';

class MenuItems {
  static const Leadership = MenuItem("Leadership", Icons.groups);
  static const Reports = MenuItem("Reports", Icons.leaderboard);
  static const Leave = MenuItem("Leave Approval", Icons.badge_outlined);
  // static const Chat = MenuItem("Chat ", Icons.messenger_outline);
  //static const activities = MenuItem("Activities", Icons.list_rounded);
  //static const  reports = MenuItem("Reports", Icons.help_outline);
  //static const profile = MenuItem("Profile", Icons.account_circle_outlined);

  static const all = <MenuItem>[
    Leadership,
    Reports,
    Leave,
    // Chat,
    // activities,
    //reports,
    // profile
  ];
}

class MenuPage extends StatefulWidget {
  final MenuItem? currentItem;
  final ValueChanged<MenuItem>? onSelected;
  String? name;
  String? ptofileImage;
  var isAClassTeacher;
  var loginname;
  MenuPage(
      {this.currentItem,
      this.onSelected,
      this.name,
      this.loginname,
      this.ptofileImage,
      this.isAClassTeacher});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                              widget.loginname.toString(),
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
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFD6E4FA)),
                        image: DecorationImage(
                            image: NetworkImage(widget.ptofileImage == ""
                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                : ApiConstants.IMAGE_BASE_URL +
                                    "${widget.ptofileImage}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //     margin: EdgeInsets.only(left: 20.w),
              //     child: Image.asset(
              //         "assets/images/dashboard.png")),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                child: Text(
                  'Leader',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
              ),

              ...MenuItems.all.map(buildMenuItem).toList(),
              Spacer(),
              Center(
                child: Text(
                  'Version ${ApiConstants.Version}',
                  style: TextStyle(
                      color: Colors.white, fontSize: 10.sp),
                ),
              ),
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
                        child: width >= 590
                            ? Text(
                                "Logout",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10.sp),
                              )
                            : Text(
                                "Logout",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.sp),
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
      title: "Are you sure you want to logout?",
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

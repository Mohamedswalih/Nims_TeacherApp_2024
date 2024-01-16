import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../Network/api_constants.dart';
import '../Notification/notification.dart';
import '../Utils/navigation_utils.dart';

class Header extends StatelessWidget {
  String name;
  String image;
  String count;
  Header({Key? key, required this.name, required this.image, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                    name,
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
                name: name,
                image: image,
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: badges.Badge(
                position: badges.BadgePosition.bottomEnd(end: -7, bottom: 12),
                badgeContent: count == null ? Text("") : Text(count.toString(), style: TextStyle(color: Colors.white),),

                child: SvgPicture.asset("assets/images/bell.svg")
            ),
          ),
        ),
        Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFFD6E4FA)),
            image: DecorationImage(
                image: NetworkImage(image == "" ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg" : ApiConstants.IMAGE_BASE_URL +"${image}"),
                fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}

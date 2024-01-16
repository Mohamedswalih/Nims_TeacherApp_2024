import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Utils/color_utils.dart';

class DefaultTimeTableView extends StatelessWidget {
  var classAndBatch;
  var Subjects;
  var maincolor;
  var subcolor;

  DefaultTimeTableView({this.classAndBatch,this.maincolor,this.subcolor,this.Subjects});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w),
          width: 333.w,
          height: 70.h,
          decoration: BoxDecoration(
              color: maincolor, borderRadius: BorderRadius.circular(8.r)),
          child: Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Container(
                width: 47.w,
                height: 45.h,
                decoration: BoxDecoration(
                    color: subcolor,
                    borderRadius: BorderRadius.all(Radius.circular(50.r))),
                child: Center(
                  child: Text(
                    classAndBatch,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Container(
                width: 250.w,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    Subjects,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: ColorUtils.WHITE),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

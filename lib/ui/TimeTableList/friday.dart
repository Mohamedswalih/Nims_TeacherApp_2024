
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/subject_color.dart';
import '../StudentList/new_student_list_view.dart';
import '../StudentList/non_teacher_studentList.dart';

class Friday extends StatefulWidget {
  var timeTable;
  String? name;
  String? images;
  String? school_id;
  String? academic_year;
  String? selectedDate;
  String? className;
  String? batchName;
  String? userId;
  String? employeeNumber;
  var teacherClasses;

  Friday(
      {this.timeTable,
      this.selectedDate,
      this.className,
      this.academic_year,
      this.batchName,
      this.userId,
      this.school_id,
      this.images,
      this.name,
      this.employeeNumber,this.teacherClasses});

  @override
  _FridayState createState() => _FridayState();
}

class _FridayState extends State<Friday> {
  var ourTimeTable;
  var teacherClass;

  @override
  void initState() {
    ourTimeTable = widget.timeTable;
    teacherClass = widget.teacherClasses;
    print("the time table for friday");
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ourTimeTable.isEmpty || ourTimeTable == null
            ? const Center(child: Text("No Timetable assigned for the day."),) : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: ourTimeTable.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: GestureDetector(
                      onTap: () {
                        ourTimeTable[index]["class_details"].isEmpty ||
                                ourTimeTable[index]["class_details"] == null
                            ? NavigationUtils.goNext(
                                context,
                                NonTeacherStudentList(
                                  name: widget.name,
                                  images: widget.images,
                                  school_id: widget.school_id,
                                  academic_year: widget.academic_year,
                                  selectedDate: widget.selectedDate,
                                  userId: widget.userId,
                                  timeString: ourTimeTable[index]["timeString"]
                                      .replaceAll("[", " ")
                                      .replaceAll("]", " "),
                                  className: ourTimeTable[index]["batchName"],
                                  curriculam_id: ourTimeTable[index]
                                      ["curriculum_id"],
                                  session_id: ourTimeTable[index]["session_id"],
                                  class_id: ourTimeTable[index]["class_id"],
                                  batch_id: ourTimeTable[index]["batch_id"],
                                ))
                            : NavigationUtils.goNext(
                                context,
                                StudentListView(
                                  name: widget.name,
                                  images: widget.images,
                                  LoginedUserEmployeeCode: widget.employeeNumber,
                                  school_id: widget.school_id,
                                  subjectName: ourTimeTable[index]["subject"],
                                  ClassAndBatch: ourTimeTable[index]["batchName"],
                                  academic_year: widget.academic_year,
                                  selectedDate: widget.selectedDate,
                                  userId: widget.userId,
                                  timeString: ourTimeTable[index]["timeString"]
                                      .replaceAll("[", " ")
                                      .replaceAll("]", " "),
                                  className: ourTimeTable[index]["batchName"],
                                  curriculam_id: ourTimeTable[index]
                                      ["curriculum_id"],
                                  session_id: ourTimeTable[index]["session_id"],
                                  class_id: ourTimeTable[index]["class_id"],
                                  batch_id: ourTimeTable[index]["batch_id"],
                                ));
                      },
                      child: _timeTableList(
                          ourTimeTable[index]["timeString"]
                              .replaceAll("[", " ")
                              .replaceAll("]", " "),
                          ourTimeTable[index]["batchName"],
                          ourTimeTable[index]["subject"],
                          mainColorList[index],
                          subColorList[index])));
            }));
  }

  Widget _defaultTimeTable(String batchName, String subject,
      Color mainColor, Color subColor) =>
      Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
            width: 323.w,
            height: 70.h,
            decoration: BoxDecoration(
                color: mainColor, borderRadius: BorderRadius.circular(8.r)),
            child: Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      color: subColor,
                      borderRadius: BorderRadius.all(Radius.circular(50.r))),
                  child: Center(
                    child: Text(
                      batchName,
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
                      subject,
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

  Widget _timeTableList(String time, String batchName, String subject,
          Color mainColor, Color subColor) =>
      Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                time,
                style: TextStyle(color: ColorUtils.TIME_COLOR,fontSize: 14.sp),
              )),
          Container(
            width: 200.w,
            height: 70.h,
            decoration: BoxDecoration(
                color: mainColor, borderRadius: BorderRadius.circular(8.r)),
            child: Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      color: subColor,
                      borderRadius: BorderRadius.all(Radius.circular(50.r))),
                  child: Center(
                    child: Text(
                      batchName,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 140.w,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      subject,
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


import 'package:bmteacher/exports.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/navigation_utils.dart';
import '../Utils/utils.dart';
import '../ui/History/selectpage.dart';
import '../ui/Student_Activity/history_list.dart';

class StudentBottomSheet extends StatefulWidget {
  String? studentName;
  String? image;
  String? Fees;
  bool? is_fees_paid;
  String? parentName;
  String? ParentContact;
  String? AdmissionNumber;
  var result;
  String? name;
  var employeeCode;
  String? teacherimage;
  String? motherName;
  String? motherPhone;
  bool? isMotherDetailExist;
  var ClassAndBatch;
  var images;

  StudentBottomSheet(
      {Key? key, this.result,
      this.image,
      this.parentName,
      this.employeeCode,
      this.studentName,
      this.is_fees_paid,
      this.name,
      this.motherPhone,
      this.motherName,
      this.isMotherDetailExist,
      this.AdmissionNumber,
      this.Fees,
      this.ParentContact,
      this.teacherimage,
      required this.ClassAndBatch,
        required this.images
      }) : super(key: key);

  @override
  State<StudentBottomSheet> createState() => _StudentBottomSheetState();
}

class _StudentBottomSheetState extends State<StudentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2, bottom: 10.h, left: 10.h, right: 10.h),
        child: ListView(
          children: [
            SizedBox(
              height: 25.h,
            ),
            Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage("${widget.image}"), fit: BoxFit.fill),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 200.w,
                        child: Text("${widget.studentName}",
                            style: GoogleFonts.spaceGrotesk(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: ColorUtils.BLACK,
                                    fontWeight: FontWeight.w700)))),
                    SizedBox(
                      height: 6.h,
                    ),
                    widget.is_fees_paid == false
                        ? Text("No Pending Fees")
                        : Row(
                      children: [
                        SizedBox(
                          child: Text(
                            "AED : ",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            "${widget.Fees}",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: ColorUtils.MAIN_COLOR,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              indent: 20,
              endIndent: 20,
              height: 20,
            ),
            SizedBox(
              height: 25.h,
            ),
            widget.parentName!.isEmpty ? Text("") : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.h,
                      child: SvgPicture.asset(
                        "assets/images/profileOne.svg",
                        color: ColorUtils.PROFILE_COLOR,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 150.w,
                            child: Text("${widget.parentName}",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: ColorUtils.BLACK,
                                        fontWeight: FontWeight.bold)))),
                        SizedBox(
                          height: 6.h,
                        ),
                        SizedBox(
                          child: Text(
                            "${widget.ParentContact}",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Utils.call("${widget.ParentContact}"),
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    child: SvgPicture.asset(
                      "assets/images/callButtonTwo.svg",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.h,
                      child: SvgPicture.asset(
                        "assets/images/profileTwo.svg",
                        color: ColorUtils.MAIN_COLOR,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // width: 150.w,
                            child: Text("${widget.motherName}",
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: ColorUtils.BLACK,
                                        fontWeight: FontWeight.bold)))),
                        SizedBox(
                          height: 6.h,
                        ),
                        SizedBox(
                          child: Text(
                            "${widget.motherPhone}",
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Utils.call("${widget.motherPhone}"),
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    child: SvgPicture.asset(
                      "assets/images/callButtonOne.svg",
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 25.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150.w,
                  height: 38.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: ColorUtils.CALL_STATUS, elevation: 2),
                    onPressed: () => NavigationUtils.goNext(
                        context,
                        HistoryOfStudentActivity(
                          mobileNumber: widget.ParentContact,
                          loginUserName: widget.name,
                          classOfStudent: widget.ClassAndBatch,
                          parentName: widget.parentName,
                          TeacherProfile: widget.images,
                          studentName: widget.studentName,
                          logedinEmployeecode: widget.employeeCode,
                          admissionNumber: widget.AdmissionNumber,
                          studentFees: widget.Fees,
                          StudentImage: widget.image,
                          motherName: widget.motherName,
                          motherPhone: widget.motherPhone,
                        )),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/icon.svg",
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Text(
                          "Call Status",
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.is_fees_paid == false
                    ? Text("")
                    : Container(
                  margin: EdgeInsets.only(top: 12.h),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white, elevation: 0),
                    onPressed: () => NavigationUtils.goNext(
                        context,
                        HistoryPage(
                          mobileNumber: widget.ParentContact,
                          loginUserName: widget.name,
                          classOfStudent: widget.ClassAndBatch,
                          parentName: widget.parentName,
                          TeacherProfile: widget.teacherimage,
                          studentName: widget.studentName,
                          logedinEmployeecode: widget.employeeCode,
                          admissionNumber: widget.AdmissionNumber,
                          studentFees: widget.Fees,
                          StudentImage: widget.image,
                        )),
                    child: SvgPicture.asset(
                      "assets/images/Add.svg",
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

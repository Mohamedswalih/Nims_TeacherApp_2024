
import 'package:bmteacher/exports.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/utils.dart';
import '../ui/History/selectpage.dart';
import '../ui/Student_Activity/history_list.dart';

class BottomCard extends StatelessWidget {
  String? image;
  String? studentName;
  bool? is_fees_paid;
  String? fees;
  String? parentName;
  String? parentContact;
  String? teacherName;
  String? teacherImage;
  String? classOfstudent;
  String? employeeCode;
  String? admissionNumber;

  BottomCard(
      {this.image,
      this.teacherImage,
      this.admissionNumber,
      this.classOfstudent,
      this.employeeCode,
      this.studentName,
      this.is_fees_paid,
      this.fees,
      this.parentContact,
      this.parentName,
      this.teacherName});

  @override
  Widget build(BuildContext context) {
    print("hhdhhdh");
    return Scaffold(

        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(image!), fit: BoxFit.fill),
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
                                child: Text(studentName!,
                                    style: GoogleFonts.spaceGrotesk(
                                        textStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color: ColorUtils.BLACK,
                                            fontWeight: FontWeight.bold)))),
                            SizedBox(
                              height: 6.h,
                            ),
                            is_fees_paid == false
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
                                          fees!,
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
                    Row(
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
                                    child: Text(parentName!,
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
                                    parentContact!,
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Utils.call(parentContact!),
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
                      height: 3.h,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    // result == null || result["data"] == null ? Center(child: CircularProgressIndicator(),) : result["data_status"] == 0 ? Center(child: Text("No Feedback Available")) : SizedBox(
                    //   height: 150.h,
                    //   child: ListView.builder(
                    //       shrinkWrap: true,
                    //       scrollDirection: Axis.vertical,
                    //       itemCount: result!["data"].length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             SizedBox(height: 15.h,),
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(result!["data"][index]["Feeback_type"] == 1 ? "Committed Calls" : result!["data"][index]["Feeback_type"] == 2 || result!["data"][index]["Feeback_type"] == 3 ? "Invalid or Wrong Number" : result!["data"][index]["Feeback_type"] == 4 ? "Call Not Answered" : "Misbehaved",style: TextStyle(color: Colors.blueGrey)),
                    //                 Image.asset(result!["data"][index]["Feeback_type"] == 1 ? "assets/images/committed.png" : result!["data"][index]["Feeback_type"] == 2 || result!["data"][index]["Feeback_type"] == 3 ? "assets/images/invalidcall.png" : result!["data"][index]["Feeback_type"] == 4 ? "assets/images/callnotanswered.png" : "assets/images/mis.png",height: 50.h,width: 50.h,)
                    //               ],
                    //             ),
                    //             SizedBox(height: 5.h,),
                    //             Container(
                    //               width: MediaQuery.of(context).size.width,
                    //               //margin: EdgeInsets.only(left: 20.w, right: 20.w),
                    //               decoration: BoxDecoration(
                    //                   color: ColorUtils.TEXTFIELD,
                    //                   border: Border.all(color: ColorUtils.BLUE),
                    //                   borderRadius: BorderRadius.all(Radius.circular(10.r))),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.all(10.0),
                    //                 child: Column(
                    //                   mainAxisAlignment: MainAxisAlignment.start,
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   children: [
                    //                     const Text(
                    //                       "Remark",
                    //                       style: TextStyle(color: Colors.blueGrey),
                    //                     ),
                    //                     Container(
                    //                       margin: const EdgeInsets.all(20),
                    //                       child: Text(result!["data"][index]["Feeback_comment"]),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         );
                    //       }
                    //   ),
                    // ),
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
                                  mobileNumber: parentContact,
                                  loginUserName: teacherName,
                                  classOfStudent: classOfstudent,
                                  parentName: parentName,
                                  TeacherProfile: teacherImage,
                                  studentName: studentName,
                                  logedinEmployeecode: employeeCode,
                                  admissionNumber: admissionNumber,
                                  studentFees: fees,
                                  StudentImage: image,
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
                        is_fees_paid == false
                            ? Text("")
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white, elevation: 0),
                                onPressed: () => NavigationUtils.goNext(
                                    context,
                                    HistoryPage(
                                      mobileNumber: parentContact,
                                      loginUserName: teacherName,
                                      classOfStudent: classOfstudent,
                                      parentName: parentName,
                                      TeacherProfile: teacherImage,
                                      studentName: studentName,
                                      logedinEmployeecode: employeeCode,
                                      admissionNumber: admissionNumber,
                                      studentFees: fees,
                                      StudentImage: image,
                                    )),
                                child: SvgPicture.asset(
                                  "assets/images/Add.svg",
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

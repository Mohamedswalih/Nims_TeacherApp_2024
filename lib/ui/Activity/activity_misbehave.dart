import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';

class ActivityMisbehave extends StatefulWidget {
  String? LoginedInEmployeeCode;
  ActivityMisbehave({Key? key, this.LoginedInEmployeeCode}) : super(key: key);

  @override
  _ActivityMisbehaveState createState() => _ActivityMisbehaveState();
}

class _ActivityMisbehaveState extends State<ActivityMisbehave> {
  Map<String, dynamic>? studentList;

  Future studentActivities() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_token = preferences.getString("school_token");
    print("api worked");
    var headers = {
      'Content-Type': 'application/json',
      'API-Key': '525-777-777'
    };
    var request = http.Request('POST', Uri.parse(ApiConstants.DOCME_URL));
    request.body =
        '''{\n  "action" :"getEmployeeFeedbackById",\n  "token":"$school_token",\n  "employee_code": "${widget.LoginedInEmployeeCode}",\n  "feedback_type_id": [5,6,7]\n }\n''';
    print(request.body);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode);
      // print(await response.stream.bytesToString());
      var responseJson = await response.stream.bytesToString();
      setState(() {
        studentList = json.decode(responseJson);
      });
      print(studentList);
    } else {
      return Text("Failed to Load Data");
    }
  }

  @override
  void initState() {
    studentActivities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return studentList == null
        ? Center(child: Image.asset("assets/images/Loading.gif"))
        : studentList!["data_status"] == 0
            ? Center(child: Image.asset("assets/images/nodata.gif"))
            : ListView(
                children: [
                  if (studentList != null)
                    for (var index = 0;
                        index < studentList!["data"].length;
                        index++)
                      _getProfileOfStudents(
                          studentList!["data"][index]["student_name"],
                          studentList!["data"][index]
                              ["feedback_committed_date"],
                          studentList!["data"][index]["Class"] +
                              studentList!["data"][index]["Division"],
                          studentList!["data"][index]["feedback_comment"],
                          "assets/images/nancy.png"),
                  SizedBox(
                    height: 200.h,
                  )
                ],
              );
  }

  Widget _getProfileOfStudents(
      String StudentName, timeAndDate, classAndDivision, remark, String image) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: ColorUtils.ICON_COLOR,
        leading: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.r)),
          ),
          margin: EdgeInsets.only(top: 5.h),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50.r)),
              child: Image.asset(
                image,
                width: 50.w,
                height: 50.h,
                fit: BoxFit.fill,
              )),
        ),
        title: Row(
          children: [
            Container(
                width: 180.w,
                child: Text(StudentName,
                    style: GoogleFonts.spaceGrotesk(
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            color: ColorUtils.BLACK,
                            fontWeight: FontWeight.bold)))),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              timeAndDate,
              style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                      fontSize: 12.sp, color: ColorUtils.BLACK_GREY100)),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              classAndDivision,
              style: GoogleFonts.nunitoSans(
                  textStyle:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        children: [
          Container(
            width: 243.w,
            decoration: BoxDecoration(
                color: ColorUtils.TEXTFIELD,
                border: Border.all(color: ColorUtils.BLUE),
                borderRadius: BorderRadius.all(Radius.circular(10.r))),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Remark",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Text(remark),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

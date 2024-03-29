import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/utils.dart';

class CommittedPage extends StatefulWidget {
  String? admissionNumber;
  String? employeeCode;
  String? nameOfLoginTeacher;
  String? fees;

  CommittedPage(
      {Key? key,
      this.admissionNumber,
      this.employeeCode,
      this.nameOfLoginTeacher,
      this.fees})
      : super(key: key);

  @override
  State<CommittedPage> createState() => _CommittedPageState();
}

class _CommittedPageState extends State<CommittedPage> {
  var remarkController = TextEditingController();
  bool isPresses = false;

  getCurrentDate() {
    final DateFormat formatter = DateFormat('d-MMMM-y');
    String createDate = formatter.format(DateTime.now());
    return createDate;
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    DateTime myDate = DateTime.now();
    DateTime myDateWithSixMonthsAdded = myDate.add(Duration(days: 180));
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: myDateWithSixMonthsAdded);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  SubmitRequest() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_token = preferences.getString("school_token");
    print(widget.nameOfLoginTeacher);
    var url = Uri.parse(ApiConstants.DOCME_URL);
    var header = {
      "API-Key": "525-777-777",
      "Content-Type": "application/json",
    };
    final bdy = jsonEncode({
      "action": "addArrearFollowupData",
      "token": school_token,
      "admn_no": widget.admissionNumber,
      "employee_name": widget.nameOfLoginTeacher,
      "date": getCurrentDate().toString(),
      "feedback": remarkController.text,
      "commited_date": "${selectedDate.toLocal()}".split(' ')[0],
      "status": "1",
      "employee_code": widget.employeeCode,
      "followup_fee_amount": widget.fees
    });
    print(bdy);
    var jsonresponse = await http.post(url, headers: header, body: bdy);
    print(jsonresponse.body);
    if (jsonresponse.statusCode == 200) {
      Utils.showToastSuccess("Submitted Successfully").show(context).then((_) {
        NavigationUtils.goBack(context);
      });
      // submitFailed();
      print("success");
    } else {
      Utils.showToastError("Submit Failed").show(context).then((_) {
        NavigationUtils.goBack(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width(BuildContext context) => MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Committed Date",
                  style: TextStyle(color: Colors.blueGrey),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 22.w, right: 22.w),
            child: _getCalendarView(context),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: width(context) * 0.035,
                      right: width(context) * 0.035),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(1.0, 3.0), //(x,y)
                          blurRadius: 40),
                    ],
                  ),
                  child: _getRemark(),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Center(
                  child: isPresses
                      ? CircularProgressIndicator(
                          color: Color(0xFF6FDCFF),
                        )
                      : GestureDetector(
                          onTap: () async {
                            if (remarkController.text == null ||
                                remarkController.text.isEmpty) {
                              Utils.showToastError(
                                      "Please Fill the Required Field")
                                  .show(context);
                            } else {
                              setState(() {
                                isPresses = true;
                              });
                              SubmitRequest();
                            }
                          },
                          child: SizedBox(
                            height: 60.h,
                            width: 327.w,
                            child: Center(
                              child: Image.asset(
                                  "assets/images/committedCalls.png"),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  submitFailed() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: const Text('Warning'),
                content: const Text('Hi this is Flutter Alert Dialog'),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        NavigationUtils.goBack(context);
                      })
                ],
              ),
            ));
  }

  Widget _getRemark() => Container(
        padding: EdgeInsets.symmetric(
            horizontal: Utils.getWidth(20), vertical: Utils.getHeight(10)),
        decoration: BoxDecoration(
            color: ColorUtils.WHITE,
            border: Border.all(color: ColorUtils.BLUE),
            // boxShadow: [
            //   BoxShadow(color: ColorUtils.SHADOW_COLOR, blurRadius: 20)
            // ],
            borderRadius: BorderRadius.all(
              Radius.circular(14.r),
            )),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: remarkController,
                maxLength: 100,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Remarks",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: false,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _getCalendarView(BuildContext context) => GestureDetector(
        onTap: () => _selectDate(context),
        child: Container(
          width: 326.w,
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: ColorUtils.BLUE,
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                "${selectedDate.toLocal().toString().split(' ')[0].toString().split('-').last}-${selectedDate.toLocal().toString().split(' ')[0].toString().split('-')[1]}-${selectedDate.toLocal().toString().split(' ')[0].toString().split('-').first}",
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              )),
        ),
      );
  _submitFailed(context) {
    return Alert(
      context: context,
      type: AlertType.success,
      title: "Submitted Successfully",
      style: AlertStyle(
          isCloseButton: false,
          titleStyle: TextStyle(color: Color.fromRGBO(66, 69, 147, 7))),
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            "",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
          // print(widget.academicyear);
          //width: 120,
        )
      ],
    ).show();
  }
}

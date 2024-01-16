import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/utils.dart';
import 'check_box.dart';

class WrongOrInvalid extends StatefulWidget {
  String? admissionNumber;
  String? employeeCode;
  String? nameOfLoginTeacher;
  String? fees;
  WrongOrInvalid(
      {Key? key,
      this.admissionNumber,
      this.nameOfLoginTeacher,
      this.employeeCode,
      this.fees})
      : super(key: key);

  @override
  _WrongOrInvalidState createState() => _WrongOrInvalidState();
}

class _WrongOrInvalidState extends State<WrongOrInvalid> {
  int selectedIndex = -1;
  bool isPresses = false;

  String? _getText(int index) {
    if (index == 0) return "Wrong";
    if (index == 1) return "Invalid";
  }

  getCurrentDate() {
    final DateFormat formatter = DateFormat('d-MMMM-y');
    String createDate = formatter.format(DateTime.now());
    return createDate;
  }

  SubmitRequest() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_token = preferences.getString("school_token");
    var newValue;
    if (selectedIndex == 0) {
      newValue = 2;
    } else if (selectedIndex == 1) {
      newValue = 3;
    } else {
      newValue = null;
    }
    var remark;
    if (selectedIndex == 0) {
      remark = "Wrong";
    } else if (selectedIndex == 1) {
      remark = "Invalid";
    } else {
      return null;
    }
    var url = Uri.parse(ApiConstants.DOCME_URL);
    var header = {
      "API-Key": "525-777-777",
      "Content-Type": "application/json",
    };
    final bdy = jsonEncode({
      "action": "addArrearFollowupData",
      "token": school_token,
      "admn_no": widget.admissionNumber,
      "date": getCurrentDate().toString(),
      "employee_name": widget.nameOfLoginTeacher,
      "feedback": remark,
      "commited_date": getCurrentDate().toString(),
      "status": newValue.toString(),
      "employee_code": widget.employeeCode,
      "followup_fee_amount": widget.fees
    });
    print(bdy);
    var jsonresponse = await http.post(url, headers: header, body: bdy);
    print(jsonresponse.statusCode);
    if (jsonresponse.statusCode == 200) {
      Utils.showToastSuccess("Submitted Successfully").show(context).then((_) {
        NavigationUtils.goBack(context);
      });
      print("submit success");
    } else {
      Utils.showToastError("Submit Failed").show(context).then((_) {
        NavigationUtils.goBack(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.only(left: 20.w),
            child: const Text(
              "Wrong or Invalid",
              style: TextStyle(color: Colors.blueGrey),
            )),
        SizedBox(
          height: 25.h,
        ),
        Container(
          margin: EdgeInsets.only(left: 20.w),
          height: 66.h,
          width: 326.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.w),
            child: Row(
                children: List.generate(
                    2,
                    (index) => Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedIndex == index)
                                  selectedIndex = -1;
                                else {
                                  selectedIndex = index;
                                }
                                print(selectedIndex);
                              });
                            },
                            child: Row(
                              children: [
                                CheckBoxView(
                                    size: 25,
                                    borderRadius: 10,
                                    isChecked: index == selectedIndex),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                    child: _text(_getText(index).toString()))
                              ],
                            ),
                          ),
                        ))),
          ),
          decoration: const BoxDecoration(
              color: ColorUtils.WHITE,
              // boxShadow: [
              //   BoxShadow(color: ColorUtils.SHADOW_COLOR, blurRadius: 20)
              // ],
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              )),
        ),
        SizedBox(
          height: 120.h,
        ),
        Center(
          child: isPresses
              ? CircularProgressIndicator(
                  color: Color(0xFFFF83E4),
                )
              : GestureDetector(
                  onTap: () {
                    if (selectedIndex == -1) {
                      Utils.showToastError("Please choose one option")
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
                      child: Image.asset("assets/images/wrongnumber.png"),
                    ),
                  ),
                ),
        )
      ],
    );
  }

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

  Widget _text(String text) => Text(text,
      style:
          TextStyle(color: ColorUtils.BLUE, fontSize: Utils.getFontSize(14)));
}

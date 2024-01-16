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

class CallNotAnswered extends StatefulWidget {
  String? admissionNumber;
  String? employeeCode;
  String? nameOfLoginTeacher;
  String? fees;

  CallNotAnswered(
      {Key? key,
      this.employeeCode,
      this.nameOfLoginTeacher,
      this.admissionNumber,
      this.fees})
      : super(key: key);

  @override
  State<CallNotAnswered> createState() => _CallNotAnsweredState();
}

class _CallNotAnsweredState extends State<CallNotAnswered> {
  var remarkController = TextEditingController();
  bool isPresses = false;

  getCurrentDate() {
    final DateFormat formatter = DateFormat('d-MMMM-y');
    String createDate = formatter.format(DateTime.now());
    return createDate;
  }

  SubmitRequest() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var school_token = preferences.getString("school_token");
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
      "commited_date": getCurrentDate().toString(),
      "feedback": remarkController.text,
      "status": "4",
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
      print("submit success");
    } else {
      Utils.showToastError("Submit Failed").show(context).then((_) {
        NavigationUtils.goBack(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        //shrinkWrap: true,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Calls Not Answered",
                  style: TextStyle(color: Colors.blueGrey),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: _getRemark(),
          ),
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: isPresses
                ? CircularProgressIndicator(
                    color: Color(0xFFFFBF60),
                  )
                : GestureDetector(
                    onTap: () {
                      if (remarkController.text == null ||
                          remarkController.text.isEmpty) {
                        Utils.showToastError("Please Fill the Required Field")
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
                        child: Image.asset("assets/images/callnotansweres.png"),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
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
                maxLines: null,
                maxLength: 100,
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

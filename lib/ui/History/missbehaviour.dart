import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Network/api_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/constants.dart';
import '../../Utils/navigation_utils.dart';
import '../../Utils/utils.dart';

class misbehav extends StatefulWidget {
  String? admissionNumber;
  String? employeeCode;
  String? nameOfLoginTeacher;
  String? fees;

  misbehav(
      {Key? key,
      this.nameOfLoginTeacher,
      this.employeeCode,
      this.admissionNumber,
      this.fees})
      : super(key: key);

  @override
  _misbehavState createState() => _misbehavState();
}

class _misbehavState extends State<misbehav> {
  var remarkController = TextEditingController();
  bool isPresses = false;

  var dropdownValue;
  var dropDownList = [
    {"id": "5", "status": "Abusive language"},
    {"id": "6", "status": "Did not agree to pay fees"},
    {"id": "7", "status": "Advised a call from higher authority"}
  ];

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
    var bdy = {
      "action": "addArrearFollowupData",
      "token": school_token,
      "admn_no": widget.admissionNumber,
      "date": getCurrentDate().toString(),
      "feedback": remarkController.text,
      "employee_name": widget.nameOfLoginTeacher,
      "status": dropdownValue.toString(),
      "commited_date": getCurrentDate().toString(),
      "employee_code": widget.employeeCode,
      "followup_fee_amount": widget.fees
    };
    print(bdy);
    var _encoded_req = json.encode(bdy);
    var jsonresponse =
        await http.post(url, headers: header, body: _encoded_req);
    print(jsonresponse.body);
    if (jsonresponse.statusCode == 200) {
      if (mounted) {
        Utils.showToastSuccess("Submitted Successfully")
            .show(context)
            .then((_) {
          NavigationUtils.goBack(context);
        });
      }
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Utils.getWidth(20), vertical: Utils.getHeight(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _getMisbehaviourText(),
              verticalSpace(Utils.getHeight(10)),
              _getTypesView(),
              verticalSpace(Utils.getHeight(10)),
              _getRemark(),
              SizedBox(
                height: 6.h,
              ),
              Center(
                child: isPresses
                    ? CircularProgressIndicator(
                        color: Color(0xFFFEA2A2),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (dropdownValue == null) {
                            Utils.showToastError(
                                    "Please select one option to continue")
                                .show(context);
                          } else {
                            print(dropdownValue == null);
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
                          }
                        },
                        child: SizedBox(
                          height: 60.h,
                          width: 327.w,
                          child: Center(
                            child: Image.asset("assets/images/misbehave.png"),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _getMisbehaviourText() => Text(
        "Misbehaviour",
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: Utils.getFontSize(16),
          fontFamily: Constants.axiforma,
        ),
      );
  Widget _getTypesView() => Container(
        alignment: Alignment.center,
        height: Utils.getHeight(50),
        padding: EdgeInsets.symmetric(horizontal: Utils.getWidth(20)),
        child: _DropDownListData(),
        decoration: BoxDecoration(
            color: ColorUtils.WHITE,
            borderRadius: BorderRadius.all(
              Radius.circular(14.r),
            )),
      );

  Widget _DropDownListData() {
    return DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue,
        hint: const Text("Misbehaviour"),
        icon: const Icon(
          Icons.arrow_drop_down,
          size: 40,
          color: Colors.blueGrey,
        ),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.blueGrey),
        underline: Container(
          color: Colors.transparent,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue;
            print(dropdownValue);
          });
        },
        items: dropDownList.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    item['status'].toString(),
                    maxLines: 1,
                  )),
              value: item["id"]);
        }).toList());
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

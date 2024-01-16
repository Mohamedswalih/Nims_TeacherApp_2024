
import 'package:bmteacher/exports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../History/constant.dart';
import 'image_viewer.dart';


class LeaveApprovall extends StatefulWidget {
  final List studentDataasforleave;
  LeaveApprovall({Key? key, required this.studentDataasforleave}) : super(key: key);

  @override
  State<LeaveApprovall> createState() => _LeaveApprovallState();
}

class _LeaveApprovallState extends State<LeaveApprovall> {
  bool isSpinner = false;
  List newResult = [];
  var _searchController = TextEditingController();
  var _reasontextController = new TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _reasonFocusNode = FocusNode();

  @override
  void dispose() {
    _removeKeyboard();
    _focusNode.dispose();
    _reasonFocusNode.dispose();
    _searchController.dispose();
    _reasontextController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LeaveApprovall oldWidget) {
    _initialize();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _initialize();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print('Leaveapproval list-----------${widget.studentDataasforleave}');
    super.initState();
    _saveKeyboard();
  }

  _saveKeyboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _focusNode.addListener(() async {
      await prefs.setBool("keyboard", true);
    });
    _reasonFocusNode.addListener(() async {
      await prefs.setBool("keyboard", true);
    });
  }
  _removeKeyboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("keyboard");
  }

  _initialize() {
    _reasontextController.clear();
    if (widget.studentDataasforleave.isEmpty ) {
      setState(() {
        isSpinner = false;
      });
    }
    setState(() {
      newResult = widget.studentDataasforleave;
    });
    // newResult = leaveapprovelist;
    print('Leaveapproval list-----------${widget.studentDataasforleave}');
    if (newResult.isEmpty) {
    }
    setState(() {
      isSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
            child: TextFormField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: (value) {
                setState(() {
                  print('lllllllleave${widget.studentDataasforleave}');
                  print("runtimetype${value}");
                  // print("runtimetypeval${valueeeeeee.runtimeType}");
                  if (value.contains('1') ||
                      value.contains('2') ||
                      value.contains('3') ||
                      value.contains('4') ||
                      value.contains('5') ||
                      value.contains('6') ||
                      value.contains('7') ||
                      value.contains('8') ||
                      value.contains('9') ||
                      value.contains('0')) {
                    newResult = widget.studentDataasforleave
                        .where((element) =>
                        element["admission_number"]
                            .contains("${value.toString()}"))
                        .toList();
                    log("the new result is  valueeeee $newResult");
                  } else {
                    newResult = widget.studentDataasforleave
                        .where((element) =>
                    element["studentName"]
                        .toString()
                        .toLowerCase()
                        .replaceAll(" ", '')
                        .startsWith("$value") ||
                        element["studentName"]
                            .toString()
                            .toLowerCase()
                            .startsWith("$value"))
                        .toList();
                    log("the new result is   $newResult");
                  }
                  // print(leaveapprovelist);
                  // newResult = leaveapprovelist
                  //     .where((element) => element["studentname"]
                  //         .contains("${value.toUpperCase()}"))
                  //     .toList();
                  //newResult = afterAttendanceTaken.where((element) => element["feeDetails"]["username"].contains("${value.toUpperCase()}")).toList();
                  //print(_searchController.text.toString());
                  log("the new result is   $newResult");
                });
              },
              validator: (val) =>
              val!.isEmpty ? 'Enter the Topic' : null,
              cursorColor: Colors.grey,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "Search Here",
                  prefixIcon: Icon(
                    Icons.search,
                    color: ColorUtils.SEARCH_TEXT_COLOR,
                  ),
                  // suffixIcon: GestureDetector(
                  //   onTap: () => onListen(),
                  //   child: AvatarGlow(
                  //     animate: _isListening,
                  //     glowColor: Colors.blue,
                  //     endRadius: 20.0,
                  //     duration: Duration(milliseconds: 2000),
                  //     repeat: true,
                  //     showTwoGlows: true,
                  //     repeatPauseDuration:
                  //         Duration(milliseconds: 100),
                  //     child: Icon(
                  //       _isListening == false
                  //           ? Icons.keyboard_voice_outlined
                  //           : Icons.keyboard_voice_sharp,
                  //       color: ColorUtils.SEARCH_TEXT_COLOR,
                  //     ),
                  //   ),
                  // ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(230, 236, 254, 8),
                        width: 1.0),
                    borderRadius:
                    BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(230, 236, 254, 8),
                        width: 1.0),
                    borderRadius:
                    BorderRadius.all(Radius.circular(10.0)),
                  ),
                  fillColor: Color.fromRGBO(230, 236, 254, 8),
                  filled: true),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            height: 550.h,
            child:  isSpinner
                ? Container(
              color: Colors.white,
              height: 580.h,
            )
                : newResult.isEmpty
                ? Center(
                child: Image.asset("assets/images/nodata.gif")
            )
                : ListView.builder(
              shrinkWrap: true,
              itemCount: newResult.length,
              itemBuilder:
                  (BuildContext context, int index) {
                return _leaveApproval(
                  studentNAme: newResult[index]
                  ['studentName'],
                  fromdate: newResult[index]['startDate'],
                  todate: newResult[index]['endDate'],
                  totaldays: newResult[index]['days'],
                  classNaMe: newResult[index]['class'],
                  batchNaMe: newResult[index]['batch'],
                  leavereason: newResult[index]['reason'],
                  admissionNuMber: newResult[index]
                  ['admission_number'],
                  applieddate: newResult[index]
                  ['applyDate'],
                  academicyear: newResult[index]
                  ['academic_year'],
                  i: index,
                  leaveId: newResult[index]['_id'],
                  studimage: newResult[index]
                  ['profileImage'],
                  document: newResult[index]
                  ['documentPath'],
                  mypendings: newResult[index]
                  ['myPending'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaveApproval(
      {String? studimage,
        int? i,
        String? leaveId,
        String? document,
        bool? mypendings,
        String? academicyear,
        String? admissionNuMber,
        String? studentNAme,
        String? fromdate,
        String? todate,
        var totaldays,
        String? classNaMe,
        String? batchNaMe,
        String? leavereason,
        String? applieddate}) =>
      Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          // Divider(color: Colors.black26,height: 2.h,),

          GestureDetector(
            onTap: () async {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back_outlined)),
                      SizedBox(
                        width: 35.w,
                      ),
                      Text(
                        'Leave Approval',
                        style: TextStyle(fontSize: 22.sp),
                      ),
                    ],
                  ),
                  content: Container(
                    height: attchIconsize(type: document.toString().split(".").last),
                    // width: 300.w,
                    child: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(studentNAme!, style: TextStyle(fontSize: 18.sp)),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text('Class: ${classNaMe! + " " + batchNaMe!}',
                              style: TextStyle(fontSize: 14)),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text('Reason : ${leavereason!}',
                              style: TextStyle(fontSize: 14)),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                              "Applied On: ${applieddate!.split('T')[0].split('-').last}-${applieddate.split('T')[0].split('-')[1]}-${applieddate.split('T')[0].split('-').first}",
                              style: TextStyle(fontSize: 14)),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              Text(
                                // "From: ${fromdate!.split('T')[0]}",
                                "From: ${fromdate!.split('T')[0].split('-').last}-${fromdate.split('T')[0].split('-')[1]}-${fromdate.split('T')[0].split('-').first}",
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                width: 40.w,
                              ),
                              Text(
                                "To: ${todate!.split('T')[0].split('-').last}-${todate.split('T')[0].split('-')[1]}-${todate.split('T')[0].split('-').first}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          (document != null)
                              ? Row(
                            children: [
                              Text('Document :',
                                  style: TextStyle(fontSize: 14)),
                              GestureDetector(
                                onTap: () async {
                                  await launchUrl(Uri.parse("${ApiConstants.IMAGE_BASE_URL}$document"));
                                },
                                child: attchIcon(type: document.toString().split(".").last, document: document.toString()),
                              ),
                            ],
                          )
                              : Container(),
                          // if(int.parse(totaldays!) < 4)
                          Text(
                            'Remarks',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          // if(int.parse(totaldays) < 4)
                          TextFormField(
                            maxLength: 150,
                            validator: (val) =>
                            val!.isEmpty ? '  *Enter the Reason' : null,
                            controller: _reasontextController,
                            focusNode: _reasonFocusNode,
                            cursorColor: Colors.grey,
                            decoration: dropTextFieldDecoration,
                            keyboardType: TextInputType.text,
                            maxLines: 5,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 40.w,
                              ),
                              // if(int.parse(totaldays!) < 4)
                              GestureDetector(
                                onTap: () {
                                  print('approvedddddddd');
                                  Navigator.pop(context);
                                  submitleavedata(
                                    acadYEAR: academicyear,
                                    leaveIds: leaveId,
                                    apprve: 'Approve',
                                    // Approve: 'Approve',
                                    // Approved: 'Approved',
                                    approved: 'Approved',
                                  )
                                      .then((_) => _initialize());
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => leaveApproval(
                                  //           images: widget.images,
                                  //           name: widget.name,
                                  //         )));
                                },
                                child: Container(
                                    height: 40.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Approve',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    )),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              // if(int.parse(totaldays) < 4)
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  submitleavedata(
                                      acadYEAR: academicyear,
                                      leaveIds: leaveId,
                                      apprve: 'Reject',
                                      approved: 'Rejected')
                                      .then((_) => _initialize());
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => leaveApproval(
                                  //           images: widget.images,
                                  //           name: widget.name,
                                  //         )));
                                },
                                child: Container(
                                    height: 40.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Reject',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              padding: EdgeInsets.fromLTRB(5, 20, 10, 10),
              width: MediaQuery.of(context).size.width,
              // height: 120.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.black26),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFFD6E4FA)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            width: 50,
                            height: 50,
                            fit: BoxFit.fill,
                            imageUrl:
                            ApiConstants.IMAGE_BASE_URL + "${studimage}",
                            placeholder: (context, url) => Center(
                              child: Text(
                                '${studentNAme!.split(' ')[0].toString()[0]}'
                                    // '${studentNAme.split(' ')[1].toString()[0]}'
                                ,
                                style: TextStyle(
                                    color: Color(0xFFB1BFFF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Text(
                                '${studentNAme!.split(' ')[0].toString()[0]}'
                                    // '${studentNAme.split(' ')[1].toString()[0]}'
                                ,
                                style: TextStyle(
                                    color: Color(0xFFB1BFFF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   child:Container(
                      //       width: 50.w,
                      //       height: 50.h,
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         border: Border.all(color: Color(0xFFD6E4FA)),
                      //         image: DecorationImage(
                      //           image: NetworkImage(studimage == ""
                      //               ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                      //               : ApiConstants.IMAGE_BASE_URL +
                      //                   "${studimage}"),
                      //         ),
                      //       ),
                      //     ),
                      //   ),

                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 240.w,
                              child: Text(
                                studentNAme!,
                                // 'NASRUDHEEN MOHAMMED ALI',
                                style: TextStyle(fontSize: 13),
                              )),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              Text(
                                admissionNuMber!,
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(
                                width: 60.w,
                              ),
                              Text(
                                'Class: ${classNaMe! + " " + batchNaMe!}',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: [
                              Text(
                                "From: ${fromdate!.split('T')[0].split('-').last}-${fromdate.split('T')[0].split('-')[1]}-${fromdate.split('T')[0].split('-').first}",
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "To: ${todate!.split('T')[0].split('-').last}-${todate.split('T')[0].split('-')[1]}-${todate.split('T')[0].split('-').first}",
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Center(
                                    child: Text(
                                      '$totaldays',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 13),
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          (document != null)
                              ? Row(
                            children: [
                              Text('Document :'),
                              Container(
                                height: 50.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            ApiConstants.IMAGE_BASE_URL +
                                                "${document}")),
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                // child: CachedNetworkImage(
                                //   imageUrl: ApiConstants.IMAGE_BASE_URL +"${document}",
                                //   placeholder: (context, url) => Text(
                                //     '',
                                //     style: TextStyle(
                                //         color: Color(0xFFB1BFFF),
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20),
                                //   ),
                                //   errorWidget: (context, url, error) =>   Text(
                                //     '',
                                //     style: TextStyle(
                                //         color: Color(0xFFB1BFFF),
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20),
                                //   ),
                                // ),
                              ),
                            ],
                          )
                              : Container(),
                          if(mypendings == true)
                            Padding(
                              padding: const EdgeInsets.only(left: 140),
                              child: Container(
                                  height: 40.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      color: Colors.red[500],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                            color: ColorUtils.WHITE),
                                      ))),
                            ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      );

  Future submitleavedata(
      {String? acadYEAR,
        String? leaveIds,
        String? apprve,
        String? approved}) async {
    setState(() {
      isSpinner = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var schoolID = preferences.getString('school_id');
    var academicyear = preferences.getString('academic_year');
    print("____---shared$schoolID");
    print("____---user$userID");
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var body = {
      "user_id": userID,
      "school_id": schoolID,
      "academic_year": acadYEAR,
      "leaveID": leaveIds,
      "approvedBy": userID,
      "actionItem": {
        "actionItem": apprve,
        // "actionItem": "Reject / Approve",
        // "actionstatus": "Rejected / Approved",
        "actionstatus": approved,
        "commentItem": _reasontextController.text
      },
      "commentItem": _reasontextController.text
    };
    print('---b-o-d-y-LLeaavve--${body}');
    var request = await http.post(Uri.parse(ApiConstants.LeaveApprovalRequest),
        headers: headers, body: json.encode(body));
    var response = json.decode(request.body);
    if (response['status']['code'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response['data']['message']}'),backgroundColor: Colors.green,
      ));
    }
    log('----------rsssssbdyy${response}');
    setState(() {
      isSpinner = false;
    });
  }
  Widget attchIcon({String? type, String? document}) {
    if (type == 'jpg' || type == 'jpeg' || type == 'png') {
      return Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("${ApiConstants.IMAGE_BASE_URL}$document")),
            borderRadius: BorderRadius.circular(10)),
      );
    } else if (type == 'pdf') {
      return const Icon(Icons.picture_as_pdf, color: Colors.red,);
    } else {
      return Icon(Icons.attach_file, color: Colors.lightBlue.shade100,);
    }
  }
  double attchIconsize({String? type, String? document}) {
    if (type == 'jpg' || type == 'jpeg' || type == 'png') {
      return 500.h;
    } else if (type == 'pdf') {
      return 400.h;
    } else {
      return 400.h;
    }
  }
}

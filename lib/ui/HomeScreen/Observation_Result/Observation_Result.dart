
import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:bmteacher/exports.dart';
import 'package:bmteacher/ui/HomeScreen/Observation_Result/result_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Network/api_constants.dart';
import '../../../Utils/color_utils.dart';
import '../../Leadership/Leadership.dart';
import 'NewLearningWalk_ObservationResult.dart';
class observationResult extends StatefulWidget {
  var loginedUserName;
  String? images;
  String? name;
   observationResult({Key? key,
     this.loginedUserName,
     this.images,
     this.name,
   }) : super(key: key);

  @override
  State<observationResult> createState() => _observationResultState();
}

class _observationResultState extends State<observationResult> {
  bool isSpinner = false;
  var nodata = ' ';
  Map<String, dynamic>? ObservationData;
  // Map<String, dynamic>? ObservationDataList;
  var ObservationDataList = [];
  var count;
  int Count = 0;
  var IMAGE;
  Map<String, dynamic>? notificationResult;
  getNotification() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var loginname = preferences.getString('name');
    print('userIDuserIDuserID$userID');
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'GET',

        Uri.parse(
            '${ApiConstants.Notification}$userID${ApiConstants.NotificationEnd}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var responseJson = await response.stream.bytesToString();
      setState(() {
        notificationResult = json.decode(responseJson);
      });

      for (var index = 0;
      index <
          notificationResult!["data"]["details"]["recentNotifications"]
              .length;
      index++) {
        if (notificationResult!["data"]["details"]["recentNotifications"][index]
        ["status"] ==
            "active") {
          Count += 1;
        }
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt("count", Count);

      print(Count);
    } else {
      print(response.reasonPhrase);
    }
  }
  getCount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      count = preferences.get("count");
    });
  }

  Timer? timer;
  void initState() {
    getObservationdata();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getCount());
    getNotification();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }
  Future getObservationdata() async {
    print('callingdetdata');
    setState(() {
      isSpinner = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userID = preferences.getString('userID');
    var schoolID = preferences.getString('school_id');
    var academicyear = preferences.getString('academic_year');
    print("____---shared$schoolID");
    print("____---user$userID");
    print("____---academic$academicyear");
    var headers = {
      'x-auth-token': 'tq355lY3MJyd8Uj2ySzm',
      'Content-Type': 'application/json'
    };
    var body = {
      "school_id": schoolID,
      "academic_year": academicyear,
      "teacher_id": userID,
    };
    print('-body__Observation$body');
    var request = await http.post(Uri.parse(ApiConstants.Observationlist),
        headers: headers, body: json.encode(body));
    var response = json.decode(request.body);
    // print('------------api response---------------$response');
    ObservationData = response;
    ObservationDataList = response['data']['details'];
    // ObservationDataList.sort((a, b) => a.date_of_observation.compareTo(b.date_of_observation));
    ObservationDataList.sort((a, b) =>
        DateTime.parse(b['date_of_observation']).compareTo(DateTime.parse(a['date_of_observation'])));

    // Print the sorted list
    ObservationDataList.forEach((observation) {
      print("Date: ${observation['date_of_observation']}}");
    });

    print('------------api response---------------$ObservationData');
    print('------------ObservationDataList---------------$ObservationDataList');
    if (ObservationDataList.isEmpty ) {
      setState(() {
        isSpinner = false;
      });
      nodata = 'No Data';
    }
    setState(() {
      isSpinner = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.BACKGROUND,
      body: LoadingOverlay(
        opacity: 0,
        isLoading: isSpinner,
        progressIndicator: CircularProgressIndicator(),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/images/header.png",
                      fit: BoxFit.fill,
                    )),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => ZoomDrawer.of(context)!.toggle(),
                      child: Container(
                          margin: const EdgeInsets.all(6),
                          child: Image.asset("assets/images/newmenu.png")),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Hello,",
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontSize: 15.sp,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            width: 150.w,
                            height: 40.h,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                widget.loginedUserName,
                                style: TextStyle(
                                    fontFamily: "WorkSans",
                                    fontSize: 15.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 40.w,
                    ),
                    GestureDetector(
                      onTap: () => NavigationUtils.goNext(
                          context,
                          NotificationPage(
                            name: widget.name,
                            image: widget.images,
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: badges.Badge(
                            position: badges.BadgePosition.bottomEnd(end: -7, bottom: 12),
                            badgeContent: count == null
                                ? Text("")
                                : Text(
                              count.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            child: SvgPicture.asset("assets/images/bell.svg")),
                      ),
                    ),
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFFD6E4FA)),
                        image: DecorationImage(
                            image: NetworkImage(widget.images == ""
                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                : ApiConstants.IMAGE_BASE_URL +
                                "${widget.images}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w, top: 100.h, right: 10.w),
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text(
                                'Observation Result',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          height: 580.h,
                          child: isSpinner
                              ? Container(
                            color: Colors.white,
                              height: 580.h,
                          )
                              : ObservationDataList.isEmpty
                              ? Center(
                              child:
                              Image.asset("assets/images/nodata.gif")
                          )
                              :  ListView.builder(
                            itemCount: ObservationDataList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return
                              // ObservationDataList[index]['type'] != 'LW_NEW'?
                                _resultlist(
                                observer_name: ObservationDataList[index]
                                ['observer_name'],
                                date_of_observation: ObservationDataList[index]['date_of_observation'],
                                subject_name: ObservationDataList[index]['subject_name'],
                                id: ObservationDataList[index]['_id'],
                                type: capitalizeFirstLetters(ObservationDataList[index]['type'].toString().replaceAll('_', ' ')),
                              )
                              // :null
                               ;
                            },

                          ),
                          ),
                        SizedBox(
                          height: 50.h,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String capitalizeFirstLetters(String sentence) {
    if (sentence == null || sentence.isEmpty) {
      return '';
    }

    List<String> words = sentence.split(' ');
    List<String> capitalizedWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        String capitalizedWord =
            word[0].toUpperCase() + word.substring(1).toLowerCase();
        capitalizedWords.add(capitalizedWord);
      }
    }

    return capitalizedWords.join(' ');
  }


  Widget _resultlist({
    String? observer_name,
    int? index,
    String? date_of_observation,
    String? subject_name,
    String? id,
    String? type,
  }) =>


      InkWell(
        onTap: (){
          print('ontapped');
          print('type----$type');
          NavigationUtils.goNext(
              context,
              type != 'Lw New' ?
              resultPage(
                name: widget.name,
                images: widget.images,
                loginedUserName: widget.loginedUserName,
                Subject_name: subject_name,
                Doneby: observer_name,
                Date: date_of_observation,
                Observerid: id,
              ): newLearningwalkResultpage(
                name: widget.name,
                images: widget.images,
                loginedUserName: widget.loginedUserName,
                Subject_name: subject_name,
                Doneby: observer_name,
                Date: date_of_observation,
                Observerid: id,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 160.h,
            // width: 350.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.red,
                border: Border.all(color: Colors.grey)
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,5,0,0),
              child: Column(
                children: [
                  Text(type!,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w900),),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Container(
                        child: Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFFD6E4FA)),
                            // image: DecorationImage(
                            //   image: NetworkImage('studimage' == ""
                            //       ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                            //       : ApiConstants.IMAGE_BASE_URL +
                            //           "${studimage}"),
                            // ),
                          ),
                          child: Center(
                            child:
                            type != 'Lw New' ?
                            CachedNetworkImage(
                              imageUrl:
                              ApiConstants.IMAGE_BASE_URL + "${IMAGE}",
                              placeholder: (context, url) => Text(
                                subject_name!.split(' ')[0].length > 1 ? subject_name.split(' ')[0].toString()[0] :
                                '${subject_name.split(' ')[0].toString()[0]}${subject_name.split(' ')[1].toString()[0]}',
                                style: TextStyle(
                                    color: Color(0xFFB1BFFF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              errorWidget: (context, url, error) => Text(
                                subject_name!.split(' ')[0].length > 1 ? subject_name.split(' ')[0].toString()[0] :
                                '${subject_name.split(' ')[0].toString()[0]}${subject_name.split(' ')[1].toString()[0]}',
                                style: TextStyle(
                                    color: Color(0xFFB1BFFF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ):Text('LW',
                                style: TextStyle(
                                    color: Color(0xFFB1BFFF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              width: 240.w,
                              child:
                                  subject_name != null ?
                              Text(
                                subject_name!,
                                // 'Subject',
                                style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w700),
                              ) : Text(''),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                              width: 260.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Done by:',
                                    // 'Observer Name',
                                    style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    width: 190.w,
                                    child: Text(
                                      '${observer_name!}',
                                      // 'Observer',
                                      style: TextStyle(fontSize: 15.sp,),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                              width: 240.w,
                              child:
                              Text(
                                // date_of_observation!,
                                'on: ${date_of_observation!.split('T')[0].split('-').last}-${date_of_observation.split('T')[0].split('-')[1]}-${date_of_observation.split('T')[0].split('-').first}',
                                // 'Date',
                                style: TextStyle(fontSize: 15.sp),
                              )),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

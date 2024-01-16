import 'dart:math';

import 'package:bmteacher/exports.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:badges/badges.dart' as badges;

import '../Leadership/Leadership.dart';

class chatList extends StatefulWidget {
  String? images;
  String? name;
  chatList({this.name, this.images, super.key});

  @override
  State<chatList> createState() => _chatListState();
}

class _chatListState extends State<chatList>
    with SingleTickerProviderStateMixin {
  bool isSpinner = false;
  late TabController controller;
  var _searchController = TextEditingController();
  String? _textSpeech = "Search Here";
  bool _isListening = false;
  // TabController controller = TabController(length: 2, vsync: vsync);

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorUtils.BACKGROUND,
        body: LoadingOverlay(
            opacity: 0,
            isLoading: isSpinner,
            progressIndicator: CircularProgressIndicator(),
            child: ListView(physics: NeverScrollableScrollPhysics(), children: [
              Stack(children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/images/header.png",
                      fit: BoxFit.fill,
                    )),
                Row(
                  children: [
                    GestureDetector(
                      // onTap: () => ZoomDrawer.of(context)!.toggle(),
                      onTap: () => Navigator.pop(context),
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
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                "widget.loginname.toString()",
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
                            name: 'widget.loginname',
                            image: 'widget.image',
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: badges.Badge(
                            position: badges.BadgePosition.bottomEnd(
                                end: -7, bottom: 12),
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
                            image: NetworkImage('widget.image' == ""
                                ? "https://raw.githubusercontent.com/abdulmanafpfassal/image/master/profile.jpg"
                                : ApiConstants.IMAGE_BASE_URL +
                                    "${'widget.image'}"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 5.w, top: 100.h, right: 5.w),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: ColorUtils.BORDER_COLOR_NEW),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(children: [
                    TabBar(
                      unselectedLabelColor: Color(0xff737CA8),
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)), // Creates border
                          color: Color(0xffFF87A6)),
                      controller: controller,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      tabs: [
                        Tab(
                            child: Text(
                          'Class Group',
                        )),
                        Tab(child: Text('My Subjects')),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (value) {
                          print(value);
                        },
                        validator: (val) =>
                            val!.isEmpty ? 'Enter the Topic' : null,
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText:
                                _isListening ? "Listening..." : "Search Here",
                            prefixIcon: Icon(
                              Icons.search,
                              color: ColorUtils.SEARCH_TEXT_COLOR,
                            ),
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
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(controller: controller, children: [
                        Container(
                          child: ListView.separated(
                            padding: EdgeInsets.only(bottom: 250),
                            itemBuilder: (BuildContext context, int index) {
                              return _classgroupList(index);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Divider(
                                  color: Color(0xffE2EDFF),
                                  indent: 20.0,
                                  endIndent: 20.0,
                                ),
                              );
                            },
                            itemCount: 20,
                          ),
                        ),
                        Container(
                          child: ListView.separated(
                        padding: EdgeInsets.only(bottom: 250),
                            itemBuilder: (BuildContext context, int index) {
                              return _mysubjectList(index);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Divider(
                                  color: Color(0xffE2EDFF),
                                  indent: 20.0,
                                  endIndent: 20.0,
                                ),
                              );
                            },
                            itemCount: 20,
                          ),
                        ),
                      ]),
                    )
                  ]),
                )
              ])
            ])));
  }

  Widget _classgroupList(int index) => Column(
        children: [
          // Divider(color: Colors.black26,height: 2.h,),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            width: 360.w,
            // height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: subColorList[index],
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFFD6E4FA)),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Center(
                              child: Text(
                                '10A',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            )),
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
                            child: Text(
                              'Class Group',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF737CA8)),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Text(
                              'Subject Teacher',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF737CA8),
                              ),
                            ),
                            SizedBox(
                              width: 60.w,
                            ),
                            // Text('Class: ${classNaMe! + " " + batchNaMe!}'),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget _mysubjectList(int index) => Column(
        children: [
          // Divider(color: Colors.black26,height: 2.h,),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            width: 360.w,
            // height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: subColorList[index],
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFFD6E4FA)),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Center(
                              child: Text(
                                '10A',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            )),
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
                            child: Text(
                              'Class Group',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF737CA8)),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Text(
                              'Subject Teacher',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF737CA8),
                              ),
                            ),
                            SizedBox(
                              width: 60.w,
                            ),
                            // Text('Class: ${classNaMe! + " " + batchNaMe!}'),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }
}

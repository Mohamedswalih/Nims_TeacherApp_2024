
import 'package:bmteacher/exports.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';

class rubrics extends StatefulWidget {
  List<dynamic>? rubricslessonob;
  //List<dynamic>? rubicslearningwl;
   rubrics({Key? key,this.rubricslessonob,}) : super(key: key);

  @override

  State<rubrics> createState() => _rubricsState();
}
class _rubricsState extends State<rubrics> {
  @override
  void initState() {
    // TODO: implement initState
    print(widget.rubricslessonob);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(child:Padding(
        padding: EdgeInsets.fromLTRB(20, 60, 20, 30),
        child: Container(
            padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
            height: MediaQuery.of(context).size.height,
            width: 360.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xff312B47),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rubrics', style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for(int i=0;i<widget.rubricslessonob!.length;i++)
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.circle,color: Colors.deepPurpleAccent,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
                                        child:
                                            Text(widget.rubricslessonob![i]['name'].toString().toCapitalCase(), style: TextStyle(fontSize: 14,color: Colors.grey,)),

                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.75,
                                    // width: 280.w,
                                    margin: EdgeInsets.only(left: 30),
                                    child: Text(
                                      widget.rubricslessonob![i]['parameter'],style: TextStyle(fontSize:12 ,color: Colors.grey,),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(left: 120.w,top: 30.h),
                    child: GestureDetector(
                      onTap: ()=> Navigator.pop(context),
                      child: Container(
                        height: 35.h,
                        width: 35.w,
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(100),border: Border.all(color: Colors.grey)),
                   child: Icon(Icons.close,color: Colors.grey,),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
      ),
    );
  }
}

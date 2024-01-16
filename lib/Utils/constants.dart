
import 'package:flutter/material.dart';

import 'color_utils.dart';

class Constants {

  static const String fontMontSerrat = "mont-serrat";
  static const String axiforma = "axiforma";
  static const int TYPE_COMMITTED_DATE = 0;
  static const int TYPE_CALL_NOT_ANSWERED = 1;
  static const int TYPE_WRONG_NUMBER = 2;
  static const int TYPE_MISBEHAVE = 3;
  static const int TYPE_TEACHERS = 4;
  static const int DETAILS_HEADER_HEIGHT = 75;

  static const int STATUS_COMMITTED_DATE = 1;
  static const int STATUS_WRONG_NUMBER = 2;
  static const int STATUS_INVALID_NUMBER = 3;
  static const int STATUS_CALL_NOT_ANSWERED = 4;
  static const int STATUS_ABUSING_LANGUAGE = 5;
  static const int STATUS_DID_NOT_AGREE_TO_PAY = 6;
  static const int STATUS_ADVISED_TO_CALL = 7;

  static const dropTextFieldDecoration = InputDecoration(
      hintStyle: TextStyle(
          color: Colors.grey
      ),
      prefixIcon: Icon(Icons.search, color: ColorUtils.SEARCH_TEXT_COLOR,),
      suffixIcon: Icon(Icons.keyboard_voice_outlined, color: ColorUtils.SEARCH_TEXT_COLOR,),
      contentPadding:
      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0),),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color:Color.fromRGBO(230,236,254,8), width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color:Color.fromRGBO(230,236,254,8), width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      fillColor: Color.fromRGBO(230,236,254,8),
      filled: true
  );

}
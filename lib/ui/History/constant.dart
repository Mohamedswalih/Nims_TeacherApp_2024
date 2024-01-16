import 'package:flutter/material.dart';

final Widget ContainerDefault = Container(
  decoration:
      BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),
);

const TextFieldDecoration = InputDecoration(
  hintText: 'Enter the HintText here',
  hintStyle: TextStyle(color: Color.fromRGBO(133, 135, 186, 10.0)),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(135, 135, 186, 10.0))),
  focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(135, 135, 186, 10.0))),
  enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(135, 135, 186, 10.0))),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'enter',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);
const kTextFieldDecoration1 = InputDecoration(
  hintText: 'enter',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);
const dropTextFieldDecoration = InputDecoration(
    hintStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(0),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(230, 236, 254, 8), width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(230, 236, 254, 8), width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    fillColor: Color.fromRGBO(230, 236, 254, 8),
    filled: true);

var dropFieldDecoration = InputDecoration(
    hintStyle: TextStyle(
      color: Colors.black.withOpacity(0.5),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
    hintText: "Topic",
    counterText: "",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(230, 236, 254, 8), width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(22)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(230, 236, 254, 8), width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    fillColor: Color.fromRGBO(230, 236, 254, 8),
    filled: true);
const topicTextFieldDecoration = InputDecoration(
    hintStyle: TextStyle(color: Colors.grey),
    hintText: "Topic",
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(230, 236, 254, 8), width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(22)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(230, 236, 254, 8), width: 1.0),
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
    fillColor: Color.fromRGBO(230, 236, 254, 8),
    filled: true);

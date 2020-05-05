import 'package:flutter/material.dart';

//constant for the shared preferences
const String TOKEN_ID = 'token';
const String URL = 'https://mytodoappapi.herokuapp.com';

final kTaskTextFormField = InputDecoration(
  labelStyle: TextStyle(
      fontSize: 14.0,
      color: Colors.grey
  ),
  hintStyle: TextStyle(
      fontSize: 14.0,
      color: Colors.grey
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide(
          color: Colors.grey[400],
          style: BorderStyle.solid,
          width: 2.0
      )
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide(
          color: Colors.blue[400],
          style: BorderStyle.solid,
          width: 2.0
      )
  ),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: BorderSide(
          color: Colors.deepOrangeAccent[400],
          style: BorderStyle.solid,
          width: 2.0
      )
  ),

focusedErrorBorder:OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: BorderSide(
        color: Colors.deepOrangeAccent[400],
        style: BorderStyle.solid,
        width: 2.0
    )
),border:OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: BorderSide(
        color: Colors.grey[400],
        style: BorderStyle.solid,
        width: 2.0
    )
),disabledBorder:OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: BorderSide(
        color: Colors.grey[400],
        style: BorderStyle.solid,
        width: 2.0
    )
),

);

const kTaskTextStyle = TextStyle(
    color: Colors.black54,
    fontSize: 16.0,
    fontWeight: FontWeight.w500);
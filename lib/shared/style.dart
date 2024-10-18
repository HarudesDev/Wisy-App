import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: buttonColor, width: 2.0),
  ),
);

const primaryColor = Color.fromRGBO(33, 52, 85, 1);

const backgroundColor = Color.fromRGBO(164, 137, 110, 1);

const buttonColor = Color.fromRGBO(93, 103, 79, 1);

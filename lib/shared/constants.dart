import 'package:flutter/material.dart';

const outlineWhite = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.white, width: 2),
);

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: outlineWhite,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2),
  ),
);

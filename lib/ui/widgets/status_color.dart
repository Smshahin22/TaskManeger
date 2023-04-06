
import 'package:flutter/material.dart';

Container StatusChaid(statusText,statusColor) {
  return Container(
    alignment: Alignment.center,
    child: Text(statusText, style: TextStyle(
      color: Colors.white, fontSize: 10,)),

    decoration: BoxDecoration(
      color: statusColor
    ),
    width: 10,
    height: 10,

  );
}
import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String title,
    [bool error = false]) {
  ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
          content: Text(title, style: TextStyle(
            color: Colors.white,
          ),),
        backgroundColor: error ? Colors.red : null,
       duration: Duration(seconds: 2),
      ),
  );
}
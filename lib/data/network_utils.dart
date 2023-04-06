import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:task_manager/data/auth_utils.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/ui/screens/login.dart';
class NetworkUtils {
  //Get request
   Future<dynamic> getMethod(String url, {VoidCallback? onUnAuthorize}) async {
     try{
       final http.Response response = await http.get(Uri.parse(url), headers: {
         "Content-type" : "application/json", 'token' : AuthUtils.token ?? ''
       });
       log(response.body);
       if (response.statusCode == 200) {
         return jsonDecode(response.body);
       } else if (response.statusCode == 401) {
         if (onUnAuthorize != null) {
           onUnAuthorize();
         }else {
           moveToLogin();
         }
       } else {
         log("Something want wrong");
       }
     }catch (e) {
       log('Error $e' );
     }
}

Future<dynamic> postMethod (String url, {
  Map<String, String>? body, VoidCallback? onUnAuthorize,}) async {
     try{
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type" : "application/json", 'token' : AuthUtils.token ?? ''},
      body: jsonEncode(body),);
    log(response.body);
     if(response.statusCode == 200) {
       return jsonDecode(response.body);
     }else if(response.statusCode == 401){
       if (onUnAuthorize != null) {
         onUnAuthorize();
       }else {
         moveToLogin();
       }
     }else {
       log("Something want wrong${response.statusCode}");
     }
}catch (e) {
       log('Error $e');
     }
}

  void moveToLogin() async{
     AuthUtils.clearData();
     Navigator.pushAndRemoveUntil(
       TaskManagerApp.globalKey.currentContext!,
         MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
     }

}
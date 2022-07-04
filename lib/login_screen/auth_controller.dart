import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:word_game/backend/api_services.dart';
import 'package:word_game/home_page.dart';

import '../constants.dart';
import 'user.dart';

class AuthController extends GetxController {
  String email = "", password = "";

  bool validation() {
    if (email.isNotEmpty && password.isNotEmpty) {
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "Email or password is Empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return false;
  }

  Future<void> login() async {
    if (!validation()) {
      return;
    }

    try {
      final api = Get.find<ApiServices>();
      final user = await api.login(email, password);
      if (user != null) {
        Box box = await Hive.openBox(USERBOX);

        box.put(0, user);
        Fluttertoast.showToast(
            msg: "Welcome To Word Game",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.black,
            fontSize: 16.0);
        Navigator.pushReplacement(Get.context!,
            MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        Fluttertoast.showToast(
            msg: "Email Id and Password does not match",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> signup() async {
    if (!validation()) {
      return;
    }

    try {
      final api = Get.find<ApiServices>();

      final result = await api.signup(email, password);

      if (result) {
        Fluttertoast.showToast(
            msg: "Account Created Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.black,
            fontSize: 16.0);
        Navigator.pop(Get.context!);
      } else {
        Fluttertoast.showToast(
            msg: "Email id Already Taken",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

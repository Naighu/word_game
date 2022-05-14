import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class LoginButton extends StatefulWidget {
  final String text;
  final int mode;
  const LoginButton({Key? key, required this.mode, required this.text})
      : super(key: key);

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 98, 1, 255)),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)))),
            minimumSize: MaterialStateProperty.all(const Size(180, 50))),
        onPressed: () async {
          setState(() {
            _loading = true;
          });
          if (widget.mode == 1) {
            await Get.find<AuthController>().login();
          } else {
            await Get.find<AuthController>().signup();
          }
          setState(() {
            _loading = false;
          });
        },
        child: _loading
            ? const CircularProgressIndicator()
            : Text(
                widget.text.toUpperCase(),
              ));
  }
}

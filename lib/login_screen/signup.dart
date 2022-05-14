import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'app_textfield.dart';
import 'login_btn.dart';
import 'auth_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: GetBuilder<AuthController>(
            init: AuthController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: SvgPicture.asset(
                      "assets/Login-bro.svg",
                    ),
                  ),
                  const Text(
                    "Signup",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Please sign up to continue",
                    style: TextStyle(
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        AppTextField(
                          label: "EMAIL",
                          onChanged: (val) => controller.email = val,
                          prefixIcon: SvgPicture.asset(
                            "assets/inbox.svg",
                            color: const Color(0xFFBBBBBB).withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AppTextField(
                          label: "PASSWORD",
                          onChanged: (val) => controller.password = val,
                          prefixIcon: SvgPicture.asset(
                            "assets/lock.svg",
                            color: const Color(0xFFFFFFFF).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            const LoginButton(
                              text: "Signup",
                              mode: 2,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Forgot Password?",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                            const Spacer(),
                            RichText(
                                text: TextSpan(
                                    text: "Already have an account? ",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                    children: [
                                  TextSpan(
                                      text: "Login",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pop(context);
                                        },
                                      style: const TextStyle()
                                          .copyWith(color: Colors.blue))
                                ]))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}

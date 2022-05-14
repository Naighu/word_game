import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_game/constants.dart';
import 'package:word_game/keyboard/keyboard_controller.dart';

class AppKeyboard extends StatelessWidget {
  AppKeyboard({Key? key}) : super(key: key);
  final List<String> firstRow = [
    "Q",
    "W",
    "E",
    "R",
    "T",
    "Y",
    "U",
    "I",
    "O",
    "P"
  ];
  final List<String> secondRow = ["A", "S", "D", "F", "G", "H", "J", "K", "L"];
  final List<String> thirdRow = ["Z", "X", "C", "V", "B", "N", "M"];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<KeyboardController>(
        id: "keyboard-list",
        builder: (KeyboardController keyboardController) {
          return Column(children: [
            //first Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                  children: List.generate(
                      firstRow.length,
                      (index) => Expanded(
                          child: InkWell(
                              onTap: () {
                                keyboardController.onTap(firstRow[index]);
                              },
                              child: _card(firstRow[index]))))),
            ),
            const SizedBox(
              height: 8,
            ), //second Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  children: List.generate(
                      secondRow.length,
                      (index) => Expanded(
                          child: InkWell(
                              onTap: () {
                                keyboardController.onTap(secondRow[index]);
                              },
                              child: _card(secondRow[index]))))),
            ),
            //thirdRow
            const SizedBox(
              height: 8,
            ), //second Row
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        keyboardController.onTap("enter");
                      },
                      child: Container(
                        height: 65,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF3a3a3a),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: const Text("Enter"),
                      ),
                    ),
                  ),
                  ...List.generate(
                    thirdRow.length,
                    (index) => Expanded(
                        child: InkWell(
                            onTap: () {
                              keyboardController.onTap(thirdRow[index]);
                            },
                            child: _card(thirdRow[index]))),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        keyboardController.onTap("delete");
                      },
                      child: Container(
                          height: 65,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3a3a3a),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: const Icon(
                            Icons.backspace,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ]))
          ]);
        });
  }

  Widget _card(String text) => Container(
        height: 65,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 6),
        decoration: const BoxDecoration(
          color: Color(0xFF3a3a3a),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(text),
      );
}

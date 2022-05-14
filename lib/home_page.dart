import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_game/constants.dart';
import 'package:word_game/keyboard/keyboard_controller.dart';

import 'keyboard/keyboard.dart';
import 'puzzle_grid/puzzle_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(KeyboardController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: const Text(
          "Word Game",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const Expanded(
              child: Text(
            "Find the Word",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          )),
          const Expanded(flex: 4, child: PuzzleGrid()),
          const SizedBox(
            height: defaultPadding,
          ),
          SizedBox(
            height: 220,
            child: AppKeyboard(),
          )
        ],
      ),
    );
  }
}

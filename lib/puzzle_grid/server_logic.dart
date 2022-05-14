import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:word_game/models/user_words.dart';
import 'package:word_game/puzzle_grid/solver.dart';

import '../backend/api_services.dart';
import '../login_screen/user.dart';
import 'puzzle_grid.dart';

class ServerLogic {
  static Future<WordGame?> getWord() async {
    try {
      final box = await Hive.openBox<Map>("word");
      if (box.isNotEmpty) {
        final savedWord = box.getAt(0);
        if (savedWord != null) {
          final expireDate =
              DateTime.fromMillisecondsSinceEpoch(savedWord["expire_at"]);
          if (expireDate.isAfter(DateTime.now())) {
            return WordGame(savedWord["word"].toString().toUpperCase());
          } else {
            Map queryResult = await Get.find<ApiServices>().getCurrentWord();

            box.putAt(0, queryResult);
            return WordGame(queryResult["word"].toString().toUpperCase());
          }
        }
      } else {
        Map queryResult = await Get.find<ApiServices>().getCurrentWord();

        box.add(queryResult);
        return WordGame(queryResult["word"].toUpperCase());
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
    return null;
  }

  static Future<List<UserWord>> getUserWord() async {
    try {
      final userBox = Get.find<Box<User>>().getAt(0);

      return await Get.find<ApiServices>().getUserWords(userBox!.userID);
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

    return [];
  }

  static Future<void> addTries(String word, String query) async {
    try {
      final userBox = Get.find<Box<User>>().getAt(0);
      await Get.find<ApiServices>().addTries(userBox!.userID, word, query);
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

extension Check on List<UserWord> {
  int checkWord(String w) {
    for (int i = 0; i < this.length; i++) {
      if (this[i].word == w) {
        return i;
      }
    }

    return -1;
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:word_game/keyboard/keyboard_controller.dart';
import 'package:word_game/puzzle_grid/server_logic.dart';
import 'package:word_game/puzzle_grid/result_screen.dart';

import '../models/user_words.dart';
import 'solver.dart';

class Cell {
  String text;
  Color? bgColor;

  Cell({required this.text, this.bgColor});
}

class PuzzleGrid extends StatefulWidget {
  const PuzzleGrid({Key? key}) : super(key: key);

  @override
  State<PuzzleGrid> createState() => _PuzzleGridState();
}

class _PuzzleGridState extends State<PuzzleGrid> {
  late KeyboardController keyboardController;
  bool isGameFinished = false;
  late WordGame wordGame;
  OverlayEntry? entry;
  late List<List<Cell>> cells = [];
  int row = 0, col = -1;
  @override
  void initState() {
    super.initState();
    Future(() {
      _loading(true);
    });

    ServerLogic.getWord().then((value) {
      if (value != null) {
        wordGame = value;
        ServerLogic.getUserWord().then((userWords) {
          int index = userWords.checkWord(wordGame.word);

          if (index != -1) {
            if (userWords[index].status == WordStatus.notCompleted &&
                userWords[index].tries.isNotEmpty) {
              _fillCacheTries(userWords[index]);
            } else if (userWords[index].status == WordStatus.triesExceeded) {
              Future(() {
                _triesExceededScreen();
              });
            } else {
              Future(() {
                _winningScreen();
              });
            }
          }
          _loading(false);
        });
      }
    });

    keyboardController = Get.find<KeyboardController>();
    for (int i = 0; i < 6; i++) {
      List<Cell> c = [];
      for (int j = 0; j < 5; j++) {
        c.add(Cell(text: ""));
      }

      cells.add(c);
    }
    keyboardController.addListener(() {
      if (keyboardController.text.toLowerCase() == "enter") {
        _onEnter();
      } else if (col < 5) {
        setState(() {
          if (keyboardController.text.toLowerCase() == "delete") {
            if (col >= 0) {
              cells[row][col].text = "";
              col--;
            }
          } else {
            col++;
            if (col < 5) {
              cells[row][col].text = keyboardController.text;
            } else {
              col = 4;
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = 65;

    return LayoutBuilder(builder: (context, constraints) {
      size = _getTileSize(constraints);
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.01),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
                6,
                (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            5,
                            (j) => Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                      color: cells[i][j].bgColor ??
                                          Colors.transparent,
                                      border: Border.all(
                                          color: const Color(0xFF818384))),
                                  height: size,
                                  width: size,
                                  child: Text(
                                    cells[i][j].text,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                )),
                      ),
                    ))),
      );
    });
  }

  double _getTileSize(BoxConstraints constraints) {
    int height = constraints.maxHeight.round();
    int width = constraints.maxWidth.round();

    double n = (height / 6) - (6);
    double m = (width / 5) - (6);

    return min(n, m);
  }

  void _fillCacheTries(UserWord userWord) {
    debugPrint("filling the cache");
    for (int i = 0; i < userWord.tries.length; i++) {
      for (int j = 0; j < 5; j++) {
        cells[row][j].text = userWord.tries[i].split("")[j];
        col++;
      }
      _onEnter(addtoServer: false);
    }
  }

  void _onEnter({bool addtoServer = true}) {
    debugPrint("on Enter");
    if (col != 4) {
      debugPrint("Not enough words");
      Fluttertoast.showToast(
          msg: "Not Enough Length",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    String input = "";

    for (int i = 0; i < 5; i++) {
      input += cells[row][i].text;
    }
    if (!wordGame.isWord(input)) {
      debugPrint("Not a word");
      Fluttertoast.showToast(
          msg: "Not a Valid Word",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    final result = wordGame.check(input.toUpperCase());

    if (result.every((element) => element == 1)) {
      debugPrint("Completed");
      Future(() {
        _winningScreen();
      });
    } else {
      for (int i = 0; i < result.length; i++) {
        switch (result[i]) {
          case 0:
            cells[row][i].bgColor = const Color(0xFF3a3a3a);
            break;

          case 1:
            cells[row][i].bgColor = Colors.green;
            break;
          case 2:
            cells[row][i].bgColor = const Color.fromARGB(255, 179, 163, 21);
            break;
        }
      }

      col = -1;
      row++;

      if (row >= 6) {
        isGameFinished = true;
        debugPrint("No chance ");
        _triesExceededScreen();
      }
    }
    if (addtoServer) {
      ServerLogic.addTries(wordGame.word, input);
    }
    setState(() {});
  }

  void _loading(bool loading) {
    if (loading) {
      entry = OverlayEntry(builder: (context) => const AppLoading());

      Overlay.of(context)?.insert(entry!);
    } else {
      if (entry != null && entry!.mounted) {
        entry?.remove();
      }
      entry = null;
    }
  }

  void _winningScreen() async {
    final box = await Hive.openBox<Map>("word");

    final expireDate =
        DateTime.fromMillisecondsSinceEpoch(box.getAt(0)!["expire_at"]);
    final startDuration = expireDate.difference(DateTime.now());

    entry = OverlayEntry(
        builder: (context) => ResultScreen(
              word: wordGame.word,
              meaning: box.getAt(0)!["meaning"],
              title: "Congratulation",
              titleColor: Colors.green,
              subTitle: "You found the right Word",
              startDuration: startDuration,
              onReload: () async {
                final a = await ServerLogic.getWord();
                if (a != null) {
                  setState(() {
                    wordGame = a;
                  });
                }

                Future(() {
                  entry?.remove();
                  entry = null;
                });
              },
            ));

    Overlay.of(context)?.insert(entry!);
  }

  void _triesExceededScreen() async {
    final box = await Hive.openBox<Map>("word");
    final expireDate =
        DateTime.fromMillisecondsSinceEpoch(box.getAt(0)!["expire_at"]);

    final startDuration = expireDate.difference(DateTime.now());

    entry = OverlayEntry(
        builder: (context) => ResultScreen(
              winning: false,
              word: wordGame.word,
              meaning: box.getAt(0)!["meaning"],
              title: "Tries Exceeded",
              titleColor: Colors.red,
              subTitle: "Don't Worry Work hard",
              startDuration: startDuration,
              onReload: () async {
                final a = await ServerLogic.getWord();
                if (a != null) {
                  setState(() {
                    wordGame = a;
                  });
                }

                Future(() {
                  entry?.remove();
                  entry = null;
                });
              },
            ));

    Overlay.of(context)?.insert(entry!);
  }
}

class AppLoading extends StatelessWidget {
  const AppLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:word_game/constants.dart';

class ResultScreen extends StatefulWidget {
  final String word, meaning;
  final bool winning;
  final Duration startDuration;
  final Function() onReload;
  final String title, subTitle;
  final Color titleColor;
  const ResultScreen(
      {Key? key,
      this.winning = true,
      required this.title,
      required this.titleColor,
      required this.subTitle,
      required this.startDuration,
      this.meaning = "",
      required this.onReload,
      this.word = ""})
      : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Duration? duration;
  late Timer timer;
  late ConfettiController _controllerCenter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    duration = widget.startDuration;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        duration = duration! - const Duration(seconds: 1);
        if (duration!.inSeconds == 0) {
          timer.cancel();
          widget.onReload();
        }
      });
    });
    if (widget.winning) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        _controllerCenter.play();
      });
    }
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          height: 300,
          width: 300,
          top: Get.height * 0.5 - 150,
          left: Get.width * 0.5 - 150,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.black),
              child: Column(children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.titleColor,
                    decoration: TextDecoration.none,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Text(
                  widget.subTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Text(
                  "Meaning of \"${widget.word}\" : ${widget.meaning}",
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Spacer(),
                Column(
                  children: [
                    const Text(
                      "Next challenge will arrives in : ",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Text(
                      fromSeconds(duration!.inSeconds),
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.none,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding * 2,
                )
              ]),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
                true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
            // define a custom shape/path.
          ),
        ),
      ],
    );
  }

  fromSeconds(int val) {
    Duration duration = Duration(seconds: val);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

import 'package:get/get.dart';

class KeyboardController extends GetxController {
  String _currentText = "";

  String get text => _currentText;
  void onTap(String value) {
    _currentText = value;
    update();
  }
}

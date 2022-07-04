import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:word_game/home_page.dart';
import 'package:word_game/login_screen/login_screen_layout.dart';
import 'package:word_game/login_screen/user.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox(USERBOX);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user;
    try {
      user = Hive.box<User>(USERBOX).getAt(0);
    } catch (e) {}
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: user != null ? const HomePage() : const LoginScreen());
  }
}

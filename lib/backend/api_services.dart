import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:word_game/login_screen/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_words.dart';

class ApiServices {
  final _baseUrl =
      "https://data.mongodb-api.com/app/data-bjmhz/endpoint/data/beta";
  final _apiKey = dotenv.env['api'];

  Future<http.Response> _request(String url, String db, List<Map> b) {
    final Map body = {
      "dataSource": "Cluster0",
      "database": "word_game",
      "collection": db,
    };

    for (Map a in b) {
      body.addAll(a);
    }

    return http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json", "api-key": _apiKey},
        body: json.encode(body));
  }

  Future<bool> signup(String email, String password) async {
    final document = {
      "email": email,
    };
    http.Response response =
        await _request(_baseUrl + "/action/findOne", "users", [
      {"filter": document}
    ]);
    if (response.statusCode == 200) {
      if (json.decode(response.body)["document"] == null) {
        document["password"] = password;
        response = await _request(_baseUrl + "/action/insertOne", "users", [
          {"document": document}
        ]);
        return true;
      }
      return false;
    }
    return false;
  }

  Future<User?> login(String email, String password) async {
    final document = {"email": email, "password": password};

    final http.Response response =
        await _request(_baseUrl + "/action/findOne", "users", [
      {"filter": document}
    ]);
    final decoded = json.decode(response.body);
    if (response.statusCode == 200 && decoded["document"] != null) {
      return User.fromJson(decoded["document"]);
    }
  }

  Future<Map> getCurrentWord() async {
    http.Response response =
        await _request(_baseUrl + "/action/findOne", "current_word", []);

    return json.decode(response.body)["document"];
  }

  Future<List<UserWord>> getUserWords(String id) async {
    http.Response response =
        await _request(_baseUrl + "/action/findOne", "completed_words", [
      {
        "filter": {"user_id": id}
      }
    ]);
    List userWords = json.decode(response.body)["document"]["words"];

    return userWords.map((e) => UserWord.fromJson(e)).toList();
  }

  Future<void> addTries(String id, String word, String tryWord) async {
    final userWords = await getUserWords(id);

    bool found = false;
    for (UserWord u in userWords) {
      if (u.word == word) {
        if (tryWord == word) {
          u.status = WordStatus.competed;
        }
        u.tries.add(tryWord);
        found = true;
        break;
      }
    }
    if (!found) {
      userWords.add(UserWord(
          word: word, status: WordStatus.notCompleted, tries: [tryWord]));
    }

    final response =
        await _request(_baseUrl + "/action/updateOne", "completed_words", [
      {
        "filter": {"user_id": id}
      },
      {
        "update": {
          "\$set": {"words": userWords.map((e) => e.toJson()).toList()}
        }
      }
    ]);

    print(response.body);
  }
}

void main() async {
  ApiServices s = ApiServices();
  //s.addTries("621651b5b3d86aa50c88c9cc", "HELLO", "WHATS");
  //s.login("test@gmail.com", "12345");
}

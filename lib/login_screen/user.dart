import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final String email;
  @HiveField(1)
  final String userID;
  User({required this.email, required this.userID});
  factory User.fromJson(Map json) =>
      User(email: json["email"], userID: json["_id"]);
}

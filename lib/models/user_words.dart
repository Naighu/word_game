enum WordStatus { competed, notCompleted, triesExceeded }

class UserWord {
  final String word;
  WordStatus status;
  List tries;

  UserWord({required this.word, required this.status, required this.tries});
  factory UserWord.fromJson(Map json) => UserWord(
      word: json["word"],
      status: json["status"] == 1
          ? WordStatus.competed
          : json["status"] == 2
              ? WordStatus.triesExceeded
              : WordStatus.notCompleted,
      tries: json["tries"]);

  Map<String, dynamic> toJson() => {
        "word": word,
        "status": status == WordStatus.competed
            ? 1
            : status == WordStatus.triesExceeded
                ? 2
                : 0,
        "tries": tries
      };
}

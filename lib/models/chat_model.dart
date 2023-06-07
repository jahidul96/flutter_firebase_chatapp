// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

class ChatModel {
  String username;
  String lastMsg;
  String from;
  String profilePic;
  DateTime createdAt;
  String imgUrl;
  bool seen;
  ChatModel({
    required this.username,
    required this.lastMsg,
    required this.from,
    required this.profilePic,
    required this.createdAt,
    required this.imgUrl,
    required this.seen,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'lastMsg': lastMsg,
      'from': from,
      'profilePic': profilePic,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'imgUrl': imgUrl,
      'seen': seen,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      username: map['username'] ?? '',
      lastMsg: map['lastMsg'] ?? '',
      from: map['from'] ?? '',
      profilePic: map['profilePic'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      imgUrl: map['imgUrl'] ?? '',
      seen: map['seen'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));
}

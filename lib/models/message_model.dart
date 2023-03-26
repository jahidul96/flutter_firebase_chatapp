import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String text;
  String senderId;
  Timestamp createdAt;
  String imgUrl;
  String senderProfilePic;
  String senderUsername;

  MessageModel({
    required this.text,
    required this.senderId,
    required this.createdAt,
    required this.imgUrl,
    required this.senderProfilePic,
    required this.senderUsername,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'createdAt': createdAt,
      'imgUrl': imgUrl,
      'senderProfilePic': senderProfilePic,
      'senderUsername': senderUsername,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      createdAt: map['createdAt'],
      imgUrl: map['imgUrl'] ?? '',
      senderProfilePic: map['senderProfilePic'] ?? '',
      senderUsername: map['senderUsername'] ?? '',
    );
  }
}

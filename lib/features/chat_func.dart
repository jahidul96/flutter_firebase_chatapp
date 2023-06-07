// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:knockme/features/fb_storage.dart';
import 'package:knockme/utils/fb_instance.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'package:path/path.dart' as p;

groupChat({
  required MessageModel msgData,
  required String groupId,
  required String senderId,
  required String text,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add(
          msgData.toMap(),
        );

    await db.collection("groups").doc(groupId).update({
      "lastMsg": text,
      "seen": false,
      "justCreated": false,
      "senderId": senderId,
    });
  } catch (e) {
    print(e);
  }
}

// one to one chat functions
void onToOneChat({
  required String text,
  required String senderId,
  required String senderProfilePic,
  required String senderUsername,
  required String friendId,
  required String friendUsername,
  required String friendProfilePic,
  required File? image,
  required BuildContext context,
}) async {
  // msg data
  var msgdata = MessageModel(
      text: text,
      senderId: senderId,
      createdAt: DateTime.now(),
      imgUrl: "",
      senderProfilePic: senderProfilePic,
      senderUsername: senderUsername);

  // infriend db chats data/lastmsg data
  var friendChat = ChatModel(
    username: senderUsername,
    lastMsg: text,
    from: senderId,
    createdAt: DateTime.now(),
    profilePic: senderProfilePic,
    imgUrl: "",
    seen: true,
  );

  // in my db chats data/lastmsg data
  var myChat = ChatModel(
    username: friendUsername,
    lastMsg: text,
    from: friendId,
    createdAt: DateTime.now(),
    profilePic: friendProfilePic,
    imgUrl: "",
    seen: false,
  );

  if (image != null) {
    String fileName = p.basename(image.path);

    var imagePath = 'chatImages/${DateTime.now()}$fileName';

    var url =
        await uploadFile(image: image, imagePath: imagePath, context: context);

// adding imgurl
    msgdata.imgUrl = url;
    friendChat.imgUrl = url;
    myChat.imgUrl = url;

    //in my db add chat
    createOneToOneChat(
        userId: senderId, chatDocId: friendId, chatData: myChat.toMap());

    //in my db add msg
    addMessage(userId: senderId, chatDocId: friendId, msgdata: msgdata);

    // infriends db add chat
    createOneToOneChat(
        userId: friendId, chatDocId: senderId, chatData: friendChat.toMap());

    //infriends db add msg
    addMessage(userId: friendId, chatDocId: senderId, msgdata: msgdata);
  } else {
    // infriends db add chat
    createOneToOneChat(
        userId: friendId, chatDocId: senderId, chatData: friendChat.toMap());

    //infriends db add msg
    addMessage(userId: friendId, chatDocId: senderId, msgdata: msgdata);

    //in my db add chat
    createOneToOneChat(
        userId: senderId, chatDocId: friendId, chatData: myChat.toMap());

    //in my db add msg
    addMessage(userId: senderId, chatDocId: friendId, msgdata: msgdata);
  }
}

void createOneToOneChat({
  required String userId,
  required String chatDocId,
  required chatData,
}) {
  db
      .collection("users")
      .doc(userId)
      .collection("chats")
      .doc(chatDocId)
      .set(chatData);
}

// add msg to db
void addMessage({
  required String userId,
  required String chatDocId,
  required MessageModel msgdata,
}) {
  db
      .collection("users")
      .doc(userId)
      .collection("chats")
      .doc(chatDocId)
      .collection("messages")
      .add(
        msgdata.toMap(),
      );
}

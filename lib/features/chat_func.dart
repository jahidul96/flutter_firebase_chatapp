// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:knockme/features/fb_storage.dart';
import 'package:knockme/utils/fb_instance.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'package:path/path.dart' as p;

// groupChat Function
void groupChat({
  required String text,
  required String senderId,
  required String senderProfilePic,
  required String senderUsername,
  required File? image,
  required BuildContext context,
  required String groupId,
}) async {
  // msg data
  var msgdata = MessageModel(
    text: text,
    senderId: senderId,
    createdAt: Timestamp.now(),
    imgUrl: "",
    senderProfilePic: senderProfilePic,
    senderUsername: senderUsername,
  );

  if (image != null) {
    String fileName = p.basename(image.path);

    var imagePath = 'groupImages/${DateTime.now()}$fileName';

    var url = await uploadFile(
        fileName: fileName,
        image: image,
        imagePath: imagePath,
        context: context);

    msgdata.imgUrl = url;

    await db
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add(msgdata.toMap());
  } else {
    await db
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .add(msgdata.toMap());
  }

  await db.collection("groups").doc(groupId).update({
    "lastMsg": text,
    "seen": false,
    "justCreated": false,
    "senderId": senderId,
  });
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
      createdAt: Timestamp.now(),
      imgUrl: "",
      senderProfilePic: senderProfilePic,
      senderUsername: senderUsername);

  // infriend db chats data/lastmsg data
  var friendChats = ChatModel(
    username: senderUsername,
    lastMsg: text,
    from: senderId,
    createdAt: Timestamp.now(),
    profilePic: senderProfilePic,
    imgUrl: "",
    seen: true,
  );

  // in my db chats data/lastmsg data
  var myChats = ChatModel(
    username: friendUsername,
    lastMsg: text,
    from: friendId,
    createdAt: Timestamp.now(),
    profilePic: friendProfilePic,
    imgUrl: "",
    seen: false,
  );

  if (image != null) {
    String fileName = p.basename(image!.path);

    var imagePath = 'chatImages/${DateTime.now()}$fileName';

    var url = await uploadFile(
        fileName: fileName,
        image: image,
        imagePath: imagePath,
        context: context);

// adding imgurl
    msgdata.imgUrl = url;
    friendChats.imgUrl = url;
    myChats.imgUrl = url;

    //in my db add chat
    addOneToOneChatToDb(
        firstId: senderId, secondId: friendId, chatData: myChats.toMap());

    //in my db add msg
    addOneToOneMessgageToDb(
        firstId: senderId, secondId: friendId, msgdata: msgdata);

    // infriends db add chat
    addOneToOneChatToDb(
        firstId: friendId, secondId: senderId, chatData: friendChats.toMap());

    //infriends db add msg
    addOneToOneMessgageToDb(
        firstId: friendId, secondId: senderId, msgdata: msgdata);
  } else {
    // infriends db add chat
    addOneToOneChatToDb(
        firstId: friendId, secondId: senderId, chatData: friendChats.toMap());

    //infriends db add msg
    addOneToOneMessgageToDb(
        firstId: friendId, secondId: senderId, msgdata: msgdata);

    //in my db add chat
    addOneToOneChatToDb(
        firstId: senderId, secondId: friendId, chatData: myChats.toMap());

    //in my db add msg
    addOneToOneMessgageToDb(
        firstId: senderId, secondId: friendId, msgdata: msgdata);
  }
}

void addOneToOneChatToDb({
  required String firstId,
  required String secondId,
  required chatData,
}) {
  db
      .collection("users")
      .doc(firstId)
      .collection("chats")
      .doc(secondId)
      .set(chatData);
}

// add msg to db
void addOneToOneMessgageToDb({
  required String firstId,
  required String secondId,
  required MessageModel msgdata,
}) {
  db
      .collection("users")
      .doc(firstId)
      .collection("chats")
      .doc(secondId)
      .collection("messages")
      .add(
        msgdata.toMap(),
      );
}

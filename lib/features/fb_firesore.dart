import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:knockme/features/push_notification.dart';
import 'package:knockme/utils/fb_instance.dart';

// update push token
updatePushToken() async {
  var pushToken = await NotificationServices().getToken();
  FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({"pushToken": pushToken});
}

deleteChat({
  required String chatId,
}) async {
  var allmsgs = await db
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("chats")
      .doc(chatId)
      .collection("messages")
      .get();

  for (var element in allmsgs.docs) {
    // element.reference.delete();
    db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(element.id)
        .delete();
  }

  await db
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("chats")
      .doc(chatId)
      .delete();
}

deleteGroupChat({
  required String groupId,
}) async {
  var allmsgs =
      await db.collection("groups").doc(groupId).collection("messages").get();

  for (var element in allmsgs.docs) {
    // element.reference.delete();
    db
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .doc(element.id)
        .delete();
  }

  await db.collection("groups").doc(groupId).delete();
}

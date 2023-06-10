// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:knockme/features/push_notification.dart';
import 'package:knockme/models/user_model.dart';

import 'package:knockme/screens/auth/auth_user_check.dart';

import 'package:knockme/utils/fb_instance.dart';
import 'package:knockme/widgets/confirmation_model.dart';

void registerUser(
    {required String username,
    required String email,
    required String password,
    required String profileUrl,
    required BuildContext context}) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    var pushToken = await NotificationServices().getToken();

    var data = UserModel(
        id: credential.user!.uid,
        username: username,
        email: email,
        profilePic: profileUrl,
        bio: "hey there i am using chatapp!",
        pushToken: pushToken);

    FirebaseFirestore.instance
        .collection("users")
        .doc(credential.user!.uid)
        .set(data.toMap())
        .then(
      (value) {
        Navigator.pushNamed(context, CheckAuthUser.routeName);
      },
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      alertUser(
          context: context, alertText: "The password provided is too weak.");
    } else if (e.code == 'email-already-in-use') {
      alertUser(
          context: context,
          alertText: "The account already exists for that email.");
    }
  }
}

void loginUserFb(String email, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((_) => {Navigator.pushNamed(context, CheckAuthUser.routeName)});
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      alertUser(context: context, alertText: "No user found.");
    } else if (e.code == 'wrong-password') {
      alertUser(context: context, alertText: "Wrong email or password!");
    }
  }
}

// get myData
Future getMyData() async {
  try {
    var data = await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return data.data();
  } catch (e) {
    print("some error");
  }
}

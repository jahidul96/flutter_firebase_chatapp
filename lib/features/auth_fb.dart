import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:knockme/screens/auth/auth_user_check.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/utils/fb_instance.dart';

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

    Map<String, dynamic> userData = {
      "username": username.toLowerCase(),
      "email": email.toLowerCase(),
      "id": credential.user!.uid,
      "profilePic": profileUrl,
      "bio": "hey there i am using chatapp!"
    };

    FirebaseFirestore.instance
        .collection("users")
        .doc(credential.user!.uid)
        .set(userData)
        .then(
      (value) {
        Navigator.pushNamed(context, CheckAuthUser.routeName);
      },
    );

    Get.snackbar(
      "KnockMe app",
      "Registation succesfull",
      backgroundColor: AppColors.buttonColor,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      Get.snackbar(
        "KnockMe app",
        "The password provided is too weak.",
        backgroundColor: AppColors.authBackgroundColor,
      );
    } else if (e.code == 'email-already-in-use') {
      Get.snackbar(
        "KnockMe app",
        "The account already exists for that email.",
        backgroundColor: AppColors.authBackgroundColor,
      );
    }
  }
}

void loginUser(String email, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((_) => {Navigator.pushNamed(context, CheckAuthUser.routeName)});

    Get.snackbar(
      "KnockMe app",
      "Login succesfull",
      backgroundColor: AppColors.authBackgroundColor,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Get.snackbar(
        "KnockMe app",
        "No user found.",
        backgroundColor: AppColors.buttonColor,
      );
    } else if (e.code == 'wrong-password') {
      Get.snackbar(
        "KnockMe app",
        "Wrong email or password!",
        backgroundColor: AppColors.buttonColor,
      );
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

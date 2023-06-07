// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knockme/widgets/confirmation_model.dart';

final storageRef = FirebaseStorage.instance.ref();

Future uploadFile({
  required File? image,
  required String imagePath,
  required BuildContext context,
}) async {
  try {
    Reference ref = storageRef.child(imagePath);
    await ref.putFile(image!);
    final url = await ref.getDownloadURL();

    return url;
  } catch (e) {
    alertUser(context: context, alertText: "Image Upload problem");
    print("file uploaded problem");
  }
}

Future pickImage() async {
  try {
    final img = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (img == null) return;
    final tempImg = File(img.path);

    return tempImg;
  } catch (e) {
    print("error occuer's");
  }
}

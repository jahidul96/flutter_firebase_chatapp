// ignore_for_file: unused_catch_clause, use_build_context_synchronously, avoid_print, must_be_immutable, depend_on_referenced_packages

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:knockme/features/auth_fb.dart';
import 'package:knockme/features/fb_storage.dart';
import 'package:knockme/widgets/confirmation_model.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text_comp.dart';

class AddProfilePicScreen extends StatefulWidget {
  String email;
  String password;
  String username;

  AddProfilePicScreen(
      {super.key,
      required this.email,
      required this.username,
      required this.password});

  @override
  State<AddProfilePicScreen> createState() => _AddProfilePicScreenState();
}

class _AddProfilePicScreenState extends State<AddProfilePicScreen> {
  final storageRef = FirebaseStorage.instance.ref();
  File? _image;
  bool loading = false;

  Future pickFromGallery() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) return;
      final tempImg = File(img.path);

      setState(() {
        _image = tempImg;
      });
    } catch (e) {
      print("error occuer's");
    }
  }

  createAcount() async {
    if (_image == null) {
      return alertUser(context: context, alertText: "Add a Profile pic");
    }

    setState(() {
      loading = true;
    });
    String fileName = p.basename(_image!.path);
    String imagePath = 'profileImages/${DateTime.now()}$fileName';

    var url = await uploadFile(
        image: _image!, imagePath: imagePath, context: context);

    registerUser(
        username: widget.username,
        email: widget.email,
        password: widget.password,
        context: context,
        profileUrl: url);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                _image != null
                    ? GestureDetector(
                        onTap: () => pickFromGallery(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            _image!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          GestureDetector(
                              onTap: () => pickFromGallery(),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              )),
                          const SizedBox(height: 10),
                          TextComp(
                            text: "Click on Avator to choose a photo",
                            size: 12,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                loading
                    ? Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            const CircularProgressIndicator(),
                            const SizedBox(
                              height: 40,
                            ),
                            TextComp(
                              text: "Creating Account Wait...",
                              color: AppColors.black,
                            )
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: CustomButton(
                          text: "Create Account",
                          onPressed: () => createAcount(),
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}

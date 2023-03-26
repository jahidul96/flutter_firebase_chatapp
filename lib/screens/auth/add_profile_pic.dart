// ignore_for_file: unused_catch_clause

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:knockme/features/auth_fb.dart';
import 'package:knockme/features/fb_storage.dart';
import 'package:knockme/widgets/confirmation_model.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/app_colors.dart';
import '../../utils/asset_files.dart';
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
        fileName: fileName,
        image: _image!,
        imagePath: imagePath,
        context: context);

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
      backgroundColor: AppColors.authBackgroundColor,
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
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        GestureDetector(
                          onTap: () => pickFromGallery(),
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: 0.8,
                                child: Image.asset(
                                  AssetFiles.person,
                                  width: 80,
                                  height: 80,
                                  color: AppColors.whiteColor,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Positioned(
                                top: 30,
                                left: 27,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextComp(
                          text: "Click on Avator to choose a photo",
                          size: 12,
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
                          TextComp(text: "Creating Account Wait...")
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: CustomButton(
                        text: "Create Account",
                        onPressed: () => createAcount(),
                      ),
                    )
            ],
          )
        ],
      )),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:knockme/utils/app_colors.dart';

Widget chatBottomComp({
  required Function()? onTap,
  required Function()? pickImage,
  required TextEditingController textController,
}) =>
    Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            constraints: const BoxConstraints(
              minHeight: 47,
              minWidth: double.infinity,
              maxHeight: 120,
              maxWidth: double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Message",
                        hintStyle: TextStyle(
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: pickImage,
                    child: Icon(
                      Icons.image,
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        sendButton(onTap: onTap, icon: Icons.send),
      ],
    );

Widget fileSendComp({
  required File image,
  Function()? send,
  Function()? clear,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.file(
              image,
              width: 70,
              height: 60,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  sendButton(
                    icon: Icons.clear,
                    onTap: clear,
                  ),
                  const SizedBox(width: 20),
                  sendButton(
                    icon: Icons.send,
                    onTap: send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

Widget sendButton({
  required Function()? onTap,
  required IconData icon,
}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.appbarColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );

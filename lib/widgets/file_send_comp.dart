// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:knockme/widgets/send_button.dart';

class FileSendComp extends StatelessWidget {
  File image;
  Function()? send;
  Function()? clear;
  FileSendComp({
    super.key,
    required this.image,
    this.send,
    this.clear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
  }
}

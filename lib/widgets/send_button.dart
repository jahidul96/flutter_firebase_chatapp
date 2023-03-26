import 'package:flutter/material.dart';
import 'package:knockme/utils/app_colors.dart';

Widget sendButton({
  required IconData icon,
  required Function()? onTap,
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

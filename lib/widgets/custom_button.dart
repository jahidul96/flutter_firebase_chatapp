// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/widgets/text_comp.dart';

class CustomButton extends StatelessWidget {
  Function()? onPressed;
  String text;
  double borderRadius;
  CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.borderRadius = 10});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: TextComp(
          text: text,
        ),
      ),
    );
  }
}

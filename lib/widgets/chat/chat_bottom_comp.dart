import 'package:flutter/material.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/widgets/send_button.dart';

class ChatBottomComp extends StatelessWidget {
  Function()? onTap;
  Function()? pickImage;
  TextEditingController textController;
  ChatBottomComp(
      {super.key,
      required this.onTap,
      required this.textController,
      required this.pickImage});

  @override
  Widget build(BuildContext context) {
    return Row(
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
        sendButton(
          icon: Icons.send,
          onTap: onTap,
        ),
      ],
    );
  }
}

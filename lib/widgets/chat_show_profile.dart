import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/widgets/text_comp.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget chatShowProfile({
  Function()? onTap,
  Function()? onLongPress,
  required String profileImg,
  required String name,
  required String lastMsg,
  required bool dateShow,
  DateTime? createdAt,
  bool isNewMessage = false,
  bool isGroupMessage = false,
  bool isJustCreated = false,
}) =>
    InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Row(
            children: [
              // profile image
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  profileImg,
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 10),

              // right text/last msg and date content
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // username/name
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 1),

                        isGroupMessage && isJustCreated
                            ? const Text("new")
                            :

                            // lastmsg
                            lastMsg == ""
                                ? const Icon(
                                    Icons.image,
                                    size: 14,
                                    color: AppColors.black,
                                  )
                                : lastMsg.length > 28
                                    ? Text("${lastMsg.substring(0, 27)}...")
                                    : Text(lastMsg),
                      ],
                    ),
                    dateShow
                        ? Column(
                            children: [
                              isNewMessage
                                  ? Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.buttonColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: TextComp(
                                            text: "new",
                                            size: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                      ],
                                    )
                                  : Container(),
                              Text(
                                timeago.format(createdAt!, locale: 'en_short'),
                              ),
                            ],
                          )
                        : const Text(""),
                  ],
                ),
              )
            ],
          )),
    );

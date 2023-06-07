// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knockme/models/chat_model.dart';
import 'package:knockme/models/user_model.dart';
import 'package:knockme/screens/chat_screen.dart';
import 'package:knockme/screens/contacts.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/utils/fb_instance.dart';
import 'package:knockme/widgets/confirmation_model.dart';
import 'package:knockme/widgets/chat_show_profile.dart';
import 'package:knockme/widgets/text_comp.dart';

class ChatTabComp extends StatefulWidget {
  const ChatTabComp({super.key});

  @override
  State<ChatTabComp> createState() => _ChatTabCompState();
}

class _ChatTabCompState extends State<ChatTabComp> {
  List chats = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("chats")
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: TextComp(
                  text: "No Chats Till Now Start Chating!",
                  color: Colors.black,
                ),
              );
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs;
                  List<ChatModel> chats = [];
                  for (var element in data) {
                    var chat = ChatModel.fromMap(element.data());
                    chats.add(chat);
                  }

                  var chat = chats[index];
                  var chatId = data[index].id;

                  return chatShowProfile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userData: UserModel(
                              email: "",
                              id: chat.from,
                              username: chat.username,
                              profilePic: chat.profilePic,
                              bio: "",
                            ),
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      confirmModel(
                        context: context,
                        infoText: "Want to delete This Chat?",
                        confirmFunc: () {
                          db
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("chats")
                              .doc(chatId)
                              .delete();
                          Navigator.pop(context);
                        },
                      );
                    },
                    isNewMessage: chat.seen,
                    profileImg: chat.profilePic,
                    name: chat.username,
                    lastMsg: chat.lastMsg,
                    dateShow: true,
                    createdAt: chat.createdAt,
                  );

                  // return chatItem(
                  //   chat: chats[index],
                  // );
                },
              );
            }

            return Center(
              child: TextComp(
                text: "No Chats Till Now",
                color: Colors.black,
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, ContactScreen.routeName);
          },
          backgroundColor: AppColors.appbarColor,
          child: const Icon(Icons.chat),
        ));
  }
}

// ignore_for_file: must_be_immutable, use_build_context_synchronously, prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knockme/models/user_model.dart';
import 'package:knockme/screens/chat_screen.dart';
import 'package:knockme/widgets/chat_show_profile.dart';
import 'package:knockme/widgets/text_comp.dart';

class ContactScreen extends StatefulWidget {
  static const routeName = "contact";
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextComp(
          text: "Contacts",
          size: 20,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {},
                child: TextComp(
                  text: "logout",
                  color: Colors.black,
                  fontweight: FontWeight.normal,
                ),
              ),
              PopupMenuItem(
                child: TextComp(
                  text: "settings",
                  color: Colors.black,
                  fontweight: FontWeight.normal,
                ),
              ),
            ],
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("id", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data?.docs.length == 0) {
            return Center(
              child: TextComp(
                text: "No Contacts Till Now Inivite someone!",
                color: Colors.black,
              ),
            );
          }

          // data content
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs;
                List<UserModel> contacts = [];
                for (var element in data) {
                  var chat = UserModel.fromMap(element.data());
                  contacts.add(chat);
                }
                var contact = contacts[index];
                return chatShowProfile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          userData: UserModel(
                            email: contact.email,
                            id: contact.id,
                            username: contact.username,
                            profilePic: contact.profilePic,
                            bio: contact.bio,
                            pushToken: contact.pushToken,
                          ),
                        ),
                      ),
                    );
                  },
                  profileImg: contact.profilePic,
                  name: contact.username,
                  lastMsg: contact.bio,
                  dateShow: false,
                );
              },
            );
          }

          // no data content
          return Center(
            child: TextComp(
              text: "No Contact",
              color: Colors.black,
            ),
          );
        },
      ),
    );
  }
}

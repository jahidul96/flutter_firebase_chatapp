// ignore_for_file: must_be_immutable, unused_local_variable

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:knockme/features/auth_fb.dart';
import 'package:knockme/features/chat_func.dart';
import 'package:knockme/features/fb_storage.dart';
import 'package:knockme/models/message_model.dart';
import 'package:knockme/models/user_model.dart';
import 'package:knockme/utils/asset_files.dart';
import 'package:knockme/utils/fb_instance.dart';
import 'package:knockme/widgets/chat/chat_bottom_comp.dart';
import 'package:knockme/widgets/chat/message_comp.dart';
import 'package:knockme/widgets/file_send_comp.dart';
import 'package:knockme/widgets/text_comp.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "chatscreen";

  UserModel userData;
  ChatScreen({
    super.key,
    required this.userData,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textController = TextEditingController();
  late UserModel user;

  FirebaseAuth authUser = FirebaseAuth.instance;
  final storageRef = FirebaseStorage.instance.ref();
  File? _image;
  bool loading = false;

  // image grave from gallery
  Future pickFromGallery() async {
    var tempImg = await pickImage();
    setState(() {
      _image = tempImg;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    seenMsg();
  }

  // get myData
  void getUserData() async {
    var data = await getMyData();
    setState(() {
      user = UserModel.fromMap(data);
    });
  }

  // seen msg!
  void seenMsg() async {
    await db
        .collection("users")
        .doc(authUser.currentUser!.uid)
        .collection("chats")
        .doc(widget.userData.id)
        .update({"seen": false});
  }

// one to one chat functions
  void chat() async {
    onToOneChat(
        text: textController.text.isEmpty ? "" : textController.text,
        senderId: authUser.currentUser!.uid,
        senderProfilePic: user.profilePic,
        senderUsername: user.username,
        friendId: widget.userData.id,
        friendUsername: widget.userData.username,
        friendProfilePic: widget.userData.profilePic,
        image: _image,
        context: context);

    setState(() {
      _image = null;
    });
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        leadingWidth: 40,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                widget.userData.profilePic,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextComp(
                  text: widget.userData.username,
                  fontweight: FontWeight.normal,
                  size: 18,
                ),
                const SizedBox(height: 1),
                TextComp(
                  text: "online",
                  fontweight: FontWeight.normal,
                  size: 13,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),

      // body content
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AssetFiles.back,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: db
                    .collection("users")
                    .doc(authUser.currentUser!.uid)
                    .collection("chats")
                    .doc(widget.userData.id)
                    .collection("messages")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // data content
                  if (snapshot.hasData) {
                    return ListView.builder(
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // data store variables

                        final data = snapshot.data!.docs;
                        List<MessageModel> messages = [];

                        for (var element in data) {
                          var msg = MessageModel.fromMap(element.data());
                          messages.add(msg);
                        }

                        var singleMsg = messages[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 3),
                          child: MessageComp(
                            messageModel: singleMsg,
                          ),
                        );
                      },
                    );
                  }

                  // no data content
                  return Center(
                    child: TextComp(
                      text: "Start Conversation",
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),

            // image showcase
            _image != null
                ? FileSendComp(
                    image: _image!,
                    send: () => chat(),
                    clear: () {
                      setState(() {
                        _image = null;
                      });
                    },
                  )
                :
                // bottom content/chat send content
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                    child: ChatBottomComp(
                      onTap: () => chat(),
                      textController: textController,
                      pickImage: () => pickFromGallery(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
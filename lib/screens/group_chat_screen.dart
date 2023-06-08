// ignore_for_file: must_be_immutable, unused_local_variable, avoid_print, depend_on_referenced_packages

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:knockme/features/chat_func.dart';
import 'package:knockme/features/fb_storage.dart';
import 'package:knockme/models/group_model.dart';
import 'package:knockme/models/message_model.dart';
import 'package:knockme/models/user_model.dart';
import 'package:knockme/provider/user_provider.dart';
import 'package:knockme/screens/chat/chat_widgets.dart';
import 'package:knockme/screens/group_members_details.dart';
import 'package:knockme/utils/asset_files.dart';
import 'package:knockme/utils/fb_instance.dart';
import 'package:knockme/widgets/text_comp.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

import '../widgets/file_send_comp.dart';
import 'chat/message_comp.dart';

class GroupChatScreen extends StatefulWidget {
  static const routeName = "GroupChatScreen";

  GroupModel groupData;
  List<UserModel> grpMembersDetails;
  List membersId;
  UserModel adminDetails;
  String groupId;
  GroupChatScreen({
    super.key,
    required this.groupData,
    required this.groupId,
    required this.grpMembersDetails,
    required this.membersId,
    required this.adminDetails,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  TextEditingController textController = TextEditingController();

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

// send msg
  sendMsg() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var msgData = MessageModel(
        text: "",
        senderId: FirebaseAuth.instance.currentUser!.uid,
        createdAt: DateTime.now(),
        imgUrl: "",
        senderProfilePic: userProvider.user.profilePic,
        senderUsername: userProvider.user.username);

    if (_image != null) {
      // image upload process to fb bucket!!
      String fileName = p.basename(_image!.path);
      String imagePath = 'messageImages/${DateTime.now()}$fileName';

      try {
        var url = await uploadFile(
            image: _image, imagePath: imagePath, context: context);

        msgData.imgUrl = url;

        groupChat(
            msgData: msgData,
            groupId: widget.groupId,
            senderId: FirebaseAuth.instance.currentUser!.uid,
            text: textController.text);
      } catch (e) {
        print(e);
      }
    } else {
      msgData.text = textController.text;
      groupChat(
          msgData: msgData,
          groupId: widget.groupId,
          senderId: FirebaseAuth.instance.currentUser!.uid,
          text: textController.text);
    }

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
                widget.groupData.groupImg,
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
                  text: widget.groupData.groupName,
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
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: true,
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GroupDetails(
                        adminDetails: widget.adminDetails,
                        grpMembersDetails: widget.grpMembersDetails,
                        membersId: widget.membersId,
                        groupId: widget.groupId,
                      ),
                    ));
                  });
                },
                child: TextComp(
                  text: "Group Details",
                  color: Colors.black,
                  fontweight: FontWeight.normal,
                ),
              ),
            ],
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
                    .collection("groups")
                    .doc(widget.groupId)
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
                        return Container(
                          margin: const EdgeInsets.only(bottom: 3),
                          child: MessageComp(
                            messageModel: messages[index],
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
                    send: () => sendMsg(),
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
                    child: chatBottomComp(
                      onTap: () => sendMsg(),
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

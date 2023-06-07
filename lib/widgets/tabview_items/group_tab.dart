import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knockme/features/fb_firesore.dart';
import 'package:knockme/models/group_model.dart';
import 'package:knockme/screens/create_group.dart';
import 'package:knockme/screens/group_chat_screen.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/utils/fb_instance.dart';
import 'package:knockme/widgets/confirmation_model.dart';
import 'package:knockme/widgets/chat_show_profile.dart';
import 'package:knockme/widgets/text_comp.dart';

class GroupTabComp extends StatefulWidget {
  const GroupTabComp({super.key});

  @override
  State<GroupTabComp> createState() => _GroupTabCompState();
}

class _GroupTabCompState extends State<GroupTabComp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("groups")
            .where("members",
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
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
                text: "No Groups Till Now!!",
                color: AppColors.black,
              ),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs;
                List<GroupModel> groups = [];
                for (var element in data) {
                  var grp = GroupModel.fromMap(element.data());
                  groups.add(grp);
                }

                var group = groups[index];
                var groupId = data[index].id;

                return chatShowProfile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GroupChatScreen(
                          groupData: group,
                          groupId: groupId,
                          adminDetails: group.adminDetails,
                          membersId: group.members,
                          grpMembersDetails: group.memberDetails,
                        ),
                      ),
                    );

                    if (FirebaseAuth.instance.currentUser!.uid !=
                            group.senderId &&
                        group.seen == false) {
                      db
                          .collection("groups")
                          .doc(groupId)
                          .update({"seen": true});
                    }
                  },
                  profileImg: group.groupImg,
                  name: group.groupName,
                  lastMsg: group.lastMsg,
                  dateShow: true,
                  createdAt: group.createdAt,
                  isNewMessage: FirebaseAuth.instance.currentUser!.uid !=
                              group.senderId &&
                          group.seen == false
                      ? true
                      : false,
                  isGroupMessage: true,
                  isJustCreated: group.justCreated,
                  onLongPress: () {
                    confirmModel(
                      context: context,
                      infoText: "Want to delete This Group?",
                      confirmFunc: () {
                        if (FirebaseAuth.instance.currentUser!.uid !=
                            group.adminId) {
                          Navigator.pop(context);
                          alertUser(
                              context: context, alertText: "You Are Not Admin");
                        } else {
                          deleteGroupChat(groupId: groupId);
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                );
              },
            );
          }

          return Center(
            child: TextComp(
              text: "Something Went wrong!!",
              color: AppColors.black,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.appbarColor,
        onPressed: () {
          Navigator.pushNamed(context, CreateGroupScreen.routeName);
        },
        label: Row(
          children: [
            const Icon(
              Icons.group,
              size: 20,
            ),
            const SizedBox(width: 10),
            TextComp(
              text: "Create Group",
              fontweight: FontWeight.normal,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knockme/screens/home.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/utils/fb_instance.dart';
import 'package:knockme/widgets/confirmation_model.dart';
import 'package:knockme/widgets/text_comp.dart';

import '../models/user_model.dart';

class GroupDetails extends StatefulWidget {
  List<UserModel> grpMembersDetails;
  List membersId;
  UserModel adminDetails;
  String groupId;
  GroupDetails({
    super.key,
    required this.adminDetails,
    required this.grpMembersDetails,
    required this.membersId,
    required this.groupId,
  });

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  // leave group
  void leaveGroup(UserModel user) async {
    var newGrpMemberId =
        widget.membersId.where((element) => element != user.id).toList();
    var newMemberDeatils =
        widget.grpMembersDetails.where((element) => element != user);

    var filteredMembers = [];

    for (var element in newMemberDeatils) {
      var data = element.toMap();
      filteredMembers.add(data);
    }

    confirmModel(
        context: context,
        confirmFunc: () async {
          await db.collection("groups").doc(widget.groupId).update(
            {
              "members": newGrpMemberId,
              "memberDetails": filteredMembers,
            },
          );

          Navigator.pushNamed(context, HomeScreen.routeName);
        },
        infoText: "You Want To Leave This Group?");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: TextComp(text: "Group Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // admin details
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      widget.adminDetails.profilePic,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextComp(
                    text: widget.adminDetails.username,
                    color: AppColors.black,
                    size: 20,
                  ),
                  const SizedBox(height: 3),
                  TextComp(
                    text: "Admin",
                    color: AppColors.greyColor,
                    size: 17,
                    fontweight: FontWeight.normal,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            TextComp(
              text: "Group Members",
              color: AppColors.black,
            ),

            //  group members details
            ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.grpMembersDetails.length,
              itemBuilder: (context, index) {
                var membersDetails = widget.grpMembersDetails[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          membersDetails.profilePic,
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextComp(
                              text: membersDetails.username,
                              color: AppColors.greyColor,
                            ),
                            const SizedBox(height: 3),
                            Text(membersDetails.bio),
                          ],
                        ),
                      ),
                      membersDetails.id ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? IconButton(
                              onPressed: () => leaveGroup(membersDetails),
                              icon: const Icon(
                                Icons.clear,
                                color: AppColors.buttonColor,
                              ))
                          : Container(),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

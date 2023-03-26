// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knockme/features/auth_fb.dart';
import 'package:knockme/features/fb_storage.dart';
import 'package:knockme/models/group_model.dart';
import 'package:knockme/models/user_model.dart';
import 'package:knockme/screens/home.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/widgets/confirmation_model.dart';
import 'package:knockme/widgets/custom_button.dart';
import 'package:knockme/widgets/text_comp.dart';
import 'package:path/path.dart' as p;

class CreateGroupScreen extends StatefulWidget {
  static const routeName = "creategroup";
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final storageRef = FirebaseStorage.instance.ref();
  final db = FirebaseFirestore.instance;
  File? _image;
  bool loading = false;
  List<UserModel> friends = [];
  List<UserModel> selectedFriends = [];
  List selectedFriendsId = [];
  TextEditingController groupnameController = TextEditingController();
  // Map<String, dynamic> user = {};
  late UserModel user;

  @override
  void initState() {
    super.initState();
    getAllUser();
    getUserData();
  }

  // get myData
  void getUserData() async {
    var data = await getMyData();
    setState(() {
      user = UserModel.fromMap(data);
    });
  }

// get all friends
  getAllUser() async {
    var data = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var element in data.docs) {
      var user = UserModel.fromMap(element.data());
      setState(() {
        friends.add(user);
      });
    }
  }

  // image grave from gallery
  Future pickFromGallery() async {
    var tempImg = await pickImage();
    setState(() {
      _image = tempImg;
    });
  }

// select memmber
  selectMember(UserModel user) {
    if (selectedFriends.contains(user) || selectedFriendsId.contains(user.id)) {
      return alertUser(context: context, alertText: "Already Added!");
    }

    if (selectedFriends.length >= 6) {
      return alertUser(
          context: context, alertText: "Just 6 User Allowed for now");
    }
    setState(() {
      selectedFriends.add(user);
      selectedFriendsId.add(user.id);
    });
  }

// remove from list
  removerUser(index) {
    setState(() {
      selectedFriends.removeAt(index);
      selectedFriendsId.removeAt(index);
    });
  }

  // createGroup

  createGroup() async {
    // check all filed are filled
    if (groupnameController.text.isEmpty ||
        selectedFriends.isEmpty ||
        selectedFriendsId.isEmpty ||
        _image == null) {
      return alertUser(context: context, alertText: "All fields required!");
    }

    setState(() {
      loading = true;
    });

    selectedFriendsId.add(FirebaseAuth.instance.currentUser!.uid);

    try {
      // send image to fb
      String fileName = p.basename(_image!.path);
      String imagePath = 'groupImages/${DateTime.now()}$fileName';

      var url = await uploadFile(
          fileName: fileName,
          image: _image,
          imagePath: imagePath,
          context: context);

      var grpData = GroupModel(
          groupName: groupnameController.text,
          memberDetails: selectedFriends,
          lastMsg: "",
          members: selectedFriendsId,
          createdAt: Timestamp.now(),
          adminId: FirebaseAuth.instance.currentUser!.uid,
          adminDetails: user,
          groupImg: url,
          seen: false,
          senderId: FirebaseAuth.instance.currentUser!.uid,
          justCreated: true);

      // add group to db
      await db.collection("groups").add(grpData.toMap());
      setState(() {
        loading = false;
      });
      Navigator.pushNamed(context, HomeScreen.routeName);
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
      alertUser(context: context, alertText: "Something Went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.appbarColor,
        title: TextComp(
          text: "CreateGroup",
          size: 20,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // top content till create button end
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  // group photo
                  Center(
                    child: _image != null
                        ? GestureDetector(
                            onTap: () => pickFromGallery(),
                            child: Image.file(
                              _image!,
                              width: 160,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : GestureDetector(
                            onTap: () => pickFromGallery(),
                            child: Container(
                              width: 160,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                              ),
                              child: Center(
                                child: TextComp(
                                  text: "Add Group Photo",
                                  color: AppColors.greyColor,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),

                  //  groupname
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: groupnameController,
                      decoration: const InputDecoration(
                        hintText: "GroupName",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // add members
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minHeight: 100,
                      minWidth: double.infinity,
                      maxHeight: 150,
                      maxWidth: double.infinity,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: selectedFriends.isNotEmpty
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 150,
                                mainAxisExtent: 40,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                              ),
                              itemCount: selectedFriends.length,
                              itemBuilder: (context, index) {
                                var user = selectedFriends[index];
                                return InkWell(
                                  onTap: () => removerUser(index),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 6),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  user.profilePic,
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(user.username),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        top: 3,
                                        right: 3,
                                        child: Icon(
                                          Icons.clear,
                                          size: 15,
                                          color: AppColors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            )
                          : TextComp(
                              text: "click on contact and select members",
                              color: AppColors.greyColor,
                              fontweight: FontWeight.normal,
                              size: 14,
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      :
                      //  create grp button
                      CustomButton(
                          text: "Create Group",
                          onPressed: () => createGroup(),
                          borderRadius: 10,
                        ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // friends list

            friends.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      var user = friends[index];
                      return ListTile(
                        onTap: () => selectMember(user),
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              user.profilePic,
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            )),
                        title: Text(
                          user.username,
                        ),
                        subtitle: Text(
                          user.bio,
                        ),
                      );
                    },
                  )
                : Center(
                    child: TextComp(
                      text: "No Friends Invite Someone",
                      color: AppColors.black,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

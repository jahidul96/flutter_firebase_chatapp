import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knockme/screens/auth/auth_user_check.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/utils/asset_files.dart';
import 'package:knockme/widgets/text_comp.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "profilescreen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.appbarColor,
          elevation: 0,
          title: TextComp(
            text: "Profile",
            size: 18,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.network(
                              snapshot.data!["profilePic"],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextComp(
                                text: snapshot.data!["username"].toString(),
                                color: AppColors.greyColor,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.edit,
                                size: 20,
                                color: AppColors.greyColor,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextComp(
                            text: snapshot.data!["bio"].toString(),
                            color: AppColors.greyColor,
                            size: 16,
                            fontweight: FontWeight.normal,
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              iconTextComp(text: "Contacts"),
              iconTextComp(text: "Chats"),
              iconTextComp(text: "Privacy"),
              iconTextComp(text: "Account"),
              iconTextComp(text: "Settings"),

              // logout conetents
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Want to Logout?"),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.appbarColor,
                              ),
                              child: const Text("Cancel")),
                          ElevatedButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushNamed(
                                    context, CheckAuthUser.routeName);
                                Get.snackbar("Knockme App", "Logout succesfull",
                                    backgroundColor: AppColors.buttonColor);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                              ),
                              child: const Text("Ok")),
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextComp(
                    text: "Logout",
                    color: AppColors.greyColor,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget iconTextComp({required String text}) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextComp(
                  text: text,
                  color: AppColors.greyColor,
                  fontweight: FontWeight.normal,
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.greyColor,
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      );
}

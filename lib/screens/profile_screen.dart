import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knockme/provider/user_provider.dart';
import 'package:knockme/screens/auth/auth_user_check.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/widgets/text_comp.dart';
import 'package:provider/provider.dart';

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

            Consumer<UserProvider>(
              builder: (context, userProvider, child) => Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: CachedNetworkImage(
                      imageUrl: userProvider.user.profilePic,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.black,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        size: 35,
                      ),
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
                        text: userProvider.user.username,
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
                    text: userProvider.user.bio,
                    color: AppColors.greyColor,
                    size: 16,
                    fontweight: FontWeight.normal,
                  ),
                ],
              ),
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
      ),
    );
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

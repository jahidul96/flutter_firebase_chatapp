// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knockme/features/auth_fb.dart';
import 'package:knockme/models/user_model.dart';
import 'package:knockme/provider/user_provider.dart';

import 'package:knockme/screens/profile_screen.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/widgets/tabview_items/chat_tab_content.dart';
import 'package:knockme/widgets/tabview_items/group_tab.dart';
import 'package:knockme/widgets/text_comp.dart';
import 'package:provider/provider.dart';

import '../features/fb_firesore.dart';
import '../features/push_notification.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    getUserData();
    updatePushToken();
    notificationServices.requestPermissonNotification();
    notificationServices.firebaseInit();
    getTokenTT();
    super.initState();
  }

  getTokenTT() async {
    var str = await notificationServices.getToken();
    print(str);
  }

  getUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final data = await getMyData();

      userProvider.setUser(UserModel.fromMap(data));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TextComp(
            text: "Chatapp",
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
                  enabled: true,
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    });
                  },
                  child: TextComp(
                    text: "Profile",
                    color: Colors.black,
                    fontweight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
            ),
            labelStyle: TextStyle(fontSize: 15),
            indicatorColor: AppColors.whiteColor,
            indicatorWeight: 3,
            labelPadding: EdgeInsets.symmetric(vertical: 10),
            tabs: [
              Text("Chats"),
              Text("Groups"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // chats tab content,
            ChatTabComp(),
            // group tab content,
            GroupTabComp(),
          ],
        ),
      ),
    );
  }
}

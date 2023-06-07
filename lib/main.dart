import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:knockme/screens/auth/auth_user_check.dart';
import 'package:knockme/screens/auth/login.dart';
import 'package:knockme/screens/auth/register.dart';
import 'package:knockme/screens/contacts.dart';
import 'package:knockme/screens/create_group.dart';
import 'package:knockme/screens/home.dart';
import 'package:knockme/screens/profile_screen.dart';
import 'package:knockme/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Knockme chatapp',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.appbarColor,
        ),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      routes: {
        CheckAuthUser.routeName: (context) => const CheckAuthUser(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        ContactScreen.routeName: (context) => const ContactScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        CreateGroupScreen.routeName: (context) => const CreateGroupScreen(),
      },
      home: const CheckAuthUser(),
    );
  }
}

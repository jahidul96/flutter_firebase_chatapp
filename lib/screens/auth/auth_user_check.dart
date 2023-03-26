import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:knockme/screens/auth/register.dart';
import 'package:knockme/screens/home.dart';

class CheckAuthUser extends StatelessWidget {
  static const routeName = "authcheck";
  const CheckAuthUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const RegisterScreen();
          }
        },
      ),
    );
  }
}

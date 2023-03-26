import 'package:flutter/material.dart';
import 'package:knockme/screens/auth/add_profile_pic.dart';
import 'package:knockme/screens/auth/login.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/widgets/confirmation_model.dart';

import 'package:knockme/widgets/custom_button.dart';
import 'package:knockme/widgets/text_comp.dart';
import 'package:knockme/widgets/text_input_container.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "registerpage";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

// profile pic adding function!!
  addProfilePic(BuildContext context) {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        usernameController.text.isEmpty) {
      return alertUser(context: context, alertText: "All Field Required!!");
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddProfilePicScreen(
        email: emailController.text,
        username: usernameController.text,
        password: passwordController.text,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Icon(
                Icons.lock,
                size: 50,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(height: 20),

            // input containers
            ContainerTextInput(
              icon: Icons.person,
              hintText: "Username",
              inputController: usernameController,
            ),
            const SizedBox(height: 15),
            ContainerTextInput(
              inputController: emailController,
              icon: Icons.email,
              hintText: "Email",
            ),
            const SizedBox(height: 15),
            ContainerTextInput(
              inputController: passwordController,
              icon: Icons.lock,
              hintText: "Password",
            ),
            const SizedBox(height: 15),
            CustomButton(
              text: "NEXT",
              onPressed: () => addProfilePic(context),
            ),
            const SizedBox(height: 15),

            TextComp(
              text: "Already Have Account?",
              size: 15,
            ),

            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
              child: TextComp(
                text: "Login Here!",
                size: 15,
                fontweight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

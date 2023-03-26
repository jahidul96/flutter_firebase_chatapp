import 'package:flutter/material.dart';
import 'package:knockme/features/auth_fb.dart';
import 'package:knockme/screens/auth/register.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/widgets/custom_button.dart';
import 'package:knockme/widgets/text_comp.dart';
import 'package:knockme/widgets/text_input_container.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "loginpage";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
              text: "SIGN IN",
              onPressed: () => loginUser(
                  emailController.text, passwordController.text, context),
            ),
            const SizedBox(height: 15),
            TextComp(
              text: "Don't Have Account?",
              size: 15,
            ),

            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RegisterScreen.routeName);
              },
              child: TextComp(
                text: "Register Here!",
                fontweight: FontWeight.normal,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
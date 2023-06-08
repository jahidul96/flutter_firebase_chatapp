import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knockme/features/auth_fb.dart';
import 'package:knockme/screens/auth/register.dart';
import 'package:knockme/utils/app_colors.dart';
import 'package:knockme/widgets/confirmation_model.dart';
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

  login() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return alertUser(context: context, alertText: "Fill all the filed's");
    }

    setState(() {
      loading = true;
    });

    Timer(
      const Duration(seconds: 3),
      () {
        loginUserFb(emailController.text, passwordController.text, context);
        setState(() {
          loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Icon(
                Icons.lock,
                size: 50,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 10),

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
              secureText: true,
            ),
            const SizedBox(height: 25),

            loading
                ? Column(
                    children: [
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      const SizedBox(height: 20),
                      TextComp(
                        text: "Logging wait...",
                        color: AppColors.black,
                      )
                    ],
                  )
                : Column(
                    children: [
                      CustomButton(
                        text: "SIGN IN",
                        onPressed: () => login(),
                      ),
                      const SizedBox(height: 15),
                      TextComp(
                        text: "Don't Have Account?",
                        size: 16,
                        color: AppColors.black,
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, RegisterScreen.routeName);
                        },
                        child: TextComp(
                          text: "Register Here!",
                          size: 18,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

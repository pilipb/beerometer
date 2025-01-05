import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the screen width for button width
    final double screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Login", style: TextStyle(fontSize: 18)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email Input
              CupertinoTextField(
                controller: emailController,
                placeholder: "Email",
                keyboardType: TextInputType.emailAddress,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                style: const TextStyle(color: CupertinoColors.white),
              ),
              const SizedBox(height: 16),

              // Password Input
              CupertinoTextField(
                controller: passwordController,
                placeholder: "Password",
                obscureText: true,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                style: const TextStyle(color: CupertinoColors.white),
              ),
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: screenWidth * 0.9, // 90% width of the screen
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    controller.signInWithEmail(email, password);
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Register Button
              SizedBox(
                width: screenWidth * 0.9,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: CupertinoColors.darkBackgroundGray,
                  borderRadius: BorderRadius.circular(10),
                  onPressed: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    controller.registerWithEmail(email, password);
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      color: CupertinoColors.activeBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Google Sign-In Button
              // SizedBox(
              //   width: screenWidth * 0.9,
              //   child: CupertinoButton(
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     color: CupertinoColors.systemGrey,
              //     borderRadius: BorderRadius.circular(10),
              //     onPressed: controller.signInWithGoogle,
              //     child: const Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(CupertinoIcons.person_crop_circle_badge_plus,
              //             color: CupertinoColors.black),
              //         SizedBox(width: 8),
              //         Text(
              //           "Login with Google",
              //           style: TextStyle(
              //             color: CupertinoColors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

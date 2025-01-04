import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with Email and Password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Get.snackbar("Success", "Logged in successfully!");
      // Navigate to the next screen
      Get.offAllNamed('/home'); // Replace '/home' with your home route
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Register with Email and Password
  Future<void> registerWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Get.snackbar("Success", "Account created successfully!");
      // Navigate to the next screen
      Get.offAllNamed('/home'); // Replace '/home' with your home route
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      await _auth.signInWithPopup(GoogleAuthProvider());
      // Get.snackbar("Success", "Logged in with Google successfully!");
      // Navigate to the next screen
      Get.offAllNamed('/home'); // Replace '/home' with your home route
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

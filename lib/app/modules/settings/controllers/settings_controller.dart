import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

    void deleteUserData() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar("Error", "No user logged in!");
        return;
      }

      // Delete user's Firestore data
      await _firestore.collection('users').doc(userId).delete();

      // Provide feedback to the user
      Get.snackbar("Success", "Your data has been deleted!");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete data: $e");
    }
  }

  void signOut() {
    auth.signOut();
    Get.offAllNamed('/login');
  }

  void changePassword() {
    auth.sendPasswordResetEmail(email: auth.currentUser!.email!);
    Get.snackbar("Success", "Password reset email sent!");
  }
}

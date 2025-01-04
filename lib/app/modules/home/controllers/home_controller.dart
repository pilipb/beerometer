import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Helper to get the current date in YYYY-MM-DD format
  String _getCurrentDate() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  // Add units to Firestore
  Future<void> _addUnits(String type, double units) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not logged in");
      }

      final dateKey = _getCurrentDate();
      final dailyRecordRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyRecords')
          .doc(dateKey);

      final record = await dailyRecordRef.get();

      if (record.exists) {
        // Update existing daily record
        await dailyRecordRef.update({
          "totalUnits": FieldValue.increment(units),
          "entries": FieldValue.arrayUnion([
            {
              "type": type,
              "units": units,
              "timestamp": Timestamp.now(),
            }
          ]),
        });
      } else {
        // Create new daily record
        await dailyRecordRef.set({
          "date": dateKey,
          "totalUnits": units,
          "entries": [
            {
              "type": type,
              "units": units,
              "timestamp": Timestamp.now(),
            }
          ],
        });
      }

      // Get.snackbar("Success", "Added $units units of $type");
    } catch (e) {
      // Get.snackbar("Error", e.toString());
    }
  }

  // Methods for each drink type
  Future<void> addBeer() => _addUnits("beer", 2.0); // 2.0 units for a beer
  Future<void> addWine() => _addUnits("wine", 2.0); // 2.0 units for a glass of wine
  Future<void> addSpirit() => _addUnits("spirit", 1.0); // 1.0 unit for a spirit
}

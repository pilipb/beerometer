import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class StatsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final drinksPerDay = <String, double>{}.obs;
  final drinksPerMonth = <String, double>{}.obs;
  final drinksPerYear = <String, double>{}.obs;

  Future<void> fetchStats() async {
    final userId = _auth.currentUser?.uid;
    try {
      final records = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyRecords')
          .get();

      // Temporary data holders
      final dayStats = <String, double>{};
      final monthStats = <String, double>{};
      final yearStats = <String, double>{};

      for (var doc in records.docs) {
        final data = doc.data();
        final date = DateTime.parse(data['date']);
        final totalUnits = data['totalUnits'] as double;

        // Daily stats
        dayStats[data['date']] = totalUnits;

        // Monthly stats
        final monthKey =
            "${date.year}-${date.month.toString().padLeft(2, '0')}";
        monthStats[monthKey] = (monthStats[monthKey] ?? 0) + totalUnits;

        // Yearly stats
        final yearKey = "${date.year}";
        yearStats[yearKey] = (yearStats[yearKey] ?? 0) + totalUnits;
      }

      drinksPerDay.assignAll(dayStats);
      drinksPerMonth.assignAll(monthStats);
      drinksPerYear.assignAll(yearStats);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch stats: $e");
    }
  }
}

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
  final now = DateTime.now();

  // Fetch data for the last 7 days
  final last7Days = List.generate(7, (index) => now.subtract(Duration(days: index)))..sort((a, b) => a.compareTo(b));
  final dayStats = <String, double>{};
  final monthStats = <String, double>{};
  final yearStats = <String, double>{};

  // Initialize dayStats with 0 for each of the last 7 days
    for (var day in last7Days) {
      final dayKey =
          "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
      dayStats[dayKey] = 0.0;
    }

  final records = await _firestore
      .collection('users')
      .doc(userId)
      .collection('dailyRecords')
      .get();

  for (var doc in records.docs) {
    final data = doc.data();
    final date = DateTime.parse(data['date']);
    final totalUnits = data['totalUnits'] as double;

    // Daily
    if (last7Days.any((d) => d.day == date.day && d.month == date.month && d.year == date.year)) {
      dayStats[data['date']] = totalUnits;
    }

    // Monthly
    if (date.year == now.year && date.month == now.month) {
      final monthKey = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      monthStats[monthKey] = (monthStats[monthKey] ?? 0) + totalUnits;
    }

    // Yearly
    if (date.year == now.year) {
      final yearKey = "${date.year}";
      yearStats[yearKey] = (yearStats[yearKey] ?? 0) + totalUnits;
    }
  }

  drinksPerDay.assignAll(dayStats);
  drinksPerMonth.assignAll(monthStats);
  drinksPerYear.assignAll(yearStats);
}

}

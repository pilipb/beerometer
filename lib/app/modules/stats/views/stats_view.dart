import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/stats_controller.dart';

class StatsView extends GetView<StatsController> {
  @override
  Widget build(BuildContext context) {

    // Fetch stats on page load
    controller.fetchStats();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Stats", style: TextStyle(fontSize: 18)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Drinks Per Day",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.drinksPerDay.length,
                    itemBuilder: (context, index) {
                      final date =
                          controller.drinksPerDay.keys.elementAt(index);
                      final units = controller.drinksPerDay[date];
                      return _buildStatRow("Date: $date", "Units: $units");
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Drinks Per Month",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.drinksPerMonth.length,
                    itemBuilder: (context, index) {
                      final month =
                          controller.drinksPerMonth.keys.elementAt(index);
                      final units = controller.drinksPerMonth[month];
                      return _buildStatRow("Month: $month", "Units: $units");
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Drinks Per Year",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.drinksPerYear.length,
                    itemBuilder: (context, index) {
                      final year =
                          controller.drinksPerYear.keys.elementAt(index);
                      final units = controller.drinksPerYear[year];
                      return _buildStatRow("Year: $year", "Units: $units");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(subtitle, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/stats_controller.dart';

class StatsView extends GetView<StatsController> {
  @override
  Widget build(BuildContext context) {
    // Fetch stats on page load
    controller.fetchStats();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          children: [
            const SizedBox(height: 40),
            CupertinoNavigationBar(
              backgroundColor: CupertinoColors.transparent,
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.back),
              ),
              middle: const Text("Stats", style: TextStyle(fontSize: 28)),
              trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.info),
                  onPressed: () {
                    _showInfoDialog(context);
                  }),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Drinks this week",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Obx(() => _buildBarChart(controller.drinksPerDay, "Daily")),
                const SizedBox(height: 12),
                const Text(
                  "Monthly drinks",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Obx(() => _buildBarChart(controller.drinksPerMonth, "Monthly")),
                const SizedBox(height: 12),
                const Text(
                  "Yearly drinks",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Obx(() => _buildBarChart(controller.drinksPerYear, "Yearly")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(Map<String, double> data, String label) {
    if (data.isEmpty) {
      return const Text(
        "No data available",
        style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 16),
      );
    }

    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final screenHeight = MediaQuery.of(Get.context!).size.height;

    // Determine bar     width based on label
    final barWidth = label == "Daily"
        ? screenWidth / 9 // Daily bars are 1/8 of the screen width
        : label == "Monthly"
            ? screenWidth / 13 // Monthly bars are 1/32 of the screen width
            : screenWidth / 6; // Yearly bars are 1/13 of the screen width

    final maxUnits = data.values.isNotEmpty
        ? data.values.reduce((a, b) => a > b ? a : b)
        : 1.0;

    // Recommended value (e.g., 14 units per week for 7 days, ~2 units/day)
    final recommendedValue =
        label == "Daily" ? 2.0 : (label == "Monthly" ? 56.0 : 14.0 * 12);

    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.darkBackgroundGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: screenHeight / 3, // Fixed height for the chart
          child: Stack(
            children: [
              // Bar chart
              ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 4), // Spacing between bars
                itemBuilder: (context, index) {
                  final entry = data.entries.elementAt(index);
                  final date = entry.key; // Date (e.g., "2025-01-04")
                  final units = entry.value; // Total units
                  final barHeight = (units / maxUnits) *
                      screenHeight /
                      4; // Scale bars to fit

                  return Column(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Align bars at the bottom
                    children: [
                      Stack(
                        alignment: Alignment
                            .bottomCenter, // Ensure bars align to the bottom
                        children: [
                          Container(
                            width: barWidth,
                            // height: 100, // Full bar height
                            decoration: BoxDecoration(
                              color: CupertinoColors
                                  .transparent, // Background color
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Container(
                            width: barWidth,
                            height: barHeight, // Scaled bar height
                            decoration: BoxDecoration(
                              color: CupertinoColors.activeBlue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _shortenLabel(date, label),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        units.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 12, color: CupertinoColors.systemGrey),
                      ),
                    ],
                  );
                },
              ),
              // Add dotted line for recommended value
              maxUnits > recommendedValue
                  ? Positioned(
                      bottom: (recommendedValue / maxUnits) * screenHeight / 4 +
                          28, // Position line
                      left: 0,
                      right: 0,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            children: [
                              ...List.generate(
                                (constraints.maxWidth / 7).floor(),
                                (index) => Container(
                                  width: 3,
                                  height: 3,
                                  color: CupertinoColors.systemOrange,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                ),
                              ),
                              // const Positioned(
                              //   left: 0,
                              //   right: 0,
                              //   child: Text(
                              //     "Gov Recommended",
                              //     textAlign: TextAlign.center,
                              //     style: TextStyle(
                              //       fontSize: 15,
                              //       color: CupertinoColors.systemOrange,
                              //     ),
                              //   ),
                              // ),
                            ],
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showInfoDialog(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Recommended Consumption"),
          content: const Text(
            "The orange line represents the recommended alcohol consumption, 14 units a week (see NHS website for more info)",
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  String _shortenLabel(String date, String label) {
    switch (label) {
      case "Daily":
        return date.split('-').last; // Show day (e.g., "04")
      case "Monthly":
        return date.split('-').last; // Show month (e.g., "01")
      case "Yearly":
        return date; // Show full year (e.g., "2025")
      default:
        return date;
    }
  }
}

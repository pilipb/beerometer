import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          children: [
            const SizedBox(
              height: 40),
            CupertinoNavigationBar(
              backgroundColor: CupertinoColors.transparent,
                    leading: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                      Get.toNamed('settings');
                    },
                      child: const Icon(CupertinoIcons.settings),
                    ),
                    middle: const Text(
                      "I've just had a...",
                      style: TextStyle(fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.chart_bar_alt_fill), 
                      onPressed: () {
                      Get.toNamed('stats');
                    }),
                  ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SafeArea(
          top: true,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildButtonContainer(
                  screenWidth,
                  screenHeight,
                  AnimatedActionButton(
                    label: "Beer",
                    icon: Icons.local_drink,
                    action: controller.addBeer,
                  ),
                ),
                const SizedBox(height: 16),
                _buildButtonContainer(
                  screenWidth,
                  screenHeight,
                  AnimatedActionButton(
                    label: "Wine",
                    icon: Icons.wine_bar_rounded,
                    action: controller.addWine,
                  ),
                ),
                const SizedBox(height: 16),
                _buildButtonContainer(
                  screenWidth,
                  screenHeight,
                  AnimatedActionButton(
                    label: "Spirit",
                    icon: Icons.emoji_food_beverage_rounded,
                    action: controller.addSpirit,
                  ),
                ),
                // const SizedBox(height: 28),
                // ElevatedButton(
                //   onPressed: () {
                //     Get.toNamed('stats');
                //   },
                //   child: const Text('Stats'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Wrap buttons in a container to control width
  Widget _buildButtonContainer(
      double screenWidth, double screenHeight, Widget button) {
    return SizedBox(
      width: screenWidth * 0.9, // 90% of the screen width
      height: screenHeight * 0.2,
      child: button,
    );
  }
}

class AnimatedActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Future<void> Function() action;

  const AnimatedActionButton({
    required this.label,
    required this.icon,
    required this.action,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedActionButtonState createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton> {
  bool _isSuccess = false;

  void _handleTap() async {
    try {
      // Trigger the action
      await widget.action();

      // Show success animation
      setState(() {
        _isSuccess = true;
      });

      // Reset to default state after 1 second
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isSuccess = false;
      });
    } catch (e) {
      // Handle error (optional)
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: _isSuccess
          ? CupertinoColors.activeGreen
          : CupertinoColors.darkBackgroundGray,
      borderRadius: BorderRadius.circular(10),
      onPressed: _handleTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center icon and label
        children: [
          Icon(
            _isSuccess ? CupertinoIcons.check_mark : widget.icon,
            color: CupertinoColors.white,
          ),
          const SizedBox(width: 8),
          Text(
            widget.label,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

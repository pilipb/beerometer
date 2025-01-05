import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          children: [
            const SizedBox(height: 40),
            CupertinoNavigationBar(
              backgroundColor: CupertinoColors.transparent,
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed:  () {
                  Get.back();
                },
                child:  const Icon(CupertinoIcons.back),
              ),
              middle: const Text("Settings", style: TextStyle(fontSize: 28)),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // you are logged in as...
              Text(
                "You are logged in as ${controller.auth.currentUser?.email ?? 'Unknown'}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              // Sign Out Button
              CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: CupertinoColors.systemGrey,
                borderRadius: BorderRadius.circular(10),
                onPressed: () {
                  controller.signOut();
                },
                child: const Text(
                  "Sign Out",
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // change password button
              CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: CupertinoColors.systemGrey,
                borderRadius: BorderRadius.circular(10),
                onPressed: () {
                  controller.changePassword();
                },
                child: const Text(
                  "Change Password",
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Delete User Data Button
              CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: CupertinoColors.destructiveRed,
                borderRadius: BorderRadius.circular(10),
                onPressed: () async {
                  final confirmed = await _showConfirmationDialog(context);
                  if (confirmed) {
                    controller.deleteUserData();
                  }
                },
                child: const Text(
                  "Delete All User Data",
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showCupertinoDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text("Delete All Data"),
              content: const Text(
                  "Are you sure you want to delete all your data? This action cannot be undone."),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: const Text("Delete"),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }


}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> alertexit() async {
  return await Get.defaultDialog<bool>(
        title: "Warning",
        middleText: "Are you sure that you want to exit the app?",
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ) ??
      false;
}

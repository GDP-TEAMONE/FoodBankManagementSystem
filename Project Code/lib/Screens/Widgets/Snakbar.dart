import 'package:flutter/material.dart';
import 'package:get/get.dart';
void showSnackBar(String title, String message, Color backgroundColor) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    colorText: Colors.white,
    backgroundColor: backgroundColor,
    margin: EdgeInsets.zero,
    duration: const Duration(milliseconds: 2000),
    boxShadows: [
      const BoxShadow(
        color: Colors.grey,
        offset: Offset(-100, 0),
        blurRadius: 20,
      ),
    ],
    borderRadius: 0,
  );
}
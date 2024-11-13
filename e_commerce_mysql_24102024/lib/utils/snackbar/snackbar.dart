import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustsomSnackbar(
  String message, {
  bool isError = true,
  String title = 'Error',
}) {
  Get.snackbar(
    backgroundColor: Colors.red,
    title,
    message,
    titleText: Text(
      title,
      style: const TextStyle(
        color: Colors.black,
      ),
    ),
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.black,
      ),
    ),
  );
}

import 'package:e_commerce_riverpod_and_backend/mainpages/nav_bar.dart';
import 'package:e_commerce_riverpod_and_backend/view/loginpages/sign_up.dart';
import 'package:e_commerce_riverpod_and_backend/view/loginpages/sing_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth/functions.dart';

void main() {
  Get.put(
    UserController(),
  );
  WidgetsFlutterBinding.ensureInitialized();
  UserController userController = UserController();
  userController.onInit();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SingIn(),
        ),
      ),
    );
  }
}

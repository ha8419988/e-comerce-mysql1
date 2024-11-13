import 'package:e_commerce_riverpod_and_backend/auth/functions.dart';
import 'package:e_commerce_riverpod_and_backend/mainpages/profile_utils/user_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      body: SizedBox(
        height: 200,
        child: UserData(),
      ),
    ));
  }
}

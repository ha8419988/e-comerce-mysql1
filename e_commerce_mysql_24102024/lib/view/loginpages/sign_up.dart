import 'package:e_commerce_riverpod_and_backend/mainpages/home_page.dart';
import 'package:e_commerce_riverpod_and_backend/utils/snackbar/snackbar.dart';
import 'package:e_commerce_riverpod_and_backend/utils/textfields/textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/functions.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  UserController userController = Get.put(UserController());
  bool isLoading = false;
  bool isPasswordVisible = false;

  void registration(UserController userController) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty) {
      showCustsomSnackbar(
        'Type in your name',
        title: 'Name Address',
      );
    } else if (email.isEmpty) {
      showCustsomSnackbar(
        'Type in your email',
        title: 'Email Address',
      );
    } else if (!GetUtils.isEmail(email)) {
      showCustsomSnackbar(
        'Type your valid email address',
        title: 'Valid Email Address',
      );
    } else if (password.length < 6) {
      showCustsomSnackbar(
        'Password cannot be less 6 characters',
        title: 'Password',
      );
    } else if (password.isEmpty) {
      showCustsomSnackbar(
        'Type in your password',
        title: 'Password',
      );
    } else {
      setState(() {
        isLoading = true;
      });
    }

    try {
      bool success = await userController.registerUser(
        name,
        email,
        password,
      );

      if (success) {
        Get.to(
          const HomePage(),
        );
      } else {
        showCustsomSnackbar(
          'Register failed. Please try again',
          title: 'Registration',
        );
      }
    } catch (e) {
      showCustsomSnackbar(
        'An error occured during registration',
        title: 'Registration',
      );
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = 'ha';
    emailController.text = 'ha@gmail.com';
    passwordController.text = '11111111';
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Text(
                      'Sign Up',
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextField(
                      textEditingController: nameController,
                      leftIcon: Icons.person,
                      hintText: 'Name',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      textEditingController: emailController,
                      leftIcon: Icons.email,
                      hintText: 'Email',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      textEditingController: passwordController,
                      leftIcon: Icons.password,
                      hintText: 'Password',
                      isObsecure: !isPasswordVisible,
                      rightIcon: isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onRightIconPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          registration(userController);
                        },
                        child: Container(
                          width: 140,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            color: const Color.fromARGB(255, 102, 104, 209),
                          ),
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: RichText(
                          text: TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.back(),
                              text: 'Have an accoount already ?',
                              style: GoogleFonts.aBeeZee(
                                color: Colors.black,
                                fontSize: 20,
                              ))),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

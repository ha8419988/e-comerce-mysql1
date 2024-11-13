import 'package:e_commerce_riverpod_and_backend/auth/functions.dart';
import 'package:e_commerce_riverpod_and_backend/mainpages/nav_bar.dart';
import 'package:e_commerce_riverpod_and_backend/utils/snackbar/snackbar.dart';
import 'package:e_commerce_riverpod_and_backend/utils/textfields/textfield.dart';
import 'package:e_commerce_riverpod_and_backend/view/loginpages/sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';

class SingIn extends StatefulWidget {
  const SingIn({super.key});

  @override
  State<SingIn> createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  UserController userController = Get.put(UserController());
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    emailController.text = 'ha@gmail.com';
    passwordController.text = '11111111';
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

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
                      'Sign In',
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
                        onPressed: () async {
                          // if (_formKey.currentState?.validate() ?? false) {
                          bool success =
                              await userController.login(email, password);
                          if (success) {
                            print('login success');
                            Get.to(() => const NavBar());
                          } else {
                            showCustsomSnackbar('invalid email or password',
                                title: 'login fail');
                          }
                          // }
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
                              'Sign In',
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
                                ..onTap = () => Get.to(const SignUp()),
                              text: 'Have an accoount  ?',
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

  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty) {
      showCustsomSnackbar(
        'Type in your email',
        title: 'Email',
      );
    } else if (GetUtils.isEmail(email)) {
      showCustsomSnackbar(
        'Type your email valid',
        title: 'Email',
      );
    } else if (password.isEmpty) {
      showCustsomSnackbar(
        'Type in your password',
        title: 'Password',
      );
    } else {
      MySqlConnection? connection;
      try {
        connection = await userController.connectToDatabase();
        final result = await connection.query(
            'select name,email from users where email=? and password=?',
            [email, password]);
        if (result.isNotEmpty) {
          await connection.close();
          Get.to(const SingIn());
        } else {
          showCustsomSnackbar(
            'Invalid email or password',
            title: 'Login Failed',
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('error with $e');
        }
      } finally {
        await connection?.close();
      }
    }
  }
}

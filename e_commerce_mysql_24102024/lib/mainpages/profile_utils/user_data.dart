import 'dart:typed_data';

import 'package:e_commerce_riverpod_and_backend/auth/functions.dart';
import 'package:e_commerce_riverpod_and_backend/mainpages/profile_utils/profile_picture.dart';
import 'package:e_commerce_riverpod_and_backend/view/loginpages/sing_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final UserController userController = Get.find<UserController>();
  String imagePathProfile = '';
  @override
  void initState() {
    loadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: GetBuilder<UserController>(
      builder: (userController) {
        final User? user = userController.user.value;
        if (user == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Profile',
                style: GoogleFonts.aBeeZee(),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(const SingIn());
                  },
                  child: Container(
                    width: 200,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.aBeeZee(
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Please login to view profile ',
                  style: GoogleFonts.aBeeZee(
                      fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
        } else {
          return Scaffold(
            body: GetBuilder<UserController>(builder: (userController) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showImageSelectionDialog(
                                  userController.user.value?.id ?? 0);
                            },
                            child: ProfilePicture(imagePath: imagePathProfile),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.sinceMember != null
                                    ? DateFormat('yyyy-MM-dd').format(
                                        DateTime.parse(user.sinceMember!))
                                    : '',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(
                                  user.email ?? '',
                                  style: GoogleFonts.aBeeZee(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 160,
                            child: Text(
                              user.name,
                              style: GoogleFonts.aBeeZee(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                userController.logout();
                                Get.to(const SingIn());
                              },
                              child: Text(
                                'Logout',
                                style: GoogleFonts.aBeeZee(),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        }
      },
    ));
  }

  void loadImage() async {
    if (userController.user.value?.id != null) {}
    String? imagePath = await getPathImage(userController.user.value!.id!);
    setState(() {
      imagePathProfile = imagePath ?? '';
    });
  }

  Future<void> saveImagePathInDatabase(int userId, String imagePath) async {
    MySqlConnection? connection;
    try {
      connection = await userController.connectToDatabase();
      var result = await connection
          .query('select * from images where userid=?', [userId]);
      if (result.isNotEmpty) {
        await connection.query('update images set ImagePath=? where userid=?',
            [imagePath, userId]);
      } else {
        await connection.query(
            'insert into images(userid,ImagePath) Values(?,?)',
            [userId, imagePath]);
      }
    } finally {
      await connection?.close();
    }
  }

  void _showImageSelectionDialog(int userId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Profile Picture'),
          content: Column(
            children: [
              InkWell(
                onTap: () async {
                  String imagePath =
                      'https://hanoifc.com.vn/no-img-500x500.jpg';
                  await saveImagePathInDatabase(userId, imagePath);
                  setState(() {
                    imagePathProfile = imagePath;
                  });
                },
                child: Image.network(
                  'https://hanoifc.com.vn/no-img-500x500.jpg',
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  String imagePath =
                      'https://hanoifc.com.vn/no-img-500x500.jpg';
                  await saveImagePathInDatabase(userId, imagePath);
                  setState(() {
                    imagePathProfile = imagePath;
                  });
                  Navigator.pop(context);
                },
                child: Image.network(
                  'https://hanoifc.com.vn/no-img-500x500.jpg',
                  width: 80,
                  height: 80,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> getPathImage(int userId) async {
    MySqlConnection? connection;

    try {
      connection = await userController.connectToDatabase();
      var result = await connection
          .query('select ImagePath from images where userid= ?', [userId]);
      if (result.isNotEmpty) {
        final imagePathData = result.first['ImagePath'];
        print('image path from Database $imagePathData');
        if (imagePathData is String) {
          return imagePathData;
        } else if (imagePathData is Uint8List) {
          return String.fromCharCodes(imagePathData);
        }
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      connection?.close();
    }
  }
}

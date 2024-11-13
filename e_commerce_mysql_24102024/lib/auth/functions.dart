import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/snackbar/snackbar.dart';

class User {
  final int? id;
  final String name;
  final String? email;
  String? sinceMember;
  User({
    this.id,
    required this.name,
    required this.email,
    this.sinceMember,
  });
}

class UserController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);
  Future<MySqlConnection> connectToDatabase() async {
    const host = '192.168.1.223'; //Ip v4
    var settings = ConnectionSettings(
      host: host,
      port: 3306,
      user: 'user2410',
      password: '11111111',
      db: 'userdata',
    );

    await Future.delayed(const Duration(
      milliseconds: 100,
    ));
    final connection = await MySqlConnection.connect(settings);
    return connection;
  }

  Future<bool> registerUser(
    String name,
    String email,
    String password,
  ) async {
    MySqlConnection? connection;
    try {
      connection = await connectToDatabase();
      var emailCheckReuslt =
          await connection.query('select * from users where email=?', [email]);
      if (emailCheckReuslt.isNotEmpty) {
        showCustsomSnackbar(
          'Email already registerd.Please log in or use a orther email',
          title: 'Registration',
        );
        return false;
      }
      var now = DateTime.now();
      var formatDate = DateFormat('yyyy-MM-dd').format(now);
      var insertResult = await connection.query(
          'insert into users(Name, Email, Password,since_member) VALUES (?,?,?,?)',
          [name, email, password, formatDate]);
      if (insertResult.affectedRows == 0) {
        return false;
      }
      var userId = insertResult.insertId;
      var pref = await SharedPreferences.getInstance();
      pref.setString('id', userId.toString());
      pref.setString('Name', name);
      pref.setString('Email', email);

      user.value =
          User(name: name, email: email, id: userId, sinceMember: formatDate);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('err $e');
      }
      return false;
    } finally {
      await connection?.close();
    }
  }

  Future<bool> login(String email, String password) async {
    MySqlConnection? connection;
    try {
      connection = await connectToDatabase();
      var result = await connection.query(
        'select *from users where email = ? and password =?',
        [email, password],
      );
      if (result.isEmpty) {
        showCustsomSnackbar('Incorrect email or Password', title: 'Login');
        return false;
      }
      var userData = result.first;
      var userId = userData['id'] as int;
      var name = userData['Name'];
      var sinceMember = userData['since_member'].toString();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', userId.toString());
      prefs.setString('name', userData['Name']);
      prefs.setString('password', userData['Password']);
      prefs.setString('since_member', sinceMember);

      user.value = User(
        name: name,
        email: email,
        id: userId,
        sinceMember: sinceMember,
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error loggin in $e');
      }
      return false;
    } finally {
      connection?.close();
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    user.value = null;
  }

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    final idString = prefs.getString('id');
    final name = prefs.getString('Name');
    final email = prefs.getString('Email');
    final sinceMember = prefs.getString('since_member') ?? '';

    if (idString != null && name != null && email != null) {
      final id = int.tryParse(idString);
      if (id != null) {
        user.value = User(
          name: name,
          email: email,
          id: id,
          sinceMember: sinceMember,
        );
      }
    }
  }
}

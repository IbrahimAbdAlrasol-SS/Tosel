import 'dart:convert';

import 'package:Tosell/Features/auth/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';

  // static Future<void> saveToken(String token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_tokenKey, token);
  // }

  // static Future<String?> getToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_tokenKey);
  // }

  // static Future<void> clear() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(_tokenKey);
  // }

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson()); // Convert user to JSON
    await prefs.setString(_userKey, userJson);
  }

  static Future<void> updateUser(User newUser) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing user if any
    final existingUser =
        User.fromJson(jsonDecode(prefs.getString(_userKey) ?? '{}'));

    final updatedUser = User(
      id: newUser.id ?? existingUser.id,
      fullName:
          newUser.fullName != null && newUser.fullName != existingUser.fullName
              ? newUser.fullName
              : existingUser.fullName,
      phoneNumber: newUser.phoneNumber != null &&
              newUser.phoneNumber != existingUser.phoneNumber
          ? newUser.phoneNumber
          : existingUser.phoneNumber,
      img: newUser.img ?? existingUser.img,

      userName:
          newUser.userName != null && newUser.userName != existingUser.userName
              ? newUser.userName
              : existingUser.userName,
      token: existingUser.token,

      // Add other fields as needed...
    );

    final updatedJson = jsonEncode(updatedUser.toJson());
    await prefs.setString(_userKey, updatedJson);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}

import 'dart:convert';
import 'package:petvax/app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static saveInt({String key = '', int value = 0}) async {
    // ignore: unused_local_variable
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  static saveString({String key = '', String value = ''}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static saveJson({
    String key = '',
    Map<String, dynamic> value = const {},
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = value.toString(); // Convert map to string
    await prefs.setString(key, jsonString);
  }

  static saveBool({String key = '', bool value = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static getInt({String key = ''}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static getString({String key = ''}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static getBool({String key = ''}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static getJson({String key = ''}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      return jsonString; // Return the string representation of the map
    }
    return {};
  }

  static saveUser({required UserModel user}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(user.toJson()); // Convert map to string
    await prefs.setString('user', jsonString);
  }

  static Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('user');
    if (jsonString != null) {
      return UserModel.fromJson(
        jsonDecode(jsonString),
      ); // Return the string representation of the map
    }
    return null;
  }

  static Future<void> deleteUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}

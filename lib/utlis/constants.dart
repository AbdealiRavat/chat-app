// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static String userName = 'userName';
  static String email = 'email';
  static String bio = 'bio';
  static String profileImg = 'profileImg';
  static String userChats = 'UserChats';
  static String users = 'Users';
  // static String profileImg = 'profileImg';
  // static String profileImg = 'profileImg';

  static var prefs;

  static initializePref() async {
    return prefs = await SharedPreferences.getInstance();
  }
}

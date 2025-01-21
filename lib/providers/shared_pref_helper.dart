// ignore_for_file: constant_identifier_names, camel_case_types
import 'package:shared_preferences/shared_preferences.dart';

import '../core/helpers/shared_pref_constans.dart';
import '../core/helpers/shared_pref_helper.dart';

class SharedPreferenceHelper {
  Future<void> setAuthToken(String token) async {
    return await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
  }

  Future<String?> getAuthToken() async {
    return await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
  }

  // Future<bool> setUserData(String userData) async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.setString(userPref.UserData.toString(), userData);
  // }
  //
  // Future<String?> getUserData() async {
  //   final pref = await SharedPreferences.getInstance();
  //   return pref.getString(userPref.UserData.toString());
  // }

  Future<bool> setUserImage(String image) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(userPref.Image.toString(), image);
  }

  Future<String?> getUserImage() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userPref.Image.toString());
  }
}

enum userPref {
  AuthToken,
  Image,
}

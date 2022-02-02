import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notesapp/Pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;
  static const _keyEmail = 'Email';
  static const _keyPassword = 'Password';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setEmail(String email) async =>
      await _preferences!.setString(_keyEmail, email);

  static String? getEmail() => _preferences!.getString(_keyEmail);

  static Future setPassword(String password) async =>
      await _preferences!.setString(_keyPassword, password);

  static String? getPassword() => _preferences!.getString(_keyPassword);
  static logOut() async {
    _preferences!.clear();
    Get.off(() => LoginPage());
  }
}

class AuthController {
  Future<bool> tryAutoLogin() async {
    String? email = UserSimplePreferences.getEmail();
    // print(email);
    String? password = UserSimplePreferences.getPassword();
    if (email != null && password != null && email != '' && password != '') {
      final UserCredential authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } else {
      return false;
    }
  }
}

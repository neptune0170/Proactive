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
}

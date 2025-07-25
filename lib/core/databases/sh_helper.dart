// lib/core/helpers/shared_prefs_helper.dart

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _ipKey = 'server_ip';

  static Future<String?> getServerIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ipKey);
  }

  static Future<void> setServerIp(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ipKey, ip);
  }
}

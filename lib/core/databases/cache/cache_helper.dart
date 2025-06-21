
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CacheHelper {
 static late SharedPreferences sharedPreferences;
 static late  FlutterSecureStorage _secureStorage;
  static const String _tokenKey = 'auth_token';

//! Here The Initialize of cache .
 static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _secureStorage = FlutterSecureStorage();
  }

//! this method to put data in local database using key

  String? getDataString({
    required String key,
  }) {
    return sharedPreferences.getString(key);
  }

//! this method to put data in local database using key

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    }
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    }

    if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else {
      return await sharedPreferences.setDouble(key, value);
    }
  }
  Future<void> saveTokenSec({ required dynamic value}) async {
      await _secureStorage.write(key: _tokenKey, value: value);

  }
     Future<String?> getTokenSec() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // ✅ دالة لحذف التوكن
   Future<void> deleteTokenSec() async {
    await _secureStorage.delete(key: _tokenKey);
  }
//! this method to get data already saved in local database

  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

//! remove data using specific key

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

//! this method to check if local database contains {key}
  Future<bool> containsKey({required String key}) async {
    return sharedPreferences.containsKey(key);
  }

//! clear all data in the local database
  Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }

//! this method to put data in local database using key
  Future<dynamic> put({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else {
      return await sharedPreferences.setInt(key, value);
    }
  }


}

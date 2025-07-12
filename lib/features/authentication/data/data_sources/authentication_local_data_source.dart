// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/core/databases/cache/cache_helper.dart';
import 'package:social_media_app/features/authentication/data/models/user_model/user_model.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';

/// AuthenticationDataSource is an abstract class defining the contract for fetching
/// data from various sources.
/// This abstract class outlines the methods that concrete data source
/// implementations should implement, such as fetching data from a remote API, local database, or any other data source.
abstract class AuthenticationLocalDataSource {
  Future<void> saveTokenSec(String token);
  Future<void> delTokenSec();
  Future<String?> getTokenSec();
  Future<void> saveData(String data, String key);
  Future<void> delData(String key);
  Future<String?> getData(String key);
  //saceuserdata()
}

/// AuthenticationDataSourceImpl is the concrete implementation of the AuthenticationDataSource
/// interface.
/// This class implements the methods defined in AuthenticationDataSource to fetch
/// data from a remote API or other data sources.
class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  final CacheHelper cache;

  AuthenticationLocalDataSourceImpl({required this.cache});

  @override
  Future<void> delTokenSec() async {
    cache.deleteTokenSec();
    //add some error handling
  }

  @override
  Future<String?> getTokenSec() async {
    return cache.getTokenSec();
  }

  @override
  Future<void> saveTokenSec(String token) async {
    cache.saveTokenSec(value: token);
  }

  @override
  Future<void> delData(String key) async {
    cache.removeData(key: key);
    //add some error handling
  }

  @override
  Future<String?> getData(String key) async {
    return cache.getData(key: key);
  }

  @override
  Future<void> saveData(String data, String key) async {
    cache.saveData(key: key, value: data);
  }
}

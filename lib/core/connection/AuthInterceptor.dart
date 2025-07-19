import 'package:dio/dio.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/features/authentication/data/data_sources/authentication_local_data_source.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final localDataSource = sl<AuthenticationLocalDataSource>();
    final token = await localDataSource.getTokenSec();
    if (token != null && token.isNotEmpty) {
      print(token);
      options.headers['Authorization'] = '$token';
    }

    super.onRequest(options, handler);
  }
}

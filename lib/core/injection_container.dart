import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:social_media_app/core/connection/AuthInterceptor.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/core/databases/api/dio_consumer.dart';
import 'package:social_media_app/core/databases/cache/cache_helper.dart';
import 'package:social_media_app/features/authentication/data/data_sources/authentication_local_data_source.dart';
import 'package:social_media_app/features/authentication/data/data_sources/authentication_remot_data_source.dart';
import 'package:social_media_app/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:social_media_app/features/authentication/domain/usecases/Chose_Preferred_Topics_usecase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/add_profile_image_usecase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/check_auth_status_usecase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/login_usecase.dart.dart';
import 'package:social_media_app/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/register_usecase.dart.dart';
import 'package:social_media_app/features/authentication/domain/usecases/request_resetcode_usecase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/reset_email_usecas.dart';
import 'package:social_media_app/features/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/verify_resetcode_usecase.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  if (!sl.isRegistered<FlutterSecureStorage>()) {
    sl.registerLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage());
  }

  if (!sl.isRegistered<AuthenticationBloc>()) {
    sl.registerFactory(
      () => AuthenticationBloc(
        chosePreferredTopicsUsecase: sl(),
        loginUseCase: sl(),
        registerUseCase: sl(),
        addProfileImageUseCase: sl(),
        logoutUseCase: sl(),
        checkLoginStatusUseCase: sl(),
        requestResetCodeUseCase: sl(),
        verifyResetCodeUseCase: sl(),
        resetPasswordUseCase: sl(),
        resetemailUsecase: sl(),

      ),
    );
  }

  if (!sl.isRegistered<ChosePreferredTopicsUsecase>()) {
    sl.registerLazySingleton(
        () => ChosePreferredTopicsUsecase(repository: sl()));
  }

  if (!sl.isRegistered<LoginUserUseCase>()) {
    sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  }

  if (!sl.isRegistered<RegisterUseCase>()) {
    sl.registerLazySingleton(() => RegisterUseCase(sl()));
  }

  if (!sl.isRegistered<AddProfileImageUsecase>()) {
    sl.registerLazySingleton(() => AddProfileImageUsecase(repository: sl()));
  }

  if (!sl.isRegistered<LogOutUserUseCase>()) {
    sl.registerLazySingleton(() => LogOutUserUseCase(sl()));
  }

  if (!sl.isRegistered<CheckAuthStatusUseCase>()) {
    sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  }

  if (!sl.isRegistered<RequestResetcodeUsecase>()) {
    sl.registerLazySingleton(
        () => RequestResetcodeUsecase(authenticationRepository: sl()));
  }

  if (!sl.isRegistered<VerifyResetCodeUseCase>()) {
    sl.registerLazySingleton(
        () => VerifyResetCodeUseCase(authenticationRepository: sl()));
  }

  if (!sl.isRegistered<ResetpasswordUsecase>()) {
    sl.registerLazySingleton(
        () => ResetpasswordUsecase(authenticationRepository: sl()));
  }
  if (!sl.isRegistered<ResetemailUsecase>()) {
    sl.registerLazySingleton(
        () => ResetemailUsecase(authenticationRepository: sl()));
  }

  if (!sl.isRegistered<AuthenticationRepository>()) {
    sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(local: sl(), remot: sl()),
    );
  }

  if (!sl.isRegistered<AuthenticationLocalDataSource>()) {
    sl.registerLazySingleton<AuthenticationLocalDataSource>(
      () => AuthenticationLocalDataSourceImpl(cache: sl()),
    );
  }

  if (!sl.isRegistered<AuthenticationRemotDataSource>()) {
    sl.registerLazySingleton<AuthenticationRemotDataSource>(
      () => AuthenticationRemotDataSourceImpl(api: sl(), local: sl()),
    );
  }

  if (!sl.isRegistered<ApiConsumer>()) {
    sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl()));
  }

  if (!sl.isRegistered<CacheHelper>()) {
    sl.registerLazySingleton<CacheHelper>(() => CacheHelper());
  }

  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(() {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      dio.interceptors.add(AuthInterceptor());
      return dio;
    });
  }
}

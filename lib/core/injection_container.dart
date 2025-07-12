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
import 'package:social_media_app/features/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/verify_resetcode_usecase.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());

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
        resetPasswordUseCase: sl()),
  );
  sl.registerLazySingleton(() => ChosePreferredTopicsUsecase(repository: sl()));

  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => AddProfileImageUsecase(repository: sl()));
  sl.registerLazySingleton(() => LogOutUserUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(
      () => RequestResetcodeUsecase(authenticationRepository: sl()));
  sl.registerLazySingleton(
      () => VerifyResetCodeUseCase(authenticationRepository: sl()));
  sl.registerLazySingleton(
      () => ResetpasswordUsecase(authenticationRepository: sl()));

  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(local: sl(), remot: sl()),
  );
  sl.registerLazySingleton<AuthenticationLocalDataSource>(
    () => AuthenticationLocalDataSourceImpl(cache: sl()),
  );
  sl.registerLazySingleton<AuthenticationRemotDataSource>(
    () => AuthenticationRemotDataSourceImpl(api: sl(), local: sl()),
  );
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl()));
  sl.registerLazySingleton<CacheHelper>(() => CacheHelper());
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        // validateStatus: (status) => false,
      ),
    );

    dio.interceptors.add(AuthInterceptor());

    return dio;
  });
}

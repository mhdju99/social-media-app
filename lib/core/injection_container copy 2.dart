
import 'package:get_it/get_it.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:social_media_app/features/authentication/domain/usecases/GetUserIdUseCase.dart';

import 'package:social_media_app/features/profile/data/data_sources/profile_data_source.dart';
import 'package:social_media_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:social_media_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:social_media_app/features/profile/domain/usecases/BlockUnblockUsecase.dart';
import 'package:social_media_app/features/profile/domain/usecases/ChangePasswordUsecase.dart';
import 'package:social_media_app/features/profile/domain/usecases/FollowUnfollowUsecase.dart';
import 'package:social_media_app/features/profile/domain/usecases/GetProfilePhotoAndNameUsecase.dart';
import 'package:social_media_app/features/profile/domain/usecases/GetUserProfileUsecase.dart';
import 'package:social_media_app/features/profile/domain/usecases/ModifyProfileUsecase.dart';
import 'package:social_media_app/features/profile/presentation/blocs/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init3() async {

  sl.registerFactory(
    () => ProfileBloc(

    blockUnblockUsecase: sl() ,
    changePasswordUsecase: sl() ,
    followUnfollowUsecase: sl() ,
    getPhotoAndNameUsecase: sl() ,
    getUserProfileUsecase: sl() ,
    modifyProfileUsecase: sl() ,
    getUserIdUseCase: sl() ,
    addProfileImageUsecase: sl()

    ),
  );
  sl.registerLazySingleton(() => BlockUnblockUsecase( sl()));
  sl.registerLazySingleton(() => ChangePasswordUsecase( sl()));
  sl.registerLazySingleton(() => FollowUnfollowUsecase( sl()));
  sl.registerLazySingleton(() => GetProfilePhotoAndNameUsecase( sl()));
  sl.registerLazySingleton(() => GetUserProfileUsecase( sl()));
  sl.registerLazySingleton(() => ModifyProfileUsecase( sl()));


  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl( sl()),
  );
  sl.registerLazySingleton<ProfileDataSource>(
    () => ProfileDataSourceImpl(api: sl<ApiConsumer>()),
  );

  
}

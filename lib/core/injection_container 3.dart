
import 'package:get_it/get_it.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:social_media_app/features/authentication/domain/usecases/GetUserIdUseCase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/check_auth_status_usecase.dart';

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
import 'package:social_media_app/features/realtime/data/data_sources/realtime_data_source.dart';
import 'package:social_media_app/features/realtime/data/repositories/realtime_repository_impl.dart';
import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';
import 'package:social_media_app/features/realtime/domain/usecases/connect_to_socket.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_All_chat_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_chat_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_message_stream.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_user_online_status_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/send_message.dart';
import 'package:social_media_app/features/realtime/domain/usecases/stream_user_offline_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/stream_user_online_usecase.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_bloc.dart';
import 'package:social_media_app/features/search/search_bloc.dart';
import 'package:social_media_app/features/search/search_repository.dart';
import 'package:social_media_app/features/user_tracking/tracker_bloc.dart';
import 'package:social_media_app/features/user_tracking/tracker_repository.dart';

final sl = GetIt.instance;

Future<void> init4() async {

  sl.registerFactory(
    () => ChatBloc(
      connectToSocket: sl() ,
      getMessageStream: sl() ,
      sendMessage: sl() ,
      getChatUseCase: sl() ,
      getUserOnlineStatusUseCase: sl() ,
      getAllChatUsecase: sl() ,
      userOfflineStream: sl() ,
      userOnlineStream: sl() ,
      getUserIdUseCase: sl() ,
      checkLoginStatusUseCase: sl() ,



    ),
  );
  sl.registerLazySingleton(() => ConnectToSocketUseCase( sl()));
  sl.registerLazySingleton(() => GetMessageStreamUseCase( sl()));
  sl.registerLazySingleton(() => SendMessageUseCase( sl()));
  sl.registerLazySingleton(() => GetChatUseCase( sl()));
  sl.registerLazySingleton(() => GetUserOnlineStatusUseCase( sl()));
  sl.registerLazySingleton(() => GetAllChatUsecase( sl()));
  sl.registerLazySingleton(() => StreamUserOnlineUseCase(sl()));
  sl.registerLazySingleton(() => StreamUserOfflineUseCase(sl()));
if (!sl.isRegistered<GetUserIdUseCase>()) {
    sl.registerLazySingleton(() => GetUserIdUseCase(sl()));
  }
  if (!sl.isRegistered<CheckAuthStatusUseCase>()) {
    sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  }



  sl.registerLazySingleton<RealtimeRepository>(
    () => RealtimeRepositoryImpl( sl()),
  );
  sl.registerLazySingleton<RealtimeDataSource>(
    () => RealtimeDataSourceImpl(api: sl<ApiConsumer>()),
  );

    sl.registerFactory(
    () => TrackerBloc(
      repository: sl()
    
    ),
    
  );
  
  sl.registerLazySingleton<TrackerRepository>(
    () => TrackerRepository(api: sl()),
  );
  
  sl.registerFactory(
    () => SearchBloc(sl()),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepository(api: sl()),
  );
}

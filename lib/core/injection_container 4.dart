
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
import 'package:social_media_app/features/realtime/data/data_sources/local_notification_datasource.dart';
import 'package:social_media_app/features/realtime/data/data_sources/realtime_data_source.dart';
import 'package:social_media_app/features/realtime/data/repositories/notification_repository_impl.dart';
import 'package:social_media_app/features/realtime/data/repositories/realtime_repository_impl.dart';
import 'package:social_media_app/features/realtime/domain/repositories/notification_repository.dart';
import 'package:social_media_app/features/realtime/domain/repositories/realtime_repository.dart';
import 'package:social_media_app/features/realtime/domain/usecases/cache_notification.dart';
import 'package:social_media_app/features/realtime/domain/usecases/connect_to_socket.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_All_chat_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_all_notifications.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_chat_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_message_stream.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_notifications_streams.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_user_online_status_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/mark_as_read.dart';
import 'package:social_media_app/features/realtime/domain/usecases/send_message.dart';
import 'package:social_media_app/features/realtime/domain/usecases/stream_user_offline_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/stream_user_online_usecase.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/notification_bloc.dart';

final sl = GetIt.instance;

Future<void> init5() async {

  sl.registerFactory(
    () => NotificationBloc(
     getNotificationsStreamsUseCase:  sl(),
     cacheNotification:  sl(),
     getAll:  sl(),
     markAsRead:  sl(),

    ),
  );
  sl.registerLazySingleton(() => GetNotificationsStreamsUseCase( sl()));
  sl.registerLazySingleton(() => CacheNotificationUseCase( sl()));
  sl.registerLazySingleton(() => GetAllNotificationsUseCase( sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase( sl()));


  // sl.registerLazySingleton<RealtimeRepository>(
  //   () => RealtimeRepositoryImpl( sl()),
  // );
  // sl.registerLazySingleton<RealtimeDataSource>(
  //   () => RealtimeDataSourceImpl(api: sl<ApiConsumer>()),
  // );
  
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<LocalNotificationDataSource>(
    () => LocalNotificationDataSource(),
  );

  
}

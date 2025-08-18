
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:social_media_app/core/connection/AuthInterceptor.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/core/databases/api/dio_consumer.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:social_media_app/features/authentication/domain/usecases/GetUserIdUseCase.dart';
import 'package:social_media_app/features/post/data/data_sources/Post_Remot_DataSource.dart';
import 'package:social_media_app/features/post/data/repositories/post_repository_impl.dart';
import 'package:social_media_app/features/post/domian/repositories/post_repository.dart';
import 'package:social_media_app/features/post/domian/usecases/DeleteComment.dart';
import 'package:social_media_app/features/post/domian/usecases/GetReplies.dart';
import 'package:social_media_app/features/post/domian/usecases/LikeUnlikeComment.dart';
import 'package:social_media_app/features/post/domian/usecases/add_comment.dart';
import 'package:social_media_app/features/post/domian/usecases/create_post.dart';
import 'package:social_media_app/features/post/domian/usecases/delete_post.dart';
import 'package:social_media_app/features/post/domian/usecases/get_post_details.dart';
import 'package:social_media_app/features/post/domian/usecases/get_posts.dart';
import 'package:social_media_app/features/post/domian/usecases/like_unlike_post.dart';
import 'package:social_media_app/features/post/domian/usecases/modify_post.dart';
import 'package:social_media_app/features/post/domian/usecases/updatePostState.dart';
import 'package:social_media_app/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_media_app/features/profile/domain/usecases/GetUserProfileUsecase.dart';

final sl = GetIt.instance;

Future<void> init2() async {

  sl.registerFactory(
    () => PostBloc(

    getPostDetails: sl() ,
    likeUnlikePost: sl() ,
    addComment: sl() ,
    createPost: sl() ,
    getUserIdUseCase: sl() ,
    deleteCommentUseCase: sl(),
    getRepliesUseCase: sl(),
    likeUnlikeCommentUseCase: sl(),
    deletePost: sl(),
modifyPost: sl(),
getPosts:  sl(),
getUserProfileUsecase:  sl(),
updatepoststate: sl()
    ),
  );
  sl.registerLazySingleton(() => GetPostDetails( sl()));
  sl.registerLazySingleton(() => LikeUnlikePost( sl()));
  sl.registerLazySingleton(() => AddComment( sl()));
  sl.registerLazySingleton(() => CreatePost( sl()));
sl.registerLazySingleton<GetUserIdUseCase>(
    () => GetUserIdUseCase(sl<AuthenticationRepository>()),
  );
  sl.registerLazySingleton(() => DeleteComment(sl()));
  sl.registerLazySingleton(() => LikeUnlikeComment(sl()));
  sl.registerLazySingleton(() => GetReplies(sl()));
  sl.registerLazySingleton(() => DeletePost(sl()));
  sl.registerLazySingleton(() => ModifyPost(sl()));
  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton(() => GetUserProfileUsecase(sl()));
  sl.registerLazySingleton(() => Updatepoststate(sl()));

  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl( sl()),
  );
  sl.registerLazySingleton<PostRemotDataSource>(
    () => PostRemotDataSourceImpl(api: sl<ApiConsumer>()),
  );

  
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/core/databases/api/dio_consumer.dart';
import 'package:social_media_app/features/post/data/data_sources/Post_Remot_DataSource.dart';
import 'package:social_media_app/features/post/data/repositories/post_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:social_media_app/features/post/domian/usecases/add_comment.dart';
import 'package:social_media_app/features/post/domian/usecases/create_post.dart';
import 'package:social_media_app/features/post/domian/usecases/delete_post.dart';
import 'package:social_media_app/features/post/domian/usecases/get_post_details.dart';
import 'package:social_media_app/features/post/domian/usecases/like_unlike_post.dart';
import 'package:social_media_app/features/post/domian/usecases/modify_post.dart';

void main() {
  late ModifyPost usecase;
  late PostRepositoryImpl repository;

  setUp(() {
    final dio = Dio();
    dio.options.headers['Authorization'] =
        'BEARER eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2ODU5OWE4ZGIyNWVmNjZjNDIyZGUzOTgiLCJpYXQiOjE3NTA3MDI3MzN9.8kE5m94Ahdb7ecUDzoxCyOHYCvpM-_uotDU9LI8TqF4';
    repository =
        PostRepositoryImpl(PostRemotDataSourceImpl(api: DioConsumer(dio: dio)));
    usecase = ModifyPost(repository);
  });
  test('should add comment on a real post', () async {
    final result = await usecase(postId: "68696da0833b9926d5a1b346"
      ,
    describtion: "tessssssssssst",
    deleteImagesIds: ["68696da0833b9926d5a1b346__0.6928402343196167.jpg"]
    // images: [
    //       File('test/integration/qq.png'),
    //       File('test/integration/qq.png'),
    //       File('test/integration/qq.png'),
    //       File('test/integration/qq.png'),
    //       File('test/integration/qq.png'),
    //     ]
        );

    result.fold(
      (failure) => fail('Failed: ${failure.errMessage}'),
      (post) {
        debugPrint("tttt");
        return expect(true, isTrue);
      },
    );
  });
  // test('should add comment on a real post', () async {
  //   final result = await usecase('68691822f88ddb118b2e8707');

  //   result.fold(
  //     (failure) => fail('Failed: ${failure.errMessage}'),
  //     (post) {
  //       debugPrint(post.toString());
  //       return expect(true, isTrue);
  //     },
  //   );
  // });

  //   test('should add comment on a real post', () async {
  //   final result = await usecase(
  //       describtion: "tessssssssssst",
  //       reelFlag: false,
  //       topic: "Anxiety & Stress Management",
  //       images: [
  //         File('test/integration/qq.png'),
  //       ]);

  //   result.fold(
  //     (failure) => fail('Failed: ${failure.errMessage}'),
  //     (post) {
  //       debugPrint("tttt");
  //       return expect(true, isTrue);
  //     },
  //   );
  // });
}

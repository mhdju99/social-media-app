import 'package:social_media_app/core/databases/sh_helper.dart';

class EndPoints {
  static const String _defaultIp = '192.168.111.132';
  static late String _baseIp;
  static late String baseUrl;
  static late String socketUrl;

  static Future<void> init() async {
    _baseIp = await SharedPrefsHelper.getServerIp() ?? _defaultIp;
    baseUrl = 'http://$_baseIp:3000/api';
    socketUrl = 'http://$_baseIp:3000';
  }

  static String get logInEndPoint => '$baseUrl/users/login';
  static String get registerEndPoint => '$baseUrl/users/create-account';
  static String get requestResetCodeEndPoint => '$baseUrl/users/request-code';
  static String get verifyResetCodeEndPoint => '$baseUrl/users/verify-code';
  static String get changeemailCodeEndPoint => '$baseUrl/users/change-email';
  static String get resetPasswordCodeEndPoint => '$baseUrl/user/reset-password';
  static String get addProfileImageEndPoint => '$baseUrl/users/profile-image';
  static String get modifyProfileEndPoint => '$baseUrl/users/modify-profile';
  static String get getAllChatsEndPoint => '$baseUrl/chats/getAllChats';
  static String get changePasswordEndPoint => '$baseUrl/users/change-password';
  static String get blockUnblockEndPoint => '$baseUrl/users/block-unblock';
  static String get followUnfollowEndPoint => '$baseUrl/users/follow-unfollow';
  static String get getUsersProfileEndPoint =>
      '$baseUrl/users/get-users-profile';
  static String get getNameImageEndPoint => '$baseUrl/users/get-name-image';

  static String get likeCommentEndPoint => '$baseUrl/comments/like-comment';
  static String get deleteCommentEndPoint => '$baseUrl/comments/delete-comment';
  static String get getRepliesEndPoint => '$baseUrl/comments/get-replies';

  static String get getPostEndPoint => '$baseUrl/posts/get-post';
  static String get updatehiddenstatusEndPoint => '$baseUrl/posts/update-hidden-status';
  static String get getPostsEndPoint => '$baseUrl/posts/get-posts';
  static String get createPostEndPoint => '$baseUrl/posts/create-post';
  static String get deletePostEndPoint => '$baseUrl/posts/delete-post';
  static String get likeUnlikePostEndPoint => '$baseUrl/posts/like-unlike-post';
  static String get updatePostEndPoint => '$baseUrl/posts/modify-post';
  static String get addCommentEndPoint => '$baseUrl/comments/create-comment';
  static String get searchusersEndPoint => '$baseUrl/users/search-users';
  static String get recommendEndPoint => 'http://$_baseIp:5000/api/ai/recommend';
  static String get feedbackEndPoint => 'http://$_baseIp:5000/api/ai/feedback';
}

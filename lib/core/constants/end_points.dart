class EndPoints {
  static const String baseUrl = 'http://192.168.250.132:3000/api';
  static const String logInEndPoint = '$baseUrl/users/login';
  static const String registerEndPoint = '$baseUrl/users/create-account';
  static const String RequestResetCodeEndPoint = '$baseUrl/users/request-code';
  static const String verifyResetCodeEndPoint = '$baseUrl/users/verify-code';
  static const String resetPasswordCodeEndPoint =
      '$baseUrl/user/reset-password';
  static const String AddProfileImageEndPoint = '$baseUrl/users/profile-image';

  static const String ModifyProfileEndPoint = '$baseUrl/users/modify-profile';
  static const String changepasswordEndPoint = '$baseUrl/users/change-password';
  static const String blockunblockEndPoint = '$baseUrl/users/block-unblock';
  static const String followunfollowEndPoint = '$baseUrl/users/follow-unfollow';
  static const String getusersprofileEndPoint = '$baseUrl/users/get-users-profile';
  static const String getnameimageEndPoint = '$baseUrl/users/get-name-image';


  static const String getpostEndPoint = '$baseUrl/posts/get-post';
  static const String createpostEndPoint = '$baseUrl/posts/create-post';
  static const String deletepostEndPoint = '$baseUrl/posts/delete-post';
  static const String likeUnlikepostEndPoint =
      '$baseUrl/posts/like-unlike-post';
  static const String updatepostEndPoint = '$baseUrl/posts/modify-post';
  static const String addcommentEndPoint = '$baseUrl/comments/create-comment';
}

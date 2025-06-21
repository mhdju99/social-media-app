class EndPoints {
  static const String baseUrl = 'http://192.168.131.132:3000/api';
  static const String logInEndPoint = '${baseUrl}/users/login';
  static const String registerEndPoint = '${baseUrl}/users/create-account';
  static const String RequestResetCodeEndPoint = '${baseUrl}/users/request-code';
  static const String verifyResetCodeEndPoint = '${baseUrl}/users/verify-code';
  static const String resetPasswordCodeEndPoint = '${baseUrl}/user/reset-password';
}
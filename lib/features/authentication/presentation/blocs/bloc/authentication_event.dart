// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LogInRequested extends AuthenticationEvent {
  LoginParams params;
  LogInRequested({
    required this.params,
  });

  @override
  List<Object> get props => [params];
}

class RegisterRequested extends AuthenticationEvent {
  final RegisterParams params;
  const RegisterRequested({
    required this.params,
  });
  @override
  List<Object> get props => [params];
}

class LogOutRequested extends AuthenticationEvent {}

class UploadProfileImageRequested extends AuthenticationEvent {
  UploadImageParams params;
  UploadProfileImageRequested({
    required this.params,
  });

  @override
  List<Object> get props => [params];
}

class CheckAuthStateRequested extends AuthenticationEvent {}

class RequstResetCodeRequested extends AuthenticationEvent {
  final String email;
  RequstResetCodeRequested({
    required this.email,
  });
  @override
  List<Object> get props => [email];
}

class VerifyResetCodeRequested extends AuthenticationEvent {
  String code;
  VerifyResetCodeRequested({
    required this.code,
  });
 

  @override
  List<Object> get props => [code];
}

class ResetPasswordRequested extends AuthenticationEvent {
  String newPassword;
  ResetPasswordRequested({
    required this.newPassword,
  });

  @override
  List<Object> get props => [ newPassword];
}

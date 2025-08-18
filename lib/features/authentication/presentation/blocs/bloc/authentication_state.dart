// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_bloc.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

class AuthLoading extends AuthenticationState {}
class sendemail extends AuthenticationState {}

class AuthSuccess extends AuthenticationState {
  final UserEntity user;
  const AuthSuccess(this.user);
  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthenticationState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object> get props => [message];
}

class AuthImageUploadSuccess extends AuthenticationState {}

class checkLoginSuccess extends AuthenticationState {
  String token;
  checkLoginSuccess({
  required  this.token,
  });
}

class AuthImageUploadFailure extends AuthenticationState {
  final String message;
  const AuthImageUploadFailure(this.message);
  @override
  List<Object> get props => [message];
}

class AuthCodeRequestedSuccess extends AuthenticationState {
  final String email;
  AuthCodeRequestedSuccess(
    this.email,
  );
  List<Object> get props => [email];
}

class AuthCodeVerifiedSuccess extends AuthenticationState {
 
  List<Object> get props => [];
}

class AuthPasswordResetSuccess extends AuthenticationState {}

class ChosePreferredTopicsSuccess extends AuthenticationState {}

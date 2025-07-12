import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:social_media_app/features/authentication/domain/entities/user_entity/user_entity.dart';
import 'package:social_media_app/features/authentication/domain/params/ResetPassword_params.dart';
import 'package:social_media_app/features/authentication/domain/params/VerifyCode_params.dart';
import 'package:social_media_app/features/authentication/domain/params/login_params.dart';
import 'package:social_media_app/features/authentication/domain/params/register_params.dart';
import 'package:social_media_app/features/authentication/domain/usecases/Chose_Preferred_Topics_usecase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/add_profile_image_usecase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/check_auth_status_usecase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/login_usecase.dart.dart';
import 'package:social_media_app/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/register_usecase.dart.dart';
import 'package:social_media_app/features/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:test/test.dart';

import '../../../domain/usecases/request_resetcode_usecase.dart';
import '../../../domain/usecases/verify_resetcode_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginUserUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AddProfileImageUsecase addProfileImageUseCase;
  final LogOutUserUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkLoginStatusUseCase;
  final RequestResetcodeUsecase requestResetCodeUseCase;
  final VerifyResetCodeUseCase verifyResetCodeUseCase;
  final ResetpasswordUsecase resetPasswordUseCase;
  final ChosePreferredTopicsUsecase chosePreferredTopicsUsecase;
  String _resetToken = "";
  String get resetToken => _resetToken;
  void setResetToken(String token) {
    _resetToken = token;
  }

  void setResetEmail(String email) {
    _resetEmail = email;
  }

  String _resetEmail = "";
  String get resetEmail => _resetEmail;
  AuthenticationBloc({
    required this.loginUseCase,
    required this.chosePreferredTopicsUsecase,
    required this.registerUseCase,
    required this.addProfileImageUseCase,
    required this.logoutUseCase,
    required this.checkLoginStatusUseCase,
    required this.requestResetCodeUseCase,
    required this.verifyResetCodeUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthenticationInitial()) {
    on<LogInRequested>(_handelLogin);
    on<RegisterRequested>(_handleRegister);
    on<UploadProfileImageRequested>(_handleUploadImage);
    on<LogOutRequested>(_handleLogout);
    on<CheckAuthStateRequested>(_handleCheckStatus);
    on<RequstResetCodeRequested>(_handleRequestResetCode);
    on<VerifyResetCodeRequested>(
      _handleVerifyResetCode,
    );
    on<ResetPasswordRequested>(_handleResetPassword);
    on<ChosePreferredTopicsRequested>(_handleChosePreferredTopic);
    // on<toggleRegisterContent>(_handletoggleRegister);
  }

  FutureOr<void> _handleRequestResetCode(
      RequstResetCodeRequested event, emit) async {
    emit(AuthLoading());

    final result = await requestResetCodeUseCase(event.email);

    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (_) => emit(AuthCodeRequestedSuccess(event.email)),
    );
  }

  FutureOr<void> _handleResetPassword(
      ResetPasswordRequested event, emit) async {
    String? token;
    debugPrint("ssssssssss$state");
    if (state is AuthCodeVerifiedSuccess) {
      token = (state as AuthCodeVerifiedSuccess).token;
    }

    if (token == null) {
      emit(const AuthFailure("no token"));
      return;
    }

    emit(AuthLoading());
    final result = await resetPasswordUseCase(
        newPassword: event.newPassword, token: resetToken);
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (_) => emit(AuthPasswordResetSuccess()),
    );
  }

  FutureOr<void> _handleVerifyResetCode(
      VerifyResetCodeRequested event, emit) async {
    // String? email;
    // debugPrint("ssssssssss$state");
    // if (state is AuthCodeRequestedSuccess) {
    //   email = (state as AuthCodeRequestedSuccess).email;
    // }

    // if (email == null) {
    //   emit(const AuthFailure("badddd email"));
    //   return;
    // }

    emit(AuthLoading());

    final result = await verifyResetCodeUseCase(
        code: event.code, email: 'hhhhhmod0@gmail.com');
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (token) {
        return emit(AuthCodeVerifiedSuccess(token: token));
      },
    );
  }

  FutureOr<void> _handelLogin(LogInRequested event, emit) async {
    // AuthenticationRepository repo=AuthenticationRepository();
    emit(AuthLoading());
    final result = await loginUseCase(event.params);
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  FutureOr<void> _handleChosePreferredTopic(
      ChosePreferredTopicsRequested event, emit) async {
    // AuthenticationRepository repo=AuthenticationRepository();
    emit(AuthLoading());
    final result = await chosePreferredTopicsUsecase(event.topic);
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (_) => emit(ChosePreferredTopicsSuccess()),
    );
  }

  Future<void> _handleRegister(RegisterRequested event, emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(event.params);
    result.fold(
      (failure) => emit(AuthFailure(failure.errMessage)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _handleUploadImage(
      UploadProfileImageRequested event, emit) async {
    emit(AuthLoading());
    final result = await addProfileImageUseCase(event.file);
    result.fold(
      (failure) => emit(AuthImageUploadFailure(failure.errMessage)),
      (_) => emit(AuthImageUploadSuccess()),
    );
  }

  Future<void> _handleLogout(LogOutRequested event, emit) async {
    try {
      await logoutUseCase(); // حذف التوكن أو البيانات من التخزين
      emit(AuthenticationInitial()); // إعادة الحالة إلى البداية
    } catch (e) {
      emit(const AuthFailure('حدث خطأ أثناء تسجيل الخروج'));
    }
    ;
  }

  Future<void> _handleCheckStatus(CheckAuthStateRequested event, emit) async {
    final isLoggedIn = await checkLoginStatusUseCase();
    if (isLoggedIn) {
      emit(checkLoginSuccess());
    } else {
      emit(AuthenticationInitial());
    }
  }

  // Future<void> _handletoggleRegister(toggleRegisterContent event, emit) async {
  //   if (state is toggelregister) {
  //     emit(AuthenticationInitial());
  //   }
  //   else if(state is AuthenticationInitial){

  //     emit(toggelregister());

  //   }
  // }
}

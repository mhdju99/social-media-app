import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:social_media_app/features/authentication/domain/usecases/GetUserIdUseCase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/add_profile_image_usecase.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';

import 'package:social_media_app/features/profile/domain/usecases/BlockUnblockUsecase.dart';
import 'package:social_media_app/features/profile/domain/usecases/ChangePasswordUsecase.dart';
import 'package:social_media_app/features/profile/domain/usecases/FollowUnfollowUsecase.dart';
import 'package:social_media_app/features/profile/domain/usecases/GetProfilePhotoAndNameUsecase.dart';
import 'package:social_media_app/features/profile/domain/usecases/GetUserProfileUsecase.dart';
import 'package:social_media_app/features/profile/domain/usecases/ModifyProfileUsecase.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final BlockUnblockUsecase blockUnblockUsecase;
  final ChangePasswordUsecase changePasswordUsecase;
  final FollowUnfollowUsecase followUnfollowUsecase;
  final GetUserProfileUsecase getUserProfileUsecase;
  final GetProfilePhotoAndNameUsecase getPhotoAndNameUsecase;
  final ModifyProfileUsecase modifyProfileUsecase;
  GetUserIdUseCase getUserIdUseCase;
  final AddProfileImageUsecase addProfileImageUsecase;

  ProfileBloc({
    required this.blockUnblockUsecase,
    required this.getUserIdUseCase,
    required this.changePasswordUsecase,
    required this.followUnfollowUsecase,
    required this.getUserProfileUsecase,
    required this.getPhotoAndNameUsecase,
    required this.modifyProfileUsecase,
    required this.addProfileImageUsecase,
  }) : super(ProfileInitial()) {
    on<GetMyProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      final userId = await getUserIdUseCase();
      final result = await getUserProfileUsecase(userId.toString());
      result.fold(
        (failure) => emit(ProfileFailure(failure.errMessage)),
        (userProfile) => emit(ProfileSuccess(userProfile)),
      );
    });
    on<GetUserProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      final userId = await getUserIdUseCase();

      final result = await getUserProfileUsecase(event.userId);
      result.fold(
        (failure) => emit(ProfileFailure(failure.errMessage)),
        (userProfile) {
          debugPrint(userProfile.toString());
          bool isfollow = userProfile.followers.contains(userId);
          debugPrint("isfollow");

          debugPrint(isfollow.toString());

          emit(ProfileSuccess(userProfile.copyWith(isfollow: isfollow)));
        },
      );
    });

    on<GetProfilePhotoAndNameEvent>((event, emit) async {
      emit(ProfileLoading());
      final result = await getPhotoAndNameUsecase(event.userId);
      result.fold(
        (failure) => emit(ProfileFailure(failure.errMessage)),
        (user) => emit(ProfileSuccess(user)),
      );
    });

    on<ModifyProfileEvent>((event, emit) async {
      emit(ProfileLoading());

      if (event.photo != null) {
        final imageResult = await addProfileImageUsecase(event.photo!);
        if (imageResult.isLeft()) {
          return emit(
              ProfileFailure(imageResult.fold((f) => f.errMessage, (_) => '')));
        }
      }

      final result = await modifyProfileUsecase(
        userName: event.userName,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        birthDate: event.birthDate,
        country: event.country,
        city: event.city,
        about: event.about,
        preferredTopics: event.preferredTopics,
      );
      result.fold(
        (failure) => emit(ProfileFailure(failure.errMessage)),
        (_) => emit(ProfileSuccess("تم تعديل الملف الشخصي")),
      );
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(ProfileLoading());
      final result = await changePasswordUsecase(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );
      result.fold(
        (failure) => emit(ProfileFailure(failure.errMessage)),
        (_) {
                        print("☪done");

          emit(changedpassword());
        },
      );
    });

    on<BlockUnblockUserEvent>((event, emit) async {
      final result = await blockUnblockUsecase(event.userId);
      result.fold(
        (failure) => emit(ProfileFailure(failure.errMessage)),
        (_) => null,
      );
    });

    on<FollowUnfollowUserEvent>((event, emit) async {
      final result = await followUnfollowUsecase(event.userId);
      result.fold(
        (failure) => emit(ProfileFailure(failure.errMessage)),
        (_) {
          if (state is ProfileSuccess<UserProfile>) {
            final currentState = state as ProfileSuccess;
            final UserProfile user = currentState.data;
            final updatedUser = user.copyWith(isfollow: !user.isfollow);
            emit(ProfileSuccess(updatedUser));
          }
        },
      );
    });
  }
}

part of 'profile_bloc.dart';
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}
class changedpassword extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String message;
  const ProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileSuccess<T> extends ProfileState {
  final T data;
  const ProfileSuccess(this.data);

  @override
  List<Object?> get props => [data];

  ProfileSuccess copyWith({UserProfile? data}) {
    return ProfileSuccess(data ?? this.data);
  }
}

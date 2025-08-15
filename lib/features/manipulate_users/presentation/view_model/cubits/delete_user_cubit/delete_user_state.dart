part of 'delete_user_cubit.dart';

@immutable
abstract class DeleteUserState extends Equatable {
  const DeleteUserState();

  @override
  List<Object?> get props => [];
}

final class DeleteUserInitial extends DeleteUserState {
  const DeleteUserInitial();
}

final class ValidateTxtFormFieldSuccess extends DeleteUserState {
  const ValidateTxtFormFieldSuccess();
}

final class ValidateTxtFormFieldFailure extends DeleteUserState {
  const ValidateTxtFormFieldFailure();
}

final class DeleteUserSuccess extends DeleteUserState {
  final String? userId;
   DeleteUserSuccess({this.userId}) {
    log("Delete user success $userId ");
  }

  @override
  List<Object?> get props => [userId];
}

final class DeleteUserFailure extends DeleteUserState {
  final String? userId;
   DeleteUserFailure({this.userId}) {
    log("Delete user failure $userId ");
  }

  @override
  List<Object?> get props => [userId];
}

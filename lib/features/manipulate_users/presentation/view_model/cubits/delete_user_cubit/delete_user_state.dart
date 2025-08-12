part of 'delete_user_cubit.dart';

@immutable
sealed class DeleteUserState {}

final class DeleteUserInitial extends DeleteUserState {}

final class ValidateTxtFormFieldSuccess extends DeleteUserState {}

final class ValidateTxtFormFieldFailure extends DeleteUserState {}



final class deleteUserSuccess extends DeleteUserState {
  final String? userId;
  deleteUserSuccess({this.userId}) {
    log("Delete  user success $userId ");
  }
}

final class DeleteUserFailure extends DeleteUserState {
  final String? userId;
  DeleteUserFailure({  this.userId}) {
    log("Delete  user failure $userId ");
  }
}

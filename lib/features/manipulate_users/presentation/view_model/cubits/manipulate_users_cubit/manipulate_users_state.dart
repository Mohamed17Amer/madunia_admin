part of 'manipulate_users_cubit.dart';

@immutable
abstract class ManipulateUsersState extends Equatable {
  const ManipulateUsersState();

  @override
  List<Object?> get props => [];
}

final class ManipulateUsersInitial extends ManipulateUsersState {
  const ManipulateUsersInitial();
}

/// *************************** ADD ********************
final class ValidateTxtFormFieldSuccess extends ManipulateUsersState {
    const ValidateTxtFormFieldSuccess();
}

final class ValidateTxtFormFieldFailure extends ManipulateUsersState {
    const ValidateTxtFormFieldFailure();
}

final class GenerateNewUserUniqueNameSuccess extends ManipulateUsersState {
  final String? uniqueName;
    GenerateNewUserUniqueNameSuccess({this.uniqueName}) {
    log("unique name is $uniqueName");
  }

  @override
  List<Object?> get props => [uniqueName];
}

final class AddNewUserSuccess extends ManipulateUsersState {
  final String? uniqueName;
   AddNewUserSuccess({this.uniqueName}) {
    log("add new user success $uniqueName");
  }

  @override
  List<Object?> get props => [uniqueName];
}

final class AddNewUserFailure extends ManipulateUsersState {
  final String? uniqueName;
   AddNewUserFailure({this.uniqueName}) {
    log("add new user failure $uniqueName");
  }

  @override
  List<Object?> get props => [uniqueName];
}


/// ******************  DELETE **********************************

final class ValidatePaswdFormFieldSuccess extends ManipulateUsersState {
  const ValidatePaswdFormFieldSuccess();
}

final class ValidatePaswdFormFieldFailure extends ManipulateUsersState {
  const ValidatePaswdFormFieldFailure();
}

final class DeleteUserSuccess extends ManipulateUsersState {
  final String? userId;
   DeleteUserSuccess({this.userId}) {
    log("Delete user success $userId ");
  }

  @override
  List<Object?> get props => [userId];
}

final class DeleteUserFailure extends ManipulateUsersState {
  final String? userId;
   DeleteUserFailure({this.userId}) {
    log("Delete user failure $userId ");
  }

  @override
  List<Object?> get props => [userId];
}


part of 'add_user_cubit.dart';

@immutable
sealed class AddUserState {}

final class AddUserInitial extends AddUserState {}

final class ValidateTxtFormFieldSuccess extends AddUserState {}

final class ValidateTxtFormFieldFailure extends AddUserState {}

final class GenerateNewUserUniqueNameSuccess extends AddUserState {
  String? uniqueName;
  GenerateNewUserUniqueNameSuccess({this.uniqueName}) {
    log("unique name is   $uniqueName");
  }
}

final class AddNewUserSuccess extends AddUserState {
  final String? uniqueName;
  AddNewUserSuccess({this.uniqueName}) {
    log("add new user success $uniqueName ");
  }
}

final class AddNewUserFailure extends AddUserState {
  final String? uniqueName;
  AddNewUserFailure({this.uniqueName}) {
    log("add new user failure $uniqueName ");
  }
}

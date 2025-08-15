part of 'add_user_cubit.dart';

@immutable
abstract class AddUserState extends Equatable {
    AddUserState();

  @override
  List<Object?> get props => [];
}

final class AddUserInitial extends AddUserState {
    AddUserInitial();
}

final class ValidateTxtFormFieldSuccess extends AddUserState {
    ValidateTxtFormFieldSuccess();
}

final class ValidateTxtFormFieldFailure extends AddUserState {
    ValidateTxtFormFieldFailure();
}

final class GenerateNewUserUniqueNameSuccess extends AddUserState {
  final String? uniqueName;
    GenerateNewUserUniqueNameSuccess({this.uniqueName}) {
    log("unique name is $uniqueName");
  }

  @override
  List<Object?> get props => [uniqueName];
}

final class AddNewUserSuccess extends AddUserState {
  final String? uniqueName;
   AddNewUserSuccess({this.uniqueName}) {
    log("add new user success $uniqueName");
  }

  @override
  List<Object?> get props => [uniqueName];
}

final class AddNewUserFailure extends AddUserState {
  final String? uniqueName;
   AddNewUserFailure({this.uniqueName}) {
    log("add new user failure $uniqueName");
  }

  @override
  List<Object?> get props => [uniqueName];
}

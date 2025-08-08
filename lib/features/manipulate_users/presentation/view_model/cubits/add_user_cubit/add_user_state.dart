part of 'add_user_cubit.dart';

@immutable
sealed class AddUserState {}

final class AddUserInitial extends AddUserState {}



final class ValidateTxtFormFieldSuccess extends AddUserState {}
final class ValidateTxtFormFieldFailure extends AddUserState {}

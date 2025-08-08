part of 'all_users_cubit.dart';

@immutable
sealed class AllUsersState {}

final class AllUsersInitial extends AllUsersState {}

final class ValidateTxtFormFieldSuccess extends AllUsersState {}
final class ValidateTxtFormFieldFailure extends AllUsersState {}


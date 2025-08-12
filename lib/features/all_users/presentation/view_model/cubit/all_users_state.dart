part of 'all_users_cubit.dart';

@immutable
sealed class AllUsersState {}

final class AllUsersInitial extends AllUsersState {}

final class GetAllUsersSuccess extends AllUsersState {
  final List<AppUser> users;
  GetAllUsersSuccess({required this.users}) {
    log("get all users success $users");
  }
}

final class GetAllUsersFailure extends AllUsersState {
  final String errmesg;
  GetAllUsersFailure({required this.errmesg}) {
    log("get all users failure $errmesg");
  }
}

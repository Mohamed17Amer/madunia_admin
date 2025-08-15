part of 'all_users_cubit.dart';

@immutable
abstract class AllUsersState extends Equatable {
  const AllUsersState();

  @override
  List<Object?> get props => [];
}

final class AllUsersInitial extends AllUsersState {
  const AllUsersInitial();
}

final class GetAllUsersSuccess extends AllUsersState {
  final List<AppUser> users;
   GetAllUsersSuccess({required this.users}) {
    log("get all users success $users");
  }

  @override
  List<Object?> get props => [users];
}

final class GetAllUsersFailure extends AllUsersState {
  final String errmesg;
   GetAllUsersFailure({required this.errmesg}) {
    log("get all users failure $errmesg");
  }

  @override
  List<Object?> get props => [errmesg];
}

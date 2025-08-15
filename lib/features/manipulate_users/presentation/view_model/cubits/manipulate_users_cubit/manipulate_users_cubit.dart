import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'manipulate_users_state.dart';

class ManipulateUsersCubit extends Cubit<ManipulateUsersState> {
  ManipulateUsersCubit() : super(ManipulateUsersInitial());

 
}

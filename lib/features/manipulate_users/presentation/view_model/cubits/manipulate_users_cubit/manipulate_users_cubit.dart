import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';

part 'manipulate_users_state.dart';

class ManipulateUsersCubit extends Cubit<ManipulateUsersState> {
  ManipulateUsersCubit() : super(ManipulateUsersInitial());

  void navigateTo({required BuildContext context, required String path}) {
    navigateToWithGoRouter(context: context, path: path);
  }
}

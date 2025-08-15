import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';
import 'package:madunia_admin/core/utils/events/event_bus.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';

part 'all_users_state.dart';

class AllUsersCubit extends Cubit<AllUsersState> {
  AllUsersCubit() : super(AllUsersInitial()){
        eventBus.on<AddNewUserEvent>().listen((event) => getAllUsers());
        eventBus.on<DeleteUserEvent>().listen((event) => getAllUsers());

  }

  // edit text controllers
  final TextEditingController repairNameController = TextEditingController();
  final TextEditingController repairDescriptionController =
      TextEditingController();

  // form key
  final GlobalKey<FormState> repairScreenKey = GlobalKey<FormState>();

  // firestore instance
  FirestoreService firestoreService = FirestoreService();

  /// ********************************* functions ***************************

 Future<void> getAllUsers() async {
  // Check if cubit is closed
  if (isClosed) return;
    
  try {
    final users = await firestoreService.getAllUsers();
    
    // Check again before emitting
    if (!isClosed) {
      emit(GetAllUsersSuccess(users: users));
    }
  } catch (e) {
    if (!isClosed) {
      emit(GetAllUsersFailure(errmesg: e.toString()));
    }
  }
}

  void navigateTo({
    required BuildContext context,
    required String path,
    AppUser? extra,
  }) {
    navigateToWithGoRouter(context: context, path: path, extra: extra);
  }
}

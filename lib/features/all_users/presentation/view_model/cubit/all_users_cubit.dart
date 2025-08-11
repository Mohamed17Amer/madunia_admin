import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';

part 'all_users_state.dart';

class AllUsersCubit extends Cubit<AllUsersState> {
  AllUsersCubit() : super(AllUsersInitial());

  final TextEditingController repairNameController = TextEditingController();
  final TextEditingController repairDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> repairScreenKey = GlobalKey<FormState>();

  FirestoreService firestoreService = FirestoreService();

  bool checkRequestValidation() {
    if (repairScreenKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void sendRepairReuest({BuildContext? context}) {
    if (checkRequestValidation()) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('تم إرسال طلب الصيانة بنجاح')),
      );
    }
  }

  String? validateTxtFormField({
    required String? value,
    required String? errorHint,
  }) {
    if (value == null || value.isEmpty) {
      emit(ValidateTxtFormFieldSuccess());

      return errorHint!;
    }
    emit(ValidateTxtFormFieldFailure());

    return null;
  }

  getAllUsers() async {
    try {
      final users = await firestoreService. getAllUsers();
      emit(GetAllUsersSuccess(users: users));
      return users;
    } on Exception catch (e) {
      emit(GetAllUsersFailure(errmesg: e.toString()));
      return Stream.error(e);
    }
    
  }


   void navigateTo({required BuildContext context, required String path, AppUser? extra}) {
    navigateToWithGoRouter(context: context, path: path, extra: extra);
  }
}

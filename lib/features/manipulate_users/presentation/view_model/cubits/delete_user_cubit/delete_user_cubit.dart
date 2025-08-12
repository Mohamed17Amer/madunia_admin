import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';

part 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  DeleteUserCubit() : super(DeleteUserInitial());

  final TextEditingController userIdController = TextEditingController();
  final GlobalKey<FormState> deleteUserScreenKey = GlobalKey<FormState>();

  FirestoreService firestoreService = FirestoreService();

  bool checkRequestValidation() {
    if (deleteUserScreenKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  deleteUser({BuildContext? context, String? id}) {
    late String userId;
    if (id != null) {
      userId = id;
      firestoreService.deleteUser(userId);

      ScaffoldMessenger.of(
        context!,
      ).showSnackBar(const SnackBar(content: Text('تمت   حذف العضو بنجاح')));

      emit(deleteUserSuccess(userId: userId));
    } else {
      userId = userIdController.text;

      if (checkRequestValidation()) {
        firestoreService.deleteUser(userId);

        ScaffoldMessenger.of(
          context!,
        ).showSnackBar(const SnackBar(content: Text('تمت   حذف العضو بنجاح')));

        emit(deleteUserSuccess(userId: userId));
      } else {
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(
            content: Text(" الخاص بهذا العضو ID  من فضلك أدخل ال "),
          ),
        );
        emit(DeleteUserFailure(userId: userId));
      }
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

  resetSettings() {
    userIdController.text = "";
  }
}

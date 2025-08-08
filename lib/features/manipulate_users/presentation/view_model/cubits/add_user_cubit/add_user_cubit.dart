import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';

part 'add_user_state.dart';

class AddUserCubit extends Cubit<AddUserState> {
  AddUserCubit() : super(AddUserInitial());

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();

  final GlobalKey<FormState> addUserScreenKey = GlobalKey<FormState>();

  String uniqueName = "";
  bool isUniqueNameGenerated = false;

  bool checkRequestValidation() {
    if (addUserScreenKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void addNewUser({BuildContext? context}) {
    if (checkRequestValidation()) {
      ScaffoldMessenger.of(
        context!,
      ).showSnackBar(const SnackBar(content: Text('تمت إضافة العضو الجديد')));
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

  void generateNewUserUniqueName({required BuildContext context}) {
    if (checkRequestValidation()) {
      isUniqueNameGenerated = false;
      final uniqueCode = generateCode(
        length: 3,
        existingCodes: existingCodes,
        name: userNameController.text,
      );

      isUniqueNameGenerated = true;
      uniqueName = userNameController.text + uniqueCode;

      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('تم إنشاء الاسم المميز للعضو الجديد')),
      );
      emit(GenerateNewUserUniqueNameSuccess(uniqueName: uniqueName));
    }
  }
}

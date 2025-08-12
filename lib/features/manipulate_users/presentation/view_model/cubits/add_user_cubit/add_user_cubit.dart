import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';

part 'add_user_state.dart';

class AddUserCubit extends Cubit<AddUserState> {
  AddUserCubit() : super(AddUserInitial());

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();
  final GlobalKey<FormState> addUserScreenKey = GlobalKey<FormState>();

  String uniqueName = "";
  bool isUniqueNameGenerated = false;

  FirestoreService firestoreService = FirestoreService();

  String? validateTxtFormField({
    required String? value,
    required String? errorHint,
  }) {
    if (value == null || value.isEmpty) {
      emit(ValidateTxtFormFieldFailure());

      return errorHint!;
    }
    emit(ValidateTxtFormFieldSuccess());

    return null;
  }

  bool checkRequestValidation() {
    if (addUserScreenKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
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
      uniqueName = "${userNameController.text}_$uniqueCode";

      showToastification(
        context: context,
        message: " تم إنشاء الاسم المميز للعضو الجديد",
      );

      emit(GenerateNewUserUniqueNameSuccess(uniqueName: uniqueName));
    }
  }

  resetSettings() {
    isUniqueNameGenerated = false;
    uniqueName = "";
    userNameController.text = "";
    userPhoneController.text = "";
  }

  addNewUser({BuildContext? context}) {
    if (checkRequestValidation() && isUniqueNameGenerated) {
      firestoreService
          .createUser(
            phoneNumber: userPhoneController.text,
            uniqueName: uniqueName,
          )
          .then((value) {});

      ScaffoldMessenger.of(
        context!,
      ).showSnackBar(const SnackBar(content: Text('تمت إضافة العضو الجديد')));

      emit(AddNewUserSuccess(uniqueName: uniqueName));
    } else {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('من فضلك، قم بإنشاء الاسم المميز')),
      );
    }
    emit(AddNewUserFailure(uniqueName: uniqueName));
  }
}

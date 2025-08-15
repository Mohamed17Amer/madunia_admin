import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';

part 'manipulate_users_state.dart';

class ManipulateUsersCubit extends Cubit<ManipulateUsersState> {
  ManipulateUsersCubit() : super(ManipulateUsersInitial());

  /// *************************** ADD ********************
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();
  final GlobalKey<FormState> addUserScreenKey = GlobalKey<FormState>();

  final TextEditingController userIdController = TextEditingController();
  final GlobalKey<FormState> deleteUserScreenKey = GlobalKey<FormState>();

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

  bool checkRequestValidation({required GlobalKey<FormState> formKey}) {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void generateNewUserUniqueName({required BuildContext context}) {
    if (checkRequestValidation(formKey: addUserScreenKey)) {
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

  resetSettings({required GlobalKey<FormState> formKey}) {

    if(formKey == addUserScreenKey){
    isUniqueNameGenerated = false;
    uniqueName = "";
    userNameController.text = "";
    userPhoneController.text = "";
    }
    else {
    userIdController.text = "";
  }
  }

  addNewUser({BuildContext? context}) {
    if (checkRequestValidation(formKey: addUserScreenKey) &&
        isUniqueNameGenerated) {
      firestoreService
          .createUser(
            phoneNumber: userPhoneController.text,
            uniqueName: uniqueName,
          )
          .then((value) {});
          resetSettings(formKey: addUserScreenKey);

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
    /// ************** DELETE **********************

    deleteUser({BuildContext? context, String? id}) {
      late String userId;
      if (id != null) {
        userId = id;
        firestoreService.deleteUser(userId);

        ScaffoldMessenger.of(
          context!,
        ).showSnackBar(const SnackBar(content: Text('تمت   حذف العضو بنجاح')));

        emit(DeleteUserSuccess(userId: userId));
      } else {
        userId = userIdController.text;

        if (checkRequestValidation(formKey: deleteUserScreenKey)) {
          firestoreService.deleteUser(userId);

          resetSettings(formKey: deleteUserScreenKey);

          ScaffoldMessenger.of(context!).showSnackBar(
            const SnackBar(content: Text('تمت   حذف العضو بنجاح')),
          );

          emit(DeleteUserSuccess(userId: userId));
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

    String? validatePaswdFormField({
      required String? value,
      required String? errorHint,
    }) {
      if (value == null || value.isEmpty) {
        emit(ValidatePaswdFormFieldSuccess());

        return errorHint!;
      }
      emit(ValidatePaswdFormFieldFailure());

      return null;
    }

    navigateToFirstRouteInStack({required BuildContext context}) {
      navigateToFirstRouteInStack(context: context);
    }
  }

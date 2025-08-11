import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';
import 'package:madunia_admin/core/utils/router/app_screens.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';

part 'add_debit_item_state.dart';

class AddDebitItemCubit extends Cubit<AddDebitItemState> {
  AddDebitItemCubit() : super(AddDebitItemInitial());

  final TextEditingController debitItemNameController = TextEditingController();
  final TextEditingController debitItemValueController =
      TextEditingController();

  final GlobalKey<FormState> addDebitItemScreenKey = GlobalKey<FormState>();

  FirestoreService firestoreService = FirestoreService();

  bool checkRequestValidation() {
    if (addDebitItemScreenKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void addNewDebitItem({
    required BuildContext context,
    required AppUser user,
  }) async {
    if (checkRequestValidation()) {
      try {
        final debitItem = await firestoreService.addDebitItem(
          recordName: debitItemNameController.text,
          recordMoneyValue: double.parse(debitItemValueController.text),
          status: "pending",

          userId: user.id,
        );

        emit(AddNewDebitItemSuccess(debitItem: debitItem));

        showToastification(
          context: context,
          message: 'تمت إضافة العنصر إلى المديونية',
        );

        navigateReplacementWithGoRouter(
          context: context,
          path: AppScreens.debitScreen,
          extra: user,
        );
        // Then navigate back
      } catch (e) {
        Navigator.of(context).pop(false); // Return true to indicate success
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
}

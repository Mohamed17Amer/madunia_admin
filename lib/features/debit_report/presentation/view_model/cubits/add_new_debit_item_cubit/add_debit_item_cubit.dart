import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'add_debit_item_state.dart';

class AddDebitItemCubit extends Cubit<AddDebitItemState> {
  AddDebitItemCubit() : super(AddDebitItemInitial());

  final TextEditingController debitItemNameController = TextEditingController();
  final TextEditingController debitItemValueController =
      TextEditingController();

  final GlobalKey<FormState> addDebitItemScreenKey = GlobalKey<FormState>();

  bool checkRequestValidation() {
    if (addDebitItemScreenKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void addNewDebitItem({BuildContext? context}) {
    if (checkRequestValidation()) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('تمت إضافة العنصر إلى المديونية')),
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
}

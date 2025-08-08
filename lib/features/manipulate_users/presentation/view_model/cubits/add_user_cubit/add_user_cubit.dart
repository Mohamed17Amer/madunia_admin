import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'add_user_state.dart';

class AddUserCubit extends Cubit<AddUserState> {
  AddUserCubit() : super(AddUserInitial());

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPhoneController =
      TextEditingController();

  final GlobalKey<FormState> addUserScreenKey = GlobalKey<FormState>();

  bool checkRequestValidation() {
    if (addUserScreenKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void addNewUser({BuildContext? context}) {
    if (checkRequestValidation()) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text('تمت إضافة العضو الجديد')),
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

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'all_users_state.dart';

class AllUsersCubit extends Cubit<AllUsersState> {
  AllUsersCubit() : super(AllUsersInitial());

  final TextEditingController repairNameController = TextEditingController();
  final TextEditingController repairDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> repairScreenKey = GlobalKey<FormState>();

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
}

import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';
import 'package:madunia_admin/core/utils/events/event_bus.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/debit_report/data/models/debit_item_model.dart';

part 'debit_report_state.dart';

class DebitReportCubit extends Cubit<DebitReportState> {
  DebitReportCubit() : super(DebitReportInitial());

  FirestoreService firestoreService = FirestoreService();

  ///******************************* GET ******************************************** */

  Future getAllDebitItems({required String userId}) async {
    try {
      final allUserItemDebits = await firestoreService.getDebitItems(userId);
      emit(GetAllDebitItemsSuccess(allUserItemDebits: allUserItemDebits));
      log("all debits$allUserItemDebits");
      log("id  $userId");
      return allUserItemDebits;
    } catch (e) {
      emit(GetAllDebitItemsFailure(errmesg: e.toString()));
    }
  }

  ///****************************** Delete ******************************************** */

  Future<void> deleteDebitItem({
    required BuildContext context,
    required String debitItemId,
    required String userId,
  }) async {
    try {
      await firestoreService.deleteDebitItem(userId, debitItemId);
      showToastification(context: context, message: "تم حذف العنصر");
      emit(DeleteDebitItemSuccess(debitItemId: debitItemId));
      eventBus.fire(UserDataUpdatedEvent(userId));
    } catch (e) {
      showToastification(context: context, message: "لم يتم حذف العنصر");
      emit(DeleteDebitItemFailure(errmesg: e.toString()));
    }
  }

  ///************************************ VALIDATION **********************************

  final TextEditingController debitItemNameController = TextEditingController();
  final TextEditingController debitItemValueController =
      TextEditingController();
  final GlobalKey<FormState> addDebitItemScreenKey = GlobalKey<FormState>();

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
    if (addDebitItemScreenKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  /// ******************************** ADD **********************************************

  Future<void> addNewDebitItem({
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

        eventBus.fire(UserDataUpdatedEvent(user.id));

        showToastification(
          context: context,
          message: 'تمت إضافة العنصر إلى المديونية',
        );
      } catch (e) {
        emit(AddNewDebitItemFailure(errmesg: e.toString()));
        showToastification(
          context: context,
          message: 'فشل في إضافة العنصر إلى المديونية',
        );
      }
    }
  }

  ///************************************* HELPERS **************************************** */

  sendAlarmToUser({
    required BuildContext context,
    required String debitItemId,
    required String userId,
  }) {
    showToastification(context: context, message: "تم إرسال تنبيه للدفع");

    // emit(SendAlarmToUserSuccess());
  }

  @override
  Future<void> close() {
    log('', error: 'Debit Report Cubit is Closed');
    return super.close();
  }
}

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';
import 'package:madunia_admin/features/debit_report/data/models/debit_item_model.dart';

part 'debit_report_state.dart';

class DebitReportCubit extends Cubit<DebitReportState> {
  DebitReportCubit() : super(DebitReportInitial());

  FirestoreService firestoreService = FirestoreService();

 
  getAllDebitItems({required String userId}) async {
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

Future<void> deleteDebitItem({
  required BuildContext context,
  required String debitItemId,
  required String userId,
}) async {
  try {
    await firestoreService.deleteDebitItem(userId,debitItemId);
    showToastification(context: context, message: "تم حذف العنصر");
    emit(DeleteDebitItemSuccess(debitItemId: debitItemId));
  } catch (e) {
    showToastification(context: context, message: "لم يتم حذف العنصر");
    emit(DeleteDebitItemFailure(errmesg: e.toString()));
  }
}
  sendAlarmToUser({
    required BuildContext context,
    required String debitItemId,
    required String userId,
  }) {
    showToastification(context: context, message: "تم إرسال تنبيه للدفع");

    // emit(SendAlarmToUserSuccess());
  }

   navigateTo({
    required BuildContext context,
    required String path,
    dynamic extra,
  }) {
    navigateReplacementWithGoRouter(context: context, path: path, extra: extra);
  }

}

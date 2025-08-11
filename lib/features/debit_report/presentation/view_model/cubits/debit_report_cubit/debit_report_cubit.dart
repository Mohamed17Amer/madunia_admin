
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';

part 'debit_report_state.dart';

class DebitReportCubit extends Cubit<DebitReportState> {
  DebitReportCubit() : super(DebitReportInitial());

  FirestoreService firestoreService = FirestoreService();

   sendAlarmToUser({required BuildContext context}) {
    showToastification(context: context, message: "تم إرسال تنبيه للدفع");

   // emit(SendAlarmToUserSuccess());
  }

   navigateTo({
    required BuildContext context,
    required String path,
    dynamic extra,
  }) {
    navigateToWithGoRouter(context: context, path: path, extra: extra);
  }

  getAllDebitItems({required String userId}) async{
    try {
      final allUserItemDebits =await firestoreService.getDebitItems(userId);
      emit(GetAllDebitItemsSuccess(allUserItemDebits: allUserItemDebits));
      log("all debits$allUserItemDebits");
      log("idddddddddddvvv   $userId");
      return allUserItemDebits;
    } catch (e) {
      emit(GetAllDebitItemsFailure(errmesg: e.toString()));
    }
  }
}

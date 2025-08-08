import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';

part 'debit_report_state.dart';

class DebitReportCubit extends Cubit<DebitReportState> {
  DebitReportCubit() : super(DebitReportInitial());

  void sendAlarmToUser({required BuildContext context}) {
    showToastification(context: context, message: "تم إرسال تنبيه للدفع");

    emit(SendAlarmToUserSuccess());
  }

  void navigateTo({required BuildContext context, required String path}) {
    navigateToWithGoRouter(context: context, path: path);
  }
}

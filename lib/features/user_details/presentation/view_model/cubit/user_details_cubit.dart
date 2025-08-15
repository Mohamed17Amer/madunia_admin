import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(UserDetailsInitial());

  FirestoreService firestoreService = FirestoreService();

  final userPaymentDetailsCategoriess = ["عليه", "له"];

  final userOtherDrtailsCategoriess = ["البلاغات"];

  getTotalMoney({required String userId}) async {
    final List<double> total = [0, 0];
    total[0] = await firestoreService.getTotalDebitMoney(userId);
    total[1] = await firestoreService.getTotalOwnedMoney(userId);
    emit(GetTotalMoneySuccess(total: total));
    log(total.toString());
    return total;
  }

  void copyUserNameToClipboard(String userUniqueName) {
    copyToClipboard(text: userUniqueName);
    // emit(CopyTotalToClipboardSuccess(total));
  }

  void copyUserIdToClipboard(String userId) {
    copyToClipboard(text: userId);
    // emit(CopyTotalToClipboardSuccess(total));
  }

  void copyTotalToClipboard(String total) {
    copyToClipboard(text: total);
    // emit(CopyTotalToClipboardSuccess(total));
  }

  void copyUserPhoneToClipboard(String userPhone) {
    copyToClipboard(text: userPhone);
  }

  void navigateTo({
    required BuildContext context,
    required String path,
    required dynamic extra,
  }) {
    navigateToWithGoRouter(context: context, path: path, extra: extra);
  }
}

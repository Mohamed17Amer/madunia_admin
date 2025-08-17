import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';
import 'package:madunia_admin/core/utils/events/event_bus.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/owned_report/data/models/owned_item_model.dart';

part 'owned_report_state.dart';

class OwnedReportCubit extends Cubit<OwnedReportState> {
  OwnedReportCubit() : super(OwnedReportInitial());

  FirestoreService firestoreService = FirestoreService();

  ///******************************* GET ******************************************** */

  Future getAllOwnedItems({required String userId}) async {
    try {
      final allUserItemOwneds = await firestoreService.getOwnedItems(userId);
      emit(GetAllOwnedItemsSuccess( allUserItemOwneds: allUserItemOwneds));
      log("all debits$allUserItemOwneds");
      log("id  $userId");
      return allUserItemOwneds;
    } catch (e) {
      emit(GetAllOwnedItemsFailure(errmesg: e.toString()));
    }
  }

  ///****************************** Delete ******************************************** */

  Future<void> deleteOwnedItem({
    required BuildContext context,
    required String ownedItemId,
    required String userId,
  }) async {
    try {
      await firestoreService.deleteOwnedItem(userId, ownedItemId);
      showToastification(context: context, message: "تم حذف العنصر");
      emit(DeleteOwnedItemSuccess(   ownedItemId: ownedItemId));
      eventBus.fire(UserDataUpdatedEvent(userId));
    } catch (e) {
      showToastification(context: context, message: "لم يتم حذف العنصر");
      emit(DeleteOwnedItemFailure(errmesg: e.toString()));
    }
  }

  ///************************************ VALIDATION **********************************

  final TextEditingController ownedItemNameController = TextEditingController();
  final TextEditingController ownedItemValueController =
      TextEditingController();
  final GlobalKey<FormState> addOwnedItemScreenKey = GlobalKey<FormState>();

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
    if (addOwnedItemScreenKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  /// ******************************** ADD **********************************************

  Future<void> addNewOwnedItem({
    required BuildContext context,
    required AppUser user,
  }) async {
    if (checkRequestValidation()) {
      try {
        final ownedItem = await firestoreService.addOwnedItem(
          recordName: ownedItemNameController.text,
          recordMoneyValue: double.parse(ownedItemValueController.text),
          status: "pending",

          userId: user.id,
        );

        emit(AddNewOwnedItemSuccess(ownedItem: ownedItem));

        eventBus.fire(UserDataUpdatedEvent(user.id));

        showToastification(
          context: context,
          message: 'تمت إضافة العنصر إلى المديونية',
        );
      } catch (e) {
        emit(AddNewOwnedItemFailure(errmesg: e.toString()));
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
    required String ownedItemId,
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

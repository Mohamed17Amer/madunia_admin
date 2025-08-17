part of 'owned_report_cubit.dart';

@immutable
///**************** INITIALS ************************ */
abstract class OwnedReportState extends Equatable {
  const OwnedReportState();

  @override
  List<Object?> get props => [];
}

final class OwnedReportInitial extends OwnedReportState {
  const OwnedReportInitial();
}

///************************ GET *************************** */
final class GetAllOwnedItemsSuccess extends OwnedReportState {
  final List<OwnedItem> allUserItemOwneds;
  GetAllOwnedItemsSuccess({required this.allUserItemOwneds}) {
    log("owneds$allUserItemOwneds");
  }

  @override
  List<Object?> get props => [allUserItemOwneds];
}

final class GetAllOwnedItemsFailure extends OwnedReportState {
  final String errmesg;
  const GetAllOwnedItemsFailure({required this.errmesg});

  @override
  List<Object?> get props => [errmesg];
}

///********************** DELETE ********************************* */
final class DeleteOwnedItemSuccess extends OwnedReportState {
  final String ownedItemId;
  const DeleteOwnedItemSuccess({required this.ownedItemId});

  @override
  List<Object?> get props => [ownedItemId];
}

final class DeleteOwnedItemFailure extends OwnedReportState {
  final String errmesg;
  const DeleteOwnedItemFailure({required this.errmesg});

  @override
  List<Object?> get props => [errmesg];
}

///****************** VALIDATION ********************** */

final class ValidateTxtFormFieldSuccess extends OwnedReportState {
  const ValidateTxtFormFieldSuccess();
}

final class ValidateTxtFormFieldFailure extends OwnedReportState {
  const ValidateTxtFormFieldFailure();
}

///****************** ADD ********************** */

final class AddNewOwnedItemSuccess extends OwnedReportState {
  final dynamic ownedItem; // type left dynamic because original was untyped
  AddNewOwnedItemSuccess({this.ownedItem}) {
    log("new owned item added $ownedItem");
  }

  @override
  List<Object?> get props => [ownedItem];
}

final class AddNewOwnedItemLoading extends OwnedReportState {
  const AddNewOwnedItemLoading();
}

final class AddNewOwnedItemFailure extends OwnedReportState {
  final String errmesg;
  const AddNewOwnedItemFailure({required this.errmesg});

  @override
  List<Object?> get props => [errmesg];
}

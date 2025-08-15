part of 'debit_report_cubit.dart';

@immutable
///**************** INITIALS ************************ */
abstract class DebitReportState extends Equatable {
  const DebitReportState();

  @override
  List<Object?> get props => [];
}

final class DebitReportInitial extends DebitReportState {
  const DebitReportInitial();
}

///************************ GET *************************** */
final class GetAllDebitItemsSuccess extends DebitReportState {
  final List<DebitItem> allUserItemDebits;
  GetAllDebitItemsSuccess({required this.allUserItemDebits}) {
    debugPrint("debits$allUserItemDebits");
  }

  @override
  List<Object?> get props => [allUserItemDebits];
}

final class GetAllDebitItemsFailure extends DebitReportState {
  final String errmesg;
  const GetAllDebitItemsFailure({required this.errmesg});

  @override
  List<Object?> get props => [errmesg];
}

///********************** DELETE ********************************* */
final class DeleteDebitItemSuccess extends DebitReportState {
  final String debitItemId;
  const DeleteDebitItemSuccess({required this.debitItemId});

  @override
  List<Object?> get props => [debitItemId];
}

final class DeleteDebitItemFailure extends DebitReportState {
  final String errmesg;
  const DeleteDebitItemFailure({required this.errmesg});

  @override
  List<Object?> get props => [errmesg];
}

///****************** VALIDATION ********************** */

final class ValidateTxtFormFieldSuccess extends DebitReportState {
  const ValidateTxtFormFieldSuccess();
}

final class ValidateTxtFormFieldFailure extends DebitReportState {
  const ValidateTxtFormFieldFailure();
}

///****************** ADD ********************** */

final class AddNewDebitItemSuccess extends DebitReportState {
  final dynamic debitItem; // type left dynamic because original was untyped
  AddNewDebitItemSuccess({this.debitItem}) {
    log("new debit item added $debitItem");
  }

  @override
  List<Object?> get props => [debitItem];
}

final class AddNewDebitItemLoading extends DebitReportState {
  const AddNewDebitItemLoading();
}

final class AddNewDebitItemFailure extends DebitReportState {
  final String errmesg;
  const AddNewDebitItemFailure({required this.errmesg});

  @override
  List<Object?> get props => [errmesg];
}

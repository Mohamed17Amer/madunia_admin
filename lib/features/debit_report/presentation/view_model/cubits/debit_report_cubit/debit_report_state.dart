part of 'debit_report_cubit.dart';

@immutable
sealed class DebitReportState {}

final class DebitReportInitial extends DebitReportState {}

final class GetAllDebitItemsSuccess extends DebitReportState {
  final List<DebitItem> allUserItemDebits;
  GetAllDebitItemsSuccess({required this.allUserItemDebits}) {
    debugPrint("debits$allUserItemDebits");
  }
}

final class GetAllDebitItemsFailure extends DebitReportState {
  final String  errmesg;
  GetAllDebitItemsFailure({required this.errmesg});
}

final class DeleteDebitItemSuccess extends DebitReportState {
  final String debitItemId;
  DeleteDebitItemSuccess({required this.debitItemId});
}

final class DeleteDebitItemFailure extends DebitReportState {
  final String errmesg;
  DeleteDebitItemFailure({required this.errmesg});
}

part of 'debit_report_cubit.dart';

@immutable
abstract class DebitReportState extends Equatable {
  const DebitReportState();

  @override
  List<Object?> get props => [];
}

final class DebitReportInitial extends DebitReportState {
  const DebitReportInitial();
}

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

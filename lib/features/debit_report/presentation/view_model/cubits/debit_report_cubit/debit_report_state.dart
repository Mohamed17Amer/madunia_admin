part of 'debit_report_cubit.dart';

@immutable
sealed class DebitReportState {}

final class DebitReportInitial extends DebitReportState {}

final class SendItemInquiryRequestSuccess extends DebitReportState {}

final class SendAlarmToUserSuccess extends DebitReportState {}

final class GetAllDebitItemsSuccess extends DebitReportState{
final   allUserItemDebits;
GetAllDebitItemsSuccess({required this.allUserItemDebits}){
  debugPrint("debits$allUserItemDebits");
}

}
final class GetAllDebitItemsFailure extends DebitReportState{
  final errmesg;
  GetAllDebitItemsFailure({required this.errmesg});
}
final class AddNewDebitItemSuccess extends DebitReportState {}
final class AddNewDebitItemFailure extends DebitReportState {}
final class UpdateDebitItemSuccess extends DebitReportState {}
final class UpdateDebitItemFailure extends DebitReportState {}
final class DeleteDebitItemSuccess extends DebitReportState {}
final class DeleteDebitItemFailure extends DebitReportState {}
final class GetAllDebitItemsLoading extends DebitReportState {}

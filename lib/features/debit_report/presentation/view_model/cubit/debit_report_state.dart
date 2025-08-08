part of 'debit_report_cubit.dart';

@immutable
sealed class DebitReportState {}

final class DebitReportInitial extends DebitReportState {}

final class SendItemInquiryRequestSuccess extends DebitReportState {}

final class SendAlarmToUserSuccess extends DebitReportState {}

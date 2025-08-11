part of 'add_debit_item_cubit.dart';

@immutable
sealed class AddDebitItemState {}

final class AddDebitItemInitial extends AddDebitItemState {}

final class ValidateTxtFormFieldSuccess extends AddDebitItemState {}

final class ValidateTxtFormFieldFailure extends AddDebitItemState {}

final class AddNewDebitItemSuccess extends AddDebitItemState {
  final debitItem;
  AddNewDebitItemSuccess({this.debitItem}) {
    log("new debit item added   $debitItem   ");
  }
}

final class AddNewDebitItemLoading extends AddDebitItemState {}

final class AddNewDebitItemFailure extends AddDebitItemState {
  final String errmesg;

  AddNewDebitItemFailure({required this.errmesg});
}

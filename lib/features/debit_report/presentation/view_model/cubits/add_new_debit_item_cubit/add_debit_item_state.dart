part of 'add_debit_item_cubit.dart';

@immutable
sealed class AddDebitItemState {}

final class AddDebitItemInitial extends AddDebitItemState {}

final class ValidateTxtFormFieldSuccess extends AddDebitItemState {}
final class ValidateTxtFormFieldFailure extends AddDebitItemState {}


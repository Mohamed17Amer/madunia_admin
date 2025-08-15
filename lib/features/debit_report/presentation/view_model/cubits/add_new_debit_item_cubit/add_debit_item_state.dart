part of 'add_debit_item_cubit.dart';

@immutable
abstract class AddDebitItemState extends Equatable {
  const AddDebitItemState();

  @override
  List<Object?> get props => [];
}

final class AddDebitItemInitial extends AddDebitItemState {
  const AddDebitItemInitial();
}

final class ValidateTxtFormFieldSuccess extends AddDebitItemState {
  const ValidateTxtFormFieldSuccess();
}

final class ValidateTxtFormFieldFailure extends AddDebitItemState {
  const ValidateTxtFormFieldFailure();
}

final class AddNewDebitItemSuccess extends AddDebitItemState {
  final dynamic debitItem; // type left dynamic because original was untyped
   AddNewDebitItemSuccess({this.debitItem}) {
    log("new debit item added $debitItem");
  }

  @override
  List<Object?> get props => [debitItem];
}

final class AddNewDebitItemLoading extends AddDebitItemState {
  const AddNewDebitItemLoading();
}

final class AddNewDebitItemFailure extends AddDebitItemState {
  final String errmesg;
  const AddNewDebitItemFailure({required this.errmesg});

  @override
  List<Object?> get props => [errmesg];
}

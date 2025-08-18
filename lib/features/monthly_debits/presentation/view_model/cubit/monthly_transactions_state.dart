// lib/features/monthly_debits/presentation/view_model/cubit/monthly_transactions_state.dart

part of 'monthly_transactions_cubit.dart';

abstract class MonthlyTransactionsState extends Equatable {
  const MonthlyTransactionsState();

  @override
  List<Object?> get props => [];
}

class MonthlyTransactionsInitial extends MonthlyTransactionsState {}

class MonthlyTransactionsSelectionUpdated extends MonthlyTransactionsState {
  final List<String> selectedUserIds;
  final bool isAllSelected;

  const MonthlyTransactionsSelectionUpdated({
    required this.selectedUserIds,
    required this.isAllSelected,
  });

  @override
  List<Object?> get props => [selectedUserIds, isAllSelected];
}

class MonthlyTransactionsExecuting extends MonthlyTransactionsState {}

class MonthlyTransactionsExecuted extends MonthlyTransactionsState {
  final String message;

  const MonthlyTransactionsExecuted({required this.message});

  @override
  List<Object?> get props => [message];
}

class MonthlyTransactionsError extends MonthlyTransactionsState {
  final String errorMessage;

  const MonthlyTransactionsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
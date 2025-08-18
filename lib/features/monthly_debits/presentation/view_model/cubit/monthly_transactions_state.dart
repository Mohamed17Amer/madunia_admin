part of 'monthly_transactions_cubit.dart';

sealed class MonthlyTransactionsState extends Equatable {
  const MonthlyTransactionsState();

  @override
  List<Object> get props => [];
}

final class MonthlyTransactionsInitial extends MonthlyTransactionsState {}

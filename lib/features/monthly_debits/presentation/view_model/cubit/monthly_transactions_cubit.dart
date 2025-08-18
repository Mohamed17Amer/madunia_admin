import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'monthly_transactions_state.dart';

class MonthlyTransactionsCubit extends Cubit<MonthlyTransactionsState> {
  MonthlyTransactionsCubit() : super(MonthlyTransactionsInitial());
}

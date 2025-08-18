// lib/features/monthly_debits/presentation/view_model/cubit/monthly_transactions_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'monthly_transactions_state.dart';

class MonthlyTransactionsCubit extends Cubit<MonthlyTransactionsState> {
  MonthlyTransactionsCubit() : super(MonthlyTransactionsInitial());

  // Selected user IDs list
  final List<String> _selectedUserIds = [];
  
  // Getter for selected user IDs
  List<String> get selectedUserIds => List.unmodifiable(_selectedUserIds);
  
  // Check if a user is selected
  bool isUserSelected(String userId) {
    return _selectedUserIds.contains(userId);
  }
  
  // Get selected count
  int get selectedCount => _selectedUserIds.length;
  
  // Check if all users are selected (requires total count)
  bool isAllSelected(int totalUserCount) {
    return _selectedUserIds.length == totalUserCount;
  }

  // Toggle user selection
  void toggleUserSelection(String userId) {
    if (_selectedUserIds.contains(userId)) {
      _selectedUserIds.remove(userId);
    } else {
      _selectedUserIds.add(userId);
    }
    
    _emitSelectionUpdate();
  }

  // Select all users
  void selectAllUsers(List<String> allUserIds) {
    _selectedUserIds.clear();
    _selectedUserIds.addAll(allUserIds);
    _emitSelectionUpdate();
  }

  // Deselect all users
  void deselectAllUsers() {
    _selectedUserIds.clear();
    _emitSelectionUpdate();
  }

  // Toggle all users selection
  void toggleAllUsers(List<String> allUserIds) {
    if (isAllSelected(allUserIds.length)) {
      deselectAllUsers();
    } else {
      selectAllUsers(allUserIds);
    }
  }

  // Clear selection
  void clearSelection() {
    _selectedUserIds.clear();
    _emitSelectionUpdate();
  }

  // Execute monthly transactions for selected users
  Future<void> executeMonthlyTransactions({
    required String recordName,
    required double recordMoneyValue,
    required String status,
    Map<String, dynamic>? additionalFields,
  }) async {
    if (_selectedUserIds.isEmpty) {
      emit(const MonthlyTransactionsError(
        errorMessage: 'No users selected for monthly transactions',
      ));
      return;
    }

    try {
      emit(MonthlyTransactionsExecuting());

      // TODO: Replace with your FirestoreService implementation
      // Example:
      // final firestoreService = GetIt.instance<FirestoreService>();
      // 
      // for (final userId in _selectedUserIds) {
      //   await firestoreService.addDebitItem(
      //     userId: userId,
      //     recordName: recordName,
      //     recordMoneyValue: recordMoneyValue,
      //     status: status,
      //     additionalFields: additionalFields,
      //   );
      // }

      // Simulate API call for now - REMOVE THIS IN PRODUCTION
      await Future.delayed(const Duration(seconds: 2));

      emit(MonthlyTransactionsExecuted(
        message: 'Monthly transactions executed for ${_selectedUserIds.length} users',
      ));

      // Clear selection after successful execution
      clearSelection();
    } catch (e) {
      emit(MonthlyTransactionsError(
        errorMessage: 'Failed to execute monthly transactions: ${e.toString()}',
      ));
    }
  }

  // Private method to emit selection update
  void _emitSelectionUpdate() {
    emit(MonthlyTransactionsSelectionUpdated(
      selectedUserIds: List.from(_selectedUserIds),
      isAllSelected: false, // Will be calculated in UI based on total count
    ));
  }

  @override
  Future<void> close() {
    _selectedUserIds.clear();
    return super.close();
  }
}
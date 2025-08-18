import 'package:flutter/material.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view/widgets/select_all_button.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view/widgets/selection_status.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view_model/cubit/monthly_transactions_cubit.dart';

class SelectionControlButtonBody extends StatelessWidget {
  MonthlyTransactionsCubit monthlyCubit;
  bool isAllSelected;
  List<String> allUserIds;
  int selectedCount;
  int usersListLength;
   SelectionControlButtonBody({super.key, required this.monthlyCubit, required this.isAllSelected, required this.allUserIds, required this.selectedCount, required this.usersListLength });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selection status
        SelectionStatus(
          monthlyCubit: monthlyCubit,
          selectedCount: selectedCount,
          usersListLength: usersListLength,
        ),

        const SizedBox(height: 12),

        // Select all/none button
        SelectAllButton(
          monthlyCubit: monthlyCubit,
          isAllSelected: isAllSelected,
          allUserIds: allUserIds,
        ),
      ],
    );
  }
}

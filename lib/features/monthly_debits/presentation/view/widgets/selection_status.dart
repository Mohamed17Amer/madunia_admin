import 'package:flutter/material.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view_model/cubit/monthly_transactions_cubit.dart';

class SelectionStatus extends StatelessWidget {
  MonthlyTransactionsCubit monthlyCubit;
  int selectedCount;
  int usersListLength;

   SelectionStatus({super.key, required this.monthlyCubit, required this.selectedCount, required this.usersListLength });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTxt(
          title: "المحددون: $selectedCount من $usersListLength",
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        if (selectedCount > 0)
          TextButton.icon(
            onPressed: () => monthlyCubit.clearSelection(),
            icon: const Icon(Icons.clear, size: 18),
            label: const CustomTxt(title: "إلغاء التحديد"),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
      ],
    );
  }
}

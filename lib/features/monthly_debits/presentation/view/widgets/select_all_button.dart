import 'package:flutter/material.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view_model/cubit/monthly_transactions_cubit.dart';

class SelectAllButton extends StatelessWidget {
  MonthlyTransactionsCubit monthlyCubit;
  bool isAllSelected;
  List<String> allUserIds;

  SelectAllButton({
    super.key,
    required this.monthlyCubit,
    required this.isAllSelected,
    required this.allUserIds,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => monthlyCubit.toggleAllUsers(allUserIds),
        icon: Icon(isAllSelected ? Icons.deselect : Icons.select_all),
        label: CustomTxt(
          title: isAllSelected ? "إلغاء تحديد الكل" : "تحديد الكل",
          fontColor: Colors.white,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isAllSelected ? Colors.orange : Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

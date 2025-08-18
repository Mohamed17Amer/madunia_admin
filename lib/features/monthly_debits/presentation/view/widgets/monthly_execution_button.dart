import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view_model/cubit/monthly_transactions_cubit.dart';

class MonthlyExecutionButton extends StatelessWidget {
  const MonthlyExecutionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MonthlyTransactionsCubit, MonthlyTransactionsState>(
      listener: (context, state) {
        if (state is MonthlyTransactionsExecuted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomTxt(title: state.message, fontColor: Colors.white),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is MonthlyTransactionsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomTxt(
                title: state.errorMessage,
                fontColor: Colors.white,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<MonthlyTransactionsCubit>();
        final selectedCount = cubit.selectedCount;
        final isExecuting = state is MonthlyTransactionsExecuting;

        if (selectedCount == 0 && !isExecuting) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: isExecuting ? null : () => _showExecuteDialog(context),
          icon: isExecuting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send),
          label: CustomTxt(
            title: isExecuting ? "جاري التنفيذ..." : "تنفيذ ($selectedCount)",
            fontColor: Colors.white,
          ),
          backgroundColor: isExecuting ? Colors.grey : Colors.green,
        );
      },
    );
  }

  void _showExecuteDialog(BuildContext context) {
    final cubit = context.read<MonthlyTransactionsCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const CustomTxt(
          title: "تأكيد تنفيذ المعاملات الشهرية",
          fontWeight: FontWeight.bold,
        ),
        content: CustomTxt(
          title:
              "هل أنت متأكد من تنفيذ المعاملات الشهرية لـ ${cubit.selectedCount} مستخدم؟",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const CustomTxt(title: "إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // TODO: Replace with your actual values
              cubit.executeMonthlyTransactions(
                recordName: "رسوم شهرية",
                recordMoneyValue: 100.0,
                status: "pending",
                additionalFields: {
                  'isMonthlyDebit': true,
                  'executedAt': DateTime.now().toIso8601String(),
                },
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const CustomTxt(title: "تأكيد", fontColor: Colors.white),
          ),
        ],
      ),
    );
  }
}

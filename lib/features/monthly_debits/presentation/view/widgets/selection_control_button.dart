import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/features/all_users/presentation/view_model/cubit/all_users_cubit.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view/widgets/selection_control_button_body.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view/widgets/selection_control_button_container.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view_model/cubit/monthly_transactions_cubit.dart';

class SelectionControlButton extends StatelessWidget {
  const SelectionControlButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<MonthlyTransactionsCubit, MonthlyTransactionsState>(
        // for selection
        builder: (context, monthlyState) {
          return BlocBuilder<AllUsersCubit, AllUsersState>(
            builder: (context, usersState) {
              if (usersState is! GetAllUsersSuccess ||
                  usersState.users.isEmpty) {
                // for user list itself
                return const SizedBox.shrink();
              } else {
                final cubit = context.read<MonthlyTransactionsCubit>();

                final allUserIds = usersState.users
                    .map((user) => user.id)
                    .toList();
                final isAllSelected = cubit.isAllSelected(
                  usersState.users.length,
                );
                final selectedCount = cubit.selectedCount;

                return SelectionControlButtonContainer(
                  child: SelectionControlButtonBody(
                    monthlyCubit: cubit,
                    isAllSelected: isAllSelected,
                    allUserIds: allUserIds,
                    selectedCount: selectedCount,
                    usersListLength: usersState.users.length,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

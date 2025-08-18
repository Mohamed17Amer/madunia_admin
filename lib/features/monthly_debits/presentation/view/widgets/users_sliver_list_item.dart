import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/widgets/custom_circle_avatar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view_model/cubit/monthly_transactions_cubit.dart';

class UsersSliverListItemTransactions extends StatelessWidget {
  final AppUser user;
  const UsersSliverListItemTransactions({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonthlyTransactionsCubit, MonthlyTransactionsState>(
      builder: (context, state) {
        final cubit = context.read<MonthlyTransactionsCubit>();
        final isSelected = cubit.isUserSelected(user.id);
        
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected 
                  ? Colors.blue 
                  : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CheckboxListTile(
              value: isSelected,
              onChanged: (val) {
                cubit.toggleUserSelection(user.id);
              },
              title: CustomTxt(
                title: user.uniqueName,
                fontWeight: FontWeight.bold,
                fontColor: AppColors.debitReportItemTitleColor,
              ),
              // subtitle: CustomTxt(
              //   title: user.phoneNumber,
              //   fontWeight: FontWeight.normal,
              //   fontColor: AppColors.debitReportItemSubTitleColor,
              // ),
              secondary: CustomCircleAvatar(
                r1: 40,
                r2: 30,
                backgroundImage: AssetImage(
                  'assets/images/shorts_place_holder.png',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
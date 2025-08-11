import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/router/app_screens.dart';
import 'package:madunia_admin/core/utils/widgets/custom_icon.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubits/debit_report_cubit/debit_report_cubit.dart';

class AddNewDebitItemButton extends StatelessWidget {
  final AppUser user;
  const AddNewDebitItemButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<DebitReportCubit>().navigateTo(
          context: context,
          path: AppScreens.addNewDebitItemScreen,
          extra: user,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomIcon(
            icon: Icons.add_circle_outline_rounded,
            color: AppColors.homeAppBarIconsBackgroundColor,
          ),
          CustomTxt(title: "أضف عنصرًا جديدًا للمديونية"),
        ],
      ),
    );
  }
}

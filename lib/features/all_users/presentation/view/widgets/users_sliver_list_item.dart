import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/router/app_screens.dart';
import 'package:madunia_admin/core/utils/widgets/custom_circle_avatar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_icon.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/all_users/presentation/view_model/cubit/all_users_cubit.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubits/debit_report_cubit/debit_report_cubit.dart';

class UsersSliverListItem extends StatelessWidget {
  const UsersSliverListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllUsersCubit, AllUsersState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).push(AppScreens.userDetailsScreen);
            },
            child: SizedBox(
              //height: MediaQuery.of(context).size.height*.2,
              child: ListTile(
                // user name
                title: const CustomTxt(
                  title: "اسم المستخدم",
                  fontWeight: FontWeight.bold,

                  fontColor: AppColors.debitReportItemTitleColor,
                ),

                // user phone
                subtitle: const CustomTxt(
                  title: "01011245647",
                  fontColor: AppColors.debitReportItemSubTitleColor,
                ),

                // user photo
                leading: CustomCircleAvatar(
                  r1: 40,
                  r2: 30,
                  backgroundImage: AssetImage(
                    'assets/images/shorts_place_holder.png',
                  ),
                ),

                // send alert
                trailing: CustomIcon(
                  onPressed: () {
                    context.read<DebitReportCubit>().sendAlarmToUser(
                      context: context,
                    );
                  },
                  icon: Icons.add_alert_outlined,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

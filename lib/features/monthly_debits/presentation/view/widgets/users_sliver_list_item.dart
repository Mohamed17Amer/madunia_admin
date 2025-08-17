import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/widgets/custom_circle_avatar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/all_users/presentation/view_model/cubit/all_users_cubit.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';

class UsersSliverListItemTransactions extends StatelessWidget {
  final AppUser user;
  const UsersSliverListItemTransactions({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllUsersCubit, AllUsersState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            //height: MediaQuery.of(context).size.height*.2,
            child: CheckboxListTile(
              value: true,
              onChanged: (val) {},
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

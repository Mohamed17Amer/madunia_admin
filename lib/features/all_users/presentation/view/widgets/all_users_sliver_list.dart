import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/features/all_users/presentation/view/widgets/users_sliver_list_item.dart';
import 'package:madunia_admin/features/all_users/presentation/view_model/cubit/all_users_cubit.dart';
class AllUsersSliverList extends StatelessWidget {
  const AllUsersSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllUsersCubit, AllUsersState>(
      builder: (context, state) {
        return SliverList.separated(
          itemBuilder: (BuildContext context, int index) {
            return UsersSliverListItem();
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              thickness: 2,
              color: AppColors.bottomNavBarSelectedItemColor,
            );
          },
        );
      },
    );
  }
}

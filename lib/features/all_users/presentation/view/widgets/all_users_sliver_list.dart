import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/features/all_users/presentation/view/widgets/users_sliver_list_item.dart';
import 'package:madunia_admin/features/all_users/presentation/view_model/cubit/all_users_cubit.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';

class AllUsersSliverList extends StatelessWidget {
  final List<AppUser> users;
  const AllUsersSliverList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllUsersCubit, AllUsersState>(
      builder: (context, state) {
        return SliverList.separated(
          itemBuilder: (BuildContext context, int index) {
            return UsersSliverListItem(user: users[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              thickness: 2,
              color: AppColors.bottomNavBarSelectedItemColor,
            );
          },
          itemCount: users.length,
        );
      },
    );
  }
}

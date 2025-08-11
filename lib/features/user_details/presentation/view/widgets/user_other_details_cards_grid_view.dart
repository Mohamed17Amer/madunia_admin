import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_card_item.dart';
import 'package:madunia_admin/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserOtherDetailsCardsGridView extends StatelessWidget {
 final AppUser? user;
  const UserOtherDetailsCardsGridView({super.key, this.user});


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
         
          },

          child: UserDetailsCardItem(user:user!, index:index, flag:"others"),
        );
      },
      itemCount: context
          .read<UserDetailsCubit>()
          .userOtherDrtailsCategoriess
          .length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: .9,
      ),
    );
  }
}

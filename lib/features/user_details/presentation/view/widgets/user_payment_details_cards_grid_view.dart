import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/utils/router/app_screens.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_card_item.dart';
import 'package:madunia_admin/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserPaymentDetailsCardsGridView extends StatelessWidget {
  final AppUser? user;
  final List<double>? totals;
  const UserPaymentDetailsCardsGridView({
    super.key,
    required this.user,
    required this.totals,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (index == 0) {
              navigateToWithGoRouter(
                context: context,
                path: AppScreens.debitScreen,
                extra: user,

              );
            }
            else if (index == 1) {
               navigateToWithGoRouter(
                context: context,
                path: AppScreens.ownedScreen,
                extra: user,

              );
            }
          },

          child: UserDetailsCardItem(
            user: user!,
            index: index,
            flag: "payment",
            total: totals![index],
          ),
        );
      },
      itemCount: context
          .read<UserDetailsCubit>()
          .userPaymentDetailsCategoriess
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

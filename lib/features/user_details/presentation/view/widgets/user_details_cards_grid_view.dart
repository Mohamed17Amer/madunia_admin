import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:madunia_admin/core/utils/router/app_screens.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_card_item.dart';

class UserDetailsCardsGridView extends StatelessWidget {
  const UserDetailsCardsGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (index == 0) {
              GoRouter.of(context).push(AppScreens.debitScreen);
            }
          },

          child: UserDetailsCardItem(),
        );
      },
      itemCount: 3,
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

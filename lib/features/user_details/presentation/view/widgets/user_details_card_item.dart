import 'package:flutter/material.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_other_details_card_item_body.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_payment_details_card_item_body.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_card_item_container.dart';

class UserDetailsCardItem extends StatelessWidget {
  final AppUser? user;
  final int? index;
  final String? flag;
  const UserDetailsCardItem({
    super.key,
    this.user,
    this.index,
    required this.flag,
  });

  @override
  Widget build(BuildContext context) {
    return UserDetailsCardItemContainer(
      itemBody: (flag == "payment")
          ? UserPaymentDetailsCardItemBody(user: user!, index: index!)
          : UserOtherDetailsCardItemBody(user: user!, index: index!),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:madunia_admin/features/app/data/models/app_user_model.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_card_item_body.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_card_item_container.dart';

class UserDetailsCardItem extends StatelessWidget {
  final AppUser? user;
  final int? index;
  const UserDetailsCardItem({super.key, this.user, this.index});

  @override
  Widget build(BuildContext context) {
    return UserDetailsCardItemContainer(itemBody: UserDetailsCardItemBody(user:user!, index:index!));
  }
}

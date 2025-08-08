import 'package:flutter/material.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_card_item_body.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_card_item_container.dart';

class UserDetailsCardItem extends StatelessWidget {
  const UserDetailsCardItem({super.key});

  @override
  Widget build(BuildContext context) {
    return UserDetailsCardItemContainer(itemBody: UserDetailsCardItemBody());
  }
}

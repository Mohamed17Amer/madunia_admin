import 'package:flutter/material.dart';
import 'package:madunia_admin/core/utils/widgets/custom_circle_avatar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/app/data/models/app_user_model.dart';

class UserDetailsProfileSection extends StatelessWidget {
  final AppUser? user;
  const UserDetailsProfileSection({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomCircleAvatar(
            r1: 60,
            r2: 50,
            backgroundImage:
             AssetImage(
              'assets/images/shorts_place_holder.png',
            ),
          ),

          const SizedBox(height: 5),
          CustomTxt(title: user!.uniqueName , fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}

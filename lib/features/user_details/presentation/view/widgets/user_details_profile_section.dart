import 'package:flutter/material.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/utils/widgets/custom_circle_avatar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_dialog.dart';
import 'package:madunia_admin/core/utils/widgets/custom_icon.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';

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
            backgroundImage: AssetImage(
              'assets/images/shorts_place_holder.png',
            ),
          ),

          const SizedBox(height: 5),
          CustomTxt(title: user!.uniqueName, fontWeight: FontWeight.bold),
          const SizedBox(height: 5),
          CustomTxt(title: user!.phoneNumber, fontWeight: FontWeight.bold),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomIcon(
                icon: Icons.copyright,
                onPressed: () {
                  copyToClipboard(text: user?.id ?? "");
                },
              ),
              const SizedBox(height: 5),

              CustomIcon(
                icon: Icons.file_copy,
                onPressed: () {
                  copyToClipboard(text: user?.uniqueName ?? "");
                },
              ),
              const SizedBox(height: 5),

              CustomIcon(
                icon: Icons.phone,
                onPressed: () {
                  copyToClipboard(text: user?.phoneNumber ?? "");
                },
              ),

              const SizedBox(height: 5),

              CustomIcon(
                icon: Icons.remove_circle_outline_rounded,
                onPressed: () {
                  CustomDialog(context: context, userId: user!.id);

                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view/widgets/all_admin_privileges.dart';

class ManipulateUsersScreen extends StatelessWidget {
  const ManipulateUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          // safe area
          SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 5))),

          // title
          SliverToBoxAdapter(child: CustomAppBar(title: "خدمات الأدمن")),
          SliverToBoxAdapter(child: SizedBox(height: 20)),

          // all admin Privileges   buttons
          SliverToBoxAdapter(
            child: SizedBox(height: 500, child: AllAdminPrivilegesButtons()),
          ),
        ],
      ),
    );
  }
}

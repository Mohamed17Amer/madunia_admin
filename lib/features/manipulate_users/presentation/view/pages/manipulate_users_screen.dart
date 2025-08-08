import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view/widgets/all_admin_privileges.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view_model/cubits/manipulate_users_cubit/manipulate_users_cubit.dart';

class ManipulateUsersScreen extends StatelessWidget {
  const ManipulateUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManipulateUsersCubit(),
      child: BlocBuilder<ManipulateUsersCubit, ManipulateUsersState>(
        builder: (context, state) {
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
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/features/all_users/presentation/view/widgets/all_users_sliver_list.dart';
import 'package:madunia_admin/features/all_users/presentation/view_model/cubit/all_users_cubit.dart';

class AllUsersScreen extends StatelessWidget {
  const AllUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllUsersCubit()..getAllUsers(),
      child: BlocBuilder<AllUsersCubit, AllUsersState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                // safe area
                SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 5))),
                // title
                SliverToBoxAdapter(child: CustomAppBar(title: "جميع الأعضاء")),
                SliverToBoxAdapter(child: SizedBox(height: 20)),

                if (state is GetAllUsersSuccess) ...[
                  AllUsersSliverList(users: state.users),
                ] else if (state is GetAllUsersFailure) ...[
                  SliverFillRemaining(
                    child: Center(child: Text(state.errmesg)),
                  ),
                ] else ...[
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

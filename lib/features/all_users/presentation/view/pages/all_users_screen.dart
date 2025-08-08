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
      create: (context) => AllUsersCubit(),
      child: BlocBuilder<AllUsersCubit, AllUsersState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: context.read<AllUsersCubit>().repairScreenKey,
              child: CustomScrollView(
                 
                  slivers: [
                    SafeArea(child: SizedBox(height: 20)),
                    CustomAppBar(title: "جميع الأعضاء"),


                SliverToBoxAdapter(child: SizedBox(height: 20)),
                AllUsersSliverList(),

                  ],
                ),
              ),
            );
          
        },
      ),
    );
  }
}

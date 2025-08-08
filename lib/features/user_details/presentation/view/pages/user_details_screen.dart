import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_cards_grid_view.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_profile_section.dart';
import 'package:madunia_admin/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailsCubit(),
      child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.homeGradientColorsList,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomScrollView(
                    slivers: [
                      // Top safe area spacing
                      SliverToBoxAdapter(
                        child: SafeArea(child: SizedBox(height: 20)),
                      ),

                      // Profile section
                      SliverToBoxAdapter(child: UserDetailsProfileSection()),
                      SliverToBoxAdapter(child: SizedBox(height: 20)),

                      // Grid view section
                      SliverToBoxAdapter(child: UserDetailsCardsGridView()),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

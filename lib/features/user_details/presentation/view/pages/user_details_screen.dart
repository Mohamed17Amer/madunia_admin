import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia_admin/features/app/data/models/app_user_model.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_other_details_cards_grid_view.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_payment_details_cards_grid_view.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_profile_section.dart';
import 'package:madunia_admin/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserDetailsScreen extends StatelessWidget {
  final AppUser? user;
  const UserDetailsScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailsCubit(),
      child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
        builder: (context, state) {
          return CustomScaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  // Top safe area spacing
                  SliverToBoxAdapter(
                    child: SafeArea(child: SizedBox(height: 20)),
                  ),

                  // Profile section
                  SliverToBoxAdapter(
                    child: UserDetailsProfileSection(user: user),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Grid view section
                  SliverToBoxAdapter(
                    child: UserPaymentDetailsCardsGridView(user: user),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 5)),

                  SliverToBoxAdapter(
                    child: UserOtherDetailsCardsGridView(user: user),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

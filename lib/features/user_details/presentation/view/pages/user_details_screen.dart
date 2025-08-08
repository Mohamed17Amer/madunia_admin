import 'package:flutter/material.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_cards_grid_view.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_profile_section.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          // Top safe area spacing
          SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 20))),

          // Profile section
          SliverToBoxAdapter(child: UserDetailsProfileSection()),
          SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Grid view section
          SliverToBoxAdapter(child: UserDetailsCardsGridView()),
        ],
      ),
    );
  }
}

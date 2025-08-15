import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view_model/cubits/manipulate_users_cubit/manipulate_users_cubit.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_profile_section.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_other_details_cards_grid_view.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_payment_details_cards_grid_view.dart';
import 'package:madunia_admin/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserDetailsScreen extends StatelessWidget {
  final AppUser? user;
  const UserDetailsScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              UserDetailsCubit()..getTotalMoney(userId: user!.id),
        ),
        // BlocProvider(create: (context) => ManipulateUsersCubit()),
      ],
      child: CustomScaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              ..._drawHeader(),
              BlocBuilder<UserDetailsCubit, UserDetailsState>(
                builder: (context, state) {
                  return SliverList(
                    delegate: SliverChildListDelegate(_drawBody(state)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _drawHeader() {
    return <Widget>[
      SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 20))),
      SliverToBoxAdapter(child: UserDetailsProfileSection(user: user)),
      SliverToBoxAdapter(child: SizedBox(height: 20)),
    ];
  }

  List<Widget> _drawBody(UserDetailsState state) {
    if (state is GetTotalMoneySuccess) {
      return [
        UserPaymentDetailsCardsGridView(user: user, totals: state.total),
        SizedBox(height: 5),
        UserOtherDetailsCardsGridView(user: user),
      ];
    } else {
      return [const Center(child: CircularProgressIndicator())];
    }
  }
}

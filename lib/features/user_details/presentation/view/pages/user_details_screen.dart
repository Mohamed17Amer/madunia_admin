import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/events/event_bus.dart';
import 'package:madunia_admin/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_details_profile_section.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_other_details_cards_grid_view.dart';
import 'package:madunia_admin/features/user_details/presentation/view/widgets/user_payment_details_cards_grid_view.dart';
import 'package:madunia_admin/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserDetailsScreen extends StatefulWidget {
  final AppUser? user;
  const UserDetailsScreen({super.key, this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _sub = eventBus.on<UserDataUpdatedEvent>().listen((event) {
      if (event.userId == widget.user!.id) {
        context.read<UserDetailsCubit>().getTotalMoney(userId: widget.user!.id);
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailsCubit()..getTotalMoney(userId:widget. user!.id),
      child: CustomScaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              // static headers
              ..._drawHeader(),

              // Dynamic content
              BlocBuilder<UserDetailsCubit, UserDetailsState>(
                builder: (context, state) {
                  return SliverList(
                    delegate: SliverChildListDelegate(_drawBody(context, state)),
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

      // Profile section
      SliverToBoxAdapter(child: UserDetailsProfileSection(user: widget. user)),
      SliverToBoxAdapter(child: SizedBox(height: 20)),
    ];
  }

  List<Widget> _drawBody(BuildContext context, UserDetailsState state) {
    // Grid view section
    if (state is GetTotalMoneySuccess) {
      return [
        UserPaymentDetailsCardsGridView(
          user: widget. user,
          totals: state.total,
        ),
        SizedBox(height: 5),
        UserOtherDetailsCardsGridView(user: widget. user),
      ];
    } else {
      return [
        const Center(child: CircularProgressIndicator()),
      ];
    }
  }
}
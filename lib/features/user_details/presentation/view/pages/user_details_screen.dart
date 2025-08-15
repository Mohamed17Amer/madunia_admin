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
  StreamSubscription? _sub;
  late final UserDetailsCubit _cubit; // ✅ store cubit reference

  @override
  void dispose() {
    // Cancel listener before widget tree is gone
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        _cubit = UserDetailsCubit()
          ..getTotalMoney(userId: widget.user!.id);

        // Subscribe without using `context` inside the callback
        _sub = eventBus.on<UserDataUpdatedEvent>().listen((event) {
          if (event.userId == widget.user!.id) {
            _cubit.getTotalMoney(userId: widget.user!.id);
          }
        });

        return _cubit;
      },
      child: CustomScaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              ..._drawHeader(),
              BlocBuilder<UserDetailsCubit, UserDetailsState>(
                builder: (context, state) {
                  return SliverList(
                    delegate: SliverChildListDelegate(
                      _drawBody(state),
                    ),
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
      SliverToBoxAdapter(
        child: UserDetailsProfileSection(user: widget.user),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 20)),
    ];
  }

  List<Widget> _drawBody(UserDetailsState state) {
    if (state is GetTotalMoneySuccess) {
      return [
        UserPaymentDetailsCardsGridView(
          user: widget.user,
          totals: state.total,
        ),
        SizedBox(height: 5),
        UserOtherDetailsCardsGridView(user: widget.user),
      ];
    } else {
      return [
        const Center(child: CircularProgressIndicator()),
      ];
    }
  }
}

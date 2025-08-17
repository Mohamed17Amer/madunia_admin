import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/all_users/presentation/view/widgets/all_users_sliver_list.dart';
import 'package:madunia_admin/features/all_users/presentation/view_model/cubit/all_users_cubit.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view/widgets/all_users_sliver_list.dart';

class MonthlyDebitsScreen extends StatelessWidget {
  const MonthlyDebitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllUsersCubit()..getAllUsers(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            // Static headers - won't rebuild when state changes
            ..._drawHeader(),

            // Dynamic content - only this part rebuilds
            BlocBuilder<AllUsersCubit, AllUsersState>(
              builder: (context, state) {
                return _drawBody(context, state);
              },
            ),
                  SliverToBoxAdapter(child: SizedBox(height: 100)),

          ],
        ),
      ),
    );
  }

  List<Widget> _drawHeader() {
    return <Widget>[
      SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 5))),
      SliverToBoxAdapter(child: CustomAppBar(title: "إضافة مديونية شهرية")),
      SliverToBoxAdapter(child: SizedBox(height: 20)),
    ];
  }

  Widget _drawBody (BuildContext context, AllUsersState state) {
    // success
    if (state is GetAllUsersSuccess) {
      // empty list
      if (state.users.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: CustomTxt(title: "No users added yet")),
        );
      }
      // not empty list
      else {
        return AllUsersSliverListForMonthlyTransactions(users: state.users);
      }
    }
    // failure
    else if (state is GetAllUsersFailure) {
      return SliverFillRemaining(
        child: Center(child: CustomTxt(title: state.errmesg)),
      );
    }
    // loading
    else {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
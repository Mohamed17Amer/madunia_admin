// Updated AllUsersForMonthlyTransactionsScreen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/all_users/presentation/view_model/cubit/all_users_cubit.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view/widgets/all_users_sliver_list.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view/widgets/monthly_execution_button.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view/widgets/selection_control_button.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view_model/cubit/monthly_transactions_cubit.dart';

class AllUsersForMonthlyTransactionsScreen extends StatelessWidget {
  const AllUsersForMonthlyTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AllUsersCubit()..getAllUsers()),
        BlocProvider(create: (context) => MonthlyTransactionsCubit()),
      ],
      child: CustomScaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              // Static headers
              ..._drawHeader(),
              // Selection controls
              SelectionControlButton(),
              // Dynamic content
              _drawBody(context),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
        floatingActionButton: MonthlyExecutionButton(),
      ),
    );
  }

  List<Widget> _drawHeader() {
    return <Widget>[
      const SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 5))),
      const SliverToBoxAdapter(
        child: CustomAppBar(title: "إضافة مديونية شهرية"),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 20)),
    ];
  }

  Widget _drawBody(BuildContext context) {
    return BlocBuilder<AllUsersCubit, AllUsersState>(
      builder: (context, state) {
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
      },
    );
  }
}

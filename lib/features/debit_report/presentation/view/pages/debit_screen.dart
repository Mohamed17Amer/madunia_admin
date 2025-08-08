import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/widgets/debit_sliver_list.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubit/debit_report_cubit.dart';

class DebitScreen extends StatelessWidget {
  const DebitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DebitReportCubit(),
      child: BlocBuilder<DebitReportCubit, DebitReportState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SafeArea(child: SizedBox(height: 20)),
                ),
                SliverToBoxAdapter(
                  child: CustomAppBar(title: "كشف المديونية المستحقة عليك"),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 20)),
                DebitSliverList(),
              ],
            ),
          );
        },
      ),
    );
  }
}

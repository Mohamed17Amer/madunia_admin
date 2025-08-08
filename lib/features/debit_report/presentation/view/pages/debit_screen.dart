import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/widgets/debit_screen_widgets/debit_screen_body.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubits/debit_report_cubit/debit_report_cubit.dart';

class DebitScreen extends StatelessWidget {
  const DebitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DebitReportCubit(),
      child: BlocBuilder<DebitReportCubit, DebitReportState>(
        builder: (context, state) {
          return CustomScaffold(body: DebitScreenBody());
        },
      ),
    );
  }
}

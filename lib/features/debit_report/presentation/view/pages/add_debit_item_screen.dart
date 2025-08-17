import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/widgets/add_debit_item_screen_widgets/add_new_debit_item_screen_body.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubits/debit_report_cubit/debit_report_cubit.dart';

class AddDebitItemScreen extends StatelessWidget {
  final AppUser? user;
  const AddDebitItemScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DebitReportCubit()),
    //    BlocProvider(create: (context) => UserDetailsCubit()),
      ],
      child: BlocBuilder<DebitReportCubit, DebitReportState>(
        builder: (context, state) {
          return CustomScaffold(body: AddNewDebitItemScreenBody(user: user!));
        },
      ),
    );
  }
}

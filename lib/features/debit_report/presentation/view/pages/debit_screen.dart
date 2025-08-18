import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/widgets/debit_screen_widgets/debit_screen_body.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubits/debit_report_cubit/debit_report_cubit.dart';

class DebitScreen extends StatelessWidget {
  final AppUser user;

  const DebitScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DebitReportCubit()..getAllDebitItems(userId: user.id),
        ),
      //  BlocProvider(create: (context) => UserDetailsCubit()),
      ],
      child: CustomScaffold(body: DebitScreenBody(user: user)),
    );
  }
}

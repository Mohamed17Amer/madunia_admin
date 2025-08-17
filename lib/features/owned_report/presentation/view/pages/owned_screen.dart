import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/owned_report/presentation/view/widgets/owned_screen_widgets/owned_screen_body.dart';
import 'package:madunia_admin/features/owned_report/presentation/view_model/cubits/owned_report_cubit/owned_report_cubit.dart';
import 'package:madunia_admin/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class OwnedScreen extends StatelessWidget {
  final AppUser user;

  const OwnedScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              OwnedReportCubit()..getAllOwnedItems(userId: user.id),
        ),
       // BlocProvider(create: (context) => UserDetailsCubit()),
      ],
      child: CustomScaffold(body: OwnedScreenBody(user: user)),
    );
  }
}

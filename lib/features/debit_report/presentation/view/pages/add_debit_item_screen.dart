import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia_admin/features/app/data/models/app_user_model.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/widgets/add_debit_item_screen_widgets/add_new_debit_item_screen_body.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubits/add_new_debit_item_cubit/add_debit_item_cubit.dart';

class AddDebitItemScreen extends StatelessWidget {
  final AppUser? user;
  const AddDebitItemScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddDebitItemCubit(),
      child: BlocBuilder<AddDebitItemCubit, AddDebitItemState>(
        builder: (context, state) {
          return CustomScaffold(
            body:AddNewDebitItemScreenBody(user: user!),
          );
        },
      ),
    );
  }
}

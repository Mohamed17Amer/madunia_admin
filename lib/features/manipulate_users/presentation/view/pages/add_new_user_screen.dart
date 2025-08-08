import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view/widgets/add_new_user_body.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view_model/cubits/add_user_cubit/add_user_cubit.dart';

class AddNewUserScreen extends StatelessWidget {
  const AddNewUserScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddUserCubit(),
      child: BlocBuilder<AddUserCubit, AddUserState>(
        builder: (context, state) {
          return CustomScaffold(body: AddNewUserBody());
        },
      ),
    );
  }
}

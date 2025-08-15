import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_scaffold.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view/widgets/delete_user_body.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view_model/cubits/manipulate_users_cubit/manipulate_users_cubit.dart';

class DeleteUserScreen extends StatelessWidget {
  const DeleteUserScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManipulateUsersCubit(),
      child: BlocBuilder<ManipulateUsersCubit, ManipulateUsersState>(

        builder: (context, state) {
          return CustomScaffold(body: DeleteUserBody());
        },
      ),
    );
  }
}

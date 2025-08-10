import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/app/data/models/app_user_model.dart';
import 'package:madunia_admin/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserOtherDetailsCardItemBody extends StatelessWidget {
  final AppUser? user;
  final int? index;
  UserOtherDetailsCardItemBody({super.key, this.user, this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // debit item name
        Align(
          alignment: Alignment.topRight,
          child: CustomTxt(
            title: context
                .read<UserDetailsCubit>()
                .userOtherDrtailsCategoriess[index!],
            fontWeight: FontWeight.bold,
          ),
        ),

        // debit item value
        Align(
          alignment: Alignment.topLeft,
          child: CustomTxt(title: "", fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),

        // debit item copy
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_icon.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserDetailsCardItemBody extends StatelessWidget {
  const UserDetailsCardItemBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // debit item name
        Align(
          alignment: Alignment.topRight,
          child: CustomTxt(title: "اسم البيان"),
        ),

        // debit item value
        Align(
          alignment: Alignment.topLeft,
          child: CustomTxt(
            title:
                " 15,000"
                " جنيه مصري ",
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        // debit item copy
        Align(
          alignment: Alignment.bottomLeft,
          child: CustomIcon(
            icon: Icons.copy_all,
            onPressed: () {
              context.read<UserDetailsCubit>().copyTotalToClipboard("total");
            },
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

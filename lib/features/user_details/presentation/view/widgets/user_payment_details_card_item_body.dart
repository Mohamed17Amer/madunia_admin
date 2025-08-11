import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_icon.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserPaymentDetailsCardItemBody extends StatelessWidget {
  final AppUser? user;
  final int? index;
  late var total;
  UserPaymentDetailsCardItemBody({super.key, this.user, this.index}) {
    if (index == 0) {
      total = user?.totalDebitMoney ?? 0.00;
    } else if (index == 1)
      // ignore: curly_braces_in_flow_control_structures
      total = user?.totalMoneyOwed ?? 0.00;
    else {
      total = 0.00;
    }
  }

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
                .userPaymentDetailsCategoriess[index!], fontWeight: FontWeight.bold
            ,
          ),
        ),

        // debit item value
        Align(
          alignment: Alignment.topLeft,
          child: CustomTxt(
            title: "${total ?? 00.00} جنيه مصري ",
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

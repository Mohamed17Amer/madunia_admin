import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/utils/widgets/custom_icon.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/user_details/presentation/view_model/cubit/user_details_cubit.dart';

class UserDetailsCardItem extends StatelessWidget {
  const UserDetailsCardItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        color: generateRandomColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: CustomTxt(title: "اسم البيان"),
          ),

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
      ),
    );
  }
}

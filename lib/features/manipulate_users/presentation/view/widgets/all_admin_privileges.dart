import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/utils/router/app_screens.dart';
import 'package:madunia_admin/core/utils/widgets/custom_buttom.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/app/presentation/view_model/cubit/app_cubit.dart';

class AllAdminPrivilegesButtons extends StatelessWidget {
  const AllAdminPrivilegesButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButtom(
          onPressed: () {
            navigateToWithGoRouter(
              context: context,
              path: AppScreens.addNewUserScreen,
            );
          },
          child: const CustomTxt(
            title: "  إضافة عضو جديد",
            fontColor: Colors.white,
          ),
        ),

        CustomButtom(
          onPressed: () {
            navigateToWithGoRouter(
              context: context,
              path: AppScreens.deleteUserScreen,
            );
          },
          child: const CustomTxt(
            title: "  حذف عضو موجود",
            fontColor: Colors.white,
          ),
        ),
        CustomButtom(
          onPressed: () {},
          child: const CustomTxt(
            title: "   تعديل بيانات عضو موجود",
            fontColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

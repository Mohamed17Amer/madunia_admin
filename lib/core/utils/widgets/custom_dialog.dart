import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/helper/helper_funcs.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view_model/cubits/manipulate_users_cubit/manipulate_users_cubit.dart';

class CustomDialog {
  final BuildContext context;
  final String userId;

  CustomDialog({required this.context, required this.userId}) {
    showCustomDialog(context: context, userId: userId);
  }

  void showCustomDialog({
    required BuildContext context,
    required String userId,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: generateRandomColor(),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTxt(
                    title: 'متأكد من حذف هذا العضو ؟',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 15),
                  Wrap(
                    children: [
                      CustomTxt(
                        title: '''
            سيتم حذفه بشكلِ كامل، 
            ولن تستطيع استعادة بياناته''',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await context.read<ManipulateUsersCubit>().deleteUser(
                        context: context,
                        id: userId,
                      );
                        navigateToFirstRouteInStack(context: context);
                    },
                    child: CustomTxt(title: 'تأكيد'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

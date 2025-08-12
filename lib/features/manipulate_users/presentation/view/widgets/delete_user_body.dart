import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_buttom.dart';
import 'package:madunia_admin/core/utils/widgets/custom_circle_avatar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt_form_field.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view_model/cubits/add_user_cubit/add_user_cubit.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view_model/cubits/delete_user_cubit/delete_user_cubit.dart';

class DeleteUserBody extends StatelessWidget {
  const DeleteUserBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: context.read<DeleteUserCubit>().deleteUserScreenKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SafeArea(child: SizedBox(height: 5)),
              const CustomAppBar(title: "حذف عضو موجود "),
              const SizedBox(height: 20),

              // Avatar
              CustomCircleAvatar(
                r1: 60,
                r2: 50,
                backgroundImage: AssetImage(
                  'assets/images/shorts_place_holder.png',
                ),
              ),
              const SizedBox(height: 20),

              // Name field
              CustomTxtFormField(
                labelText: "كود العضو الموجود",
                hintText: "الرجاء إدخال كود العضو الموجود",
                maxLines: 1,
                validator: (value) {
                  return context.read<DeleteUserCubit>().validateTxtFormField(
                    value: value,
                    errorHint: "الرجاء إدخال كود العضو الموجود",
                  );
                },
                controller: context.read<DeleteUserCubit>().userIdController,
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 20),

            
              // Delete user button
              CustomButtom(
                child: const CustomTxt(
                  title: "   حذف العضو",
                  fontColor: Colors.white,
                ),
                onPressed: () async {
                  await context.read<DeleteUserCubit>().deleteNewUser(
                    context: context,
                  
                  );
                  await context.read<DeleteUserCubit>().resetSettings();
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

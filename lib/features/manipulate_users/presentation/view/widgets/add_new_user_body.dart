import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_buttom.dart';
import 'package:madunia_admin/core/utils/widgets/custom_circle_avatar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt_form_field.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view_model/cubits/manipulate_users_cubit/manipulate_users_cubit.dart';

class AddNewUserBody extends StatelessWidget {
  const AddNewUserBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: context.read<ManipulateUsersCubit>().addUserScreenKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SafeArea(child: SizedBox(height: 5)),
              const CustomAppBar(title: "إضافة عضو جديد "),
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
                labelText: "اسم العضو الجديد",
                hintText: "الرجاء إدخال اسم العضو الجديد",
                maxLines: 1,
                validator: (value) {
                  return context.read<ManipulateUsersCubit>().validateTxtFormField(
                    value: value,
                    errorHint: "الرجاء إدخال اسم العضو الجديد",
                  );
                },
                controller: context.read<ManipulateUsersCubit>().userNameController,
              ),
              const SizedBox(height: 20),

              // Phone field
              CustomTxtFormField(
                controller: context.read<ManipulateUsersCubit>().userPhoneController,
                labelText: "رقم التليفون",
                hintText: "الرجاء إدخال رقم التليفون",
                maxLines: 1,
                keyboardType: TextInputType.phone,
             inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,

                  //    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(11), // Max 11 digits
                ],
                validator: (value) {
                  return context.read<ManipulateUsersCubit>().validateTxtFormField(
                    value: value,
                    errorHint: "الرجاء إدخال رقم التليفون ",
                  );
                },
              ),
              const SizedBox(height: 20),

              // Generate unique name
              CustomButtom(
                onPressed: (context.read<ManipulateUsersCubit>().isUniqueNameGenerated)
                    ? null
                    : () {
                        context.read<ManipulateUsersCubit>().generateNewUserUniqueName(
                          context: context,
                        );
                      },
                child: CustomTxt(
                  title: "  إنشاء الاسم المميز للعضو",
                  fontColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              CustomTxt(title: context.read<ManipulateUsersCubit>().uniqueName),
              const SizedBox(height: 30),
              // Add user button
              CustomButtom(
                child: const CustomTxt(
                  title: "  إضافة العضو",
                  fontColor: Colors.white,
                ),
                onPressed: () async {
                  await context.read<ManipulateUsersCubit>().addNewUser(
                    context: context,
                  );
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

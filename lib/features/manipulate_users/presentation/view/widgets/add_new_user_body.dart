import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_buttom.dart';
import 'package:madunia_admin/core/utils/widgets/custom_circle_avatar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt_form_field.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view_model/cubits/add_user_cubit/add_user_cubit.dart';

class AddNewUserBody extends StatelessWidget {
  const AddNewUserBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: context.read<AddUserCubit>().addUserScreenKey,
        child: Column(
          children: [
            // safe area
            SafeArea(child: SizedBox(height: 5)),

            // title
            CustomAppBar(title: "إضافة عضو جديد "),
            SizedBox(height: 20),

            // new user photo
            CustomCircleAvatar(
              r1: 60,
              r2: 50,
              backgroundImage: AssetImage(
                'assets/images/shorts_place_holder.png',
              ),
            ),
            SizedBox(height: 10),

            // new user name
            Expanded(
              flex: 1,
              child: CustomTxtFormField(
                labelText: "اسم العضو الجديد",
                hintText: "الرجاء إدخال اسم العضو الجديد",
                maxLines: 1,
                validator: (value) {
                  return context.read<AddUserCubit>().validateTxtFormField(
                    value: value,
                    errorHint: "الرجاء إدخال اسم العضو الجديد",
                  );
                },
                controller: context.read<AddUserCubit>().userNameController,
              ),
            ),

            // new user phone
            Expanded(
              flex: 1,
              child: CustomTxtFormField(
                controller: context.read<AddUserCubit>().userPhoneController,
                labelText: "رقم التليفون",
                hintText: "الرجاء إدخال رقم التليفون",
                maxLines: 1,
                keyboardType: TextInputType.phone,

                validator: (value) {
                  return context.read<AddUserCubit>().validateTxtFormField(
                    value: value,
                    errorHint: "الرجاء إدخال رقم التليفون ",
                  );
                },
              ),
            ),

            // add new user button
            Expanded(
              flex: 1,
              child: CustomButtom(
                child: const CustomTxt(
                  title: "  إضافة العضو",
                  fontColor: Colors.white,
                ),
                onPressed: () {
                  context.read<AddUserCubit>().addNewUser(context: context);
                },
              ),
            ),

            Expanded(flex: 4, child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

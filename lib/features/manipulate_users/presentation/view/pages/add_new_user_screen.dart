import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_buttom.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt_form_field.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view_model/cubit/add_user_cubit/add_user_cubit.dart';

class AddNewUserScreen extends StatelessWidget {
  const AddNewUserScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddUserCubit(),
      child: BlocBuilder<AddUserCubit, AddUserState>(
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.homeGradientColorsList,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: context.read<AddUserCubit>().addUserScreenKey,
                    child: Column(
                      children: [
                        SafeArea(child: SizedBox(height: 5)),
                        CustomAppBar(title: "إضافة عضو جديد "),

                        SizedBox(height: 20),

                        const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.deepPurple,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'assets/images/shorts_place_holder.png',
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        Expanded(
                          flex: 1,
                          child: CustomTxtFormField(
                            labelText: "اسم العضو الجديد",
                            hintText: "الرجاء إدخال اسم العضو الجديد",
                            maxLines: 1,
                            validator: (value) {
                              return context
                                  .read<AddUserCubit>()
                                  .validateTxtFormField(
                                    value: value,
                                    errorHint: "الرجاء إدخال اسم العضو الجديد",
                                  );
                            },
                            controller: context
                                .read<AddUserCubit>()
                                .userNameController,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CustomTxtFormField(
                            controller: context
                                .read<AddUserCubit>()
                                .userPhoneController,
                            labelText: "رقم التليفون",
                            hintText: "الرجاء إدخال رقم التليفون",
                            maxLines: 1,
                            keyboardType: TextInputType.phone,

                            validator: (value) {
                              return context
                                  .read<AddUserCubit>()
                                  .validateTxtFormField(
                                    value: value,
                                    errorHint: "الرجاء إدخال رقم التليفون ",
                                  );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CustomButtom(
                            child: const CustomTxt(
                              title: "  إضافة العضو",
                              fontColor: Colors.white,
                            ),
                            onPressed: () {
                              context.read<AddUserCubit>().addNewUser(
                                context: context,
                              );
                            },
                          ),
                        ),

                        Expanded(flex: 4, child: SizedBox(height: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

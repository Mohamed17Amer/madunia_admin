import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_buttom.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt_form_field.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/owned_report/presentation/view_model/cubits/owned_report_cubit/owned_report_cubit.dart';

class AddNewOwnedItemScreenBody extends StatelessWidget {
  final AppUser user;
  const AddNewOwnedItemScreenBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: context.read<OwnedReportCubit>().addOwnedItemScreenKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SafeArea(child: SizedBox(height: 5)),
              const CustomAppBar(title: "إضافة عنصر جديد للمديونية"),

              const SizedBox(height: 20),
              CustomTxtFormField(
                labelText: "اسم البيان",
                hintText: "الرجاء إدخال اسم البيان",
                maxLines: 1,
                validator: (value) {
                  return context.read<OwnedReportCubit>().validateTxtFormField(
                        value: value,
                        errorHint: "الرجاء إدخال اسم البيان",
                      );
                },
                controller:
                    context.read<OwnedReportCubit>().ownedItemNameController,
              ),

              const SizedBox(height: 20),
              CustomTxtFormField(
                controller:
                    context.read<OwnedReportCubit>().ownedItemValueController,
                labelText: "القيمة بالجنيه",
                hintText: "الرجاء إدخال القيمة بالجنيه",
                maxLines: 1,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4), // Max 4 digits
                ],
                validator: (value) {
                  return context.read<OwnedReportCubit>().validateTxtFormField(
                        value: value,
                        errorHint: "الرجاء إدخال القيمة بالجنيه",
                      );
                },
              ),

              const SizedBox(height: 30),
              CustomButtom(
                child: const CustomTxt(
                    title: "إضافة العنصر", fontColor: Colors.white),
                onPressed: () async {
                  await context
                      .read<OwnedReportCubit>()
                      .addNewOwnedItem(context: context, user: user);
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

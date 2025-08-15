import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_buttom.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt_form_field.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubits/debit_report_cubit/debit_report_cubit.dart';

class AddNewDebitItemScreenBody extends StatelessWidget {
  final AppUser user;
  const AddNewDebitItemScreenBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: context.read<DebitReportCubit>().addDebitItemScreenKey,
        child: Column(
          children: [
            SafeArea(child: SizedBox(height: 5)),
            CustomAppBar(title: "إضافة عنصر جديد للمديونية"),

            SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: CustomTxtFormField(
                labelText: "اسم البيان",
                hintText: "الرجاء إدخال اسم البيان",
                maxLines: 1,
                validator: (value) {
                  return context.read<DebitReportCubit>().validateTxtFormField(
                    value: value,
                    errorHint: "الرجاء إدخال اسم البيان",
                  );
                },
                controller: context.read<DebitReportCubit>().debitItemNameController,
              ),
            ),
            Expanded(
              flex: 1,
              child: CustomTxtFormField(
                controller: context.read<DebitReportCubit>().debitItemValueController,
                labelText: "القيمة بالجنيه",
                hintText: "الرجاء إدخال القيمة بالجنيه",
                maxLines: 1,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,

                  //    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(4), // Max 4 digits
                ],

                validator: (value) {
                  return context.read<DebitReportCubit>().validateTxtFormField(
                    value: value,
                    errorHint: "الرجاء إدخال القيمة بالجنيه",
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: CustomButtom(
                child: const CustomTxt(title: "  إضافة العنصر", fontColor: Colors.white),
                onPressed: () async {
                  await context.read<DebitReportCubit>().addNewDebitItem(context: context, user: user);
                  Navigator.pop(context);
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

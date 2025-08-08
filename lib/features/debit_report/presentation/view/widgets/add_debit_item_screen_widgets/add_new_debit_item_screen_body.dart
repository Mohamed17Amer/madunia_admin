import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_buttom.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt_form_field.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubits/add_new_debit_item_cubit/add_debit_item_cubit.dart';

class AddNewDebitItemScreenBody extends StatelessWidget {
  const AddNewDebitItemScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: context.read<AddDebitItemCubit>().addDebitItemScreenKey,
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
                  return context.read<AddDebitItemCubit>().validateTxtFormField(
                    value: value,
                    errorHint: "الرجاء إدخال اسم البيان",
                  );
                },
                controller: context
                    .read<AddDebitItemCubit>()
                    .debitItemNameController,
              ),
            ),
            Expanded(
              flex: 1,
              child: CustomTxtFormField(
                controller: context
                    .read<AddDebitItemCubit>()
                    .debitItemValueController,
                labelText: "القيمة بالجنيه",
                hintText: "الرجاء إدخال القيمة بالجنيه",
                maxLines: 1,
                keyboardType: TextInputType.number,

                validator: (value) {
                  return context.read<AddDebitItemCubit>().validateTxtFormField(
                    value: value,
                    errorHint: "الرجاء إدخال القيمة بالجنيه",
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: CustomButtom(
                child: const CustomTxt(
                  title: "  إضافة العنصر",
                  fontColor: Colors.white,
                ),
                onPressed: () {
                  context.read<AddDebitItemCubit>().addNewDebitItem(
                    context: context,
                  );
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

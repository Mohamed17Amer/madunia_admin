import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/widgets/custom_icon.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubit/debit_report_cubit.dart';

class DebitReportItem extends StatelessWidget {
  const DebitReportItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebitReportCubit, DebitReportState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            //height: MediaQuery.of(context).size.height*.2,
            child: ListTile(
              title: const CustomTxt(
                title: "اسم البيان",
                fontColor: AppColors.debitReportItemTitleColor,
              ),
              subtitle: const CustomTxt(
                title:
                    "القيمة  "
                    "جنيه مصري",
                fontWeight: FontWeight.bold,
                fontColor: AppColors.debitReportItemSubTitleColor,
              ),
              leading: CustomIcon(onPressed: () {}, icon: Icons.check),
              trailing: CustomIcon(
                onPressed: () {
                  context.read<DebitReportCubit>().sendAlarmToUser(
                    context: context,
                  );
                },
                icon: Icons.add_alert_outlined,
              ),
            ),
          ),
        );
      },
    );
  }
}

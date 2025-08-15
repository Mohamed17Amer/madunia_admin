import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/widgets/custom_icon.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/debit_report/data/models/debit_item_model.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubits/debit_report_cubit/debit_report_cubit.dart';

class DebitReportItem extends StatelessWidget {
  final DebitItem? debitItem;
  final String userId;
  const DebitReportItem({
    super.key,
    required this.debitItem,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebitReportCubit, DebitReportState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            //height: MediaQuery.of(context).size.height*.2,
            child: ListTile(
              // debit item name
              title: CustomTxt(
                title: debitItem!.recordName,
                fontWeight: FontWeight.bold,
                fontColor: AppColors.debitReportItemTitleColor,
              ),

              // debit item value
              subtitle: CustomTxt(
                title: "${debitItem!.recordMoneyValue}جنيه مصري",
                fontWeight: FontWeight.bold,
                fontColor: AppColors.debitReportItemSubTitleColor,
              ),

              // debit item value status
              leading: CustomIcon(
                onPressed: () {
                  context.read<DebitReportCubit>().deleteDebitItem(
                    context: context,
                    debitItemId: debitItem!.id,
                    userId: userId,
                  );
                },
                icon: Icons.check,
              ),

              // send alert
              trailing: CustomIcon(
                onPressed: () {
                  context.read<DebitReportCubit>().sendAlarmToUser(
                    context: context,
                    debitItemId: debitItem!.id,
                    userId: userId,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/widgets/custom_icon.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/owned_report/data/models/owned_item_model.dart';
import 'package:madunia_admin/features/owned_report/presentation/view_model/cubits/owned_report_cubit/owned_report_cubit.dart';

class OwnedReportItem extends StatelessWidget {
  final OwnedItem? ownedItem;
  final String userId;
  const OwnedReportItem({
    super.key,
    required this.ownedItem,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnedReportCubit,OwnedReportState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            //height: MediaQuery.of(context).size.height*.2,
            child: ListTile(
              // owned item name
              title: CustomTxt(
                title: ownedItem!.recordName,
                fontWeight: FontWeight.bold,
                fontColor: AppColors.debitReportItemSubTitleColor,
              ),

              // owned item value
              subtitle: CustomTxt(
                title: "${ownedItem!.recordMoneyValue}جنيه مصري",
                fontWeight: FontWeight.bold,
                fontColor: AppColors.debitReportItemSubTitleColor,
              ),

              // owned item value status
              leading: CustomIcon(
                onPressed: () {
                  context.read<OwnedReportCubit>().deleteOwnedItem(
                    context: context,
                    ownedItemId: ownedItem!.id,
                    userId: userId,
                  );
                },
                icon: Icons.check,
              ),

              // send alert
              trailing: CustomIcon(
                onPressed: () {
                  context.read<OwnedReportCubit>().sendAlarmToUser(
                    context: context,
                    
                    ownedItemId: ownedItem!.id,
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

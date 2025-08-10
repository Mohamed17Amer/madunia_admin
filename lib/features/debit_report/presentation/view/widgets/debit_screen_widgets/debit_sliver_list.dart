import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/features/debit_report/data/models/debit_item_model.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/widgets/debit_screen_widgets/debit_report_item.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubits/debit_report_cubit/debit_report_cubit.dart';

class DebitSliverList extends StatelessWidget {
  final List<DebitItem> allUserItemDebits;
  const DebitSliverList({super.key,  required this.allUserItemDebits});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebitReportCubit, DebitReportState>(
      builder: (context, state) {
        return SliverList.separated(
          itemBuilder: (BuildContext context, int index) {
            return DebitReportItem(debitItem:  allUserItemDebits[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              thickness: 2,
              color: AppColors.bottomNavBarSelectedItemColor,
            );
          },
          itemCount: allUserItemDebits.length,
        );
      },
    );
  }
}

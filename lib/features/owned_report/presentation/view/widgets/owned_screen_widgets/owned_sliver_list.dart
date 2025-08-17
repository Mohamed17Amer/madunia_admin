import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/features/owned_report/data/models/owned_item_model.dart';
import 'package:madunia_admin/features/owned_report/presentation/view/widgets/owned_screen_widgets/owned_report_item.dart';
import 'package:madunia_admin/features/owned_report/presentation/view_model/cubits/owned_report_cubit/owned_report_cubit.dart';

class OwnedSliverList extends StatelessWidget {
  final List<OwnedItem> allUserItemsOwned;
  final String userId;
  const OwnedSliverList({super.key, required this.userId, required this.allUserItemsOwned});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnedReportCubit, OwnedReportState>(
      builder: (context, state) {
        return SliverList.separated(
          itemBuilder: (BuildContext context, int index) {
            return OwnedReportItem(ownedItem:  allUserItemsOwned[index], userId: userId);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              thickness: 2,
              color: AppColors.bottomNavBarSelectedItemColor,
            );
          },
          itemCount: allUserItemsOwned.length,
        );
      },
    );
  }
}

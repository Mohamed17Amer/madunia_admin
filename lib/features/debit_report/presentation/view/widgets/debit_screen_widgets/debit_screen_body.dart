import 'package:flutter/material.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/widgets/add_debit_item_screen_widgets/add_new_debit_item_button.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/widgets/debit_screen_widgets/debit_sliver_list.dart';

class DebitScreenBody extends StatelessWidget {
  const DebitScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          // safe area
          SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 5))),

          // app bar
          SliverToBoxAdapter(
            child: CustomAppBar(title: "كشف المديونية المستحقة عليه"),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),

          // add new debit item button
          SliverToBoxAdapter(child: AddNewDebitItemButton()),
          SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(
            child: Divider(
              thickness: 2.00,
              color: AppColors.bottomNavBarSelectedItemColor,
            ),
          ),

          // debit items list
          DebitSliverList(),
        ],
      ),
    );
  }
}

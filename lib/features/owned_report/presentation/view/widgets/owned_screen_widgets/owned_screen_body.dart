import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/owned_report/presentation/view/widgets/add_owned_item_screen_widgets/add_new_owned_item_button.dart';
import 'package:madunia_admin/features/owned_report/presentation/view/widgets/owned_screen_widgets/owned_sliver_list.dart';
import 'package:madunia_admin/features/owned_report/presentation/view_model/cubits/owned_report_cubit/owned_report_cubit.dart';

class OwnedScreenBody extends StatelessWidget {
  final AppUser user;
  const OwnedScreenBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          ..._drawHeader(),

          BlocConsumer<OwnedReportCubit, OwnedReportState>(
            listener: (context, state) {
              if (state is DeleteOwnedItemSuccess) {
                context.read<OwnedReportCubit>().getAllOwnedItems(
                  userId: user.id,
                );
              }
            },
            builder: (BuildContext context, OwnedReportState state) {
              return _drawBody(context, state);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _drawHeader() {
    return <Widget>[
      // safe area
      SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 5))),

      // app bar
      SliverToBoxAdapter(
        child: CustomAppBar(title: "كشف المديونية المستحقة عليه"),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 20)),

      // add new owned item button
      SliverToBoxAdapter(child: AddNewOwnedItemButton(user: user)),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: Divider(
          thickness: 2.00,
          color: AppColors.bottomNavBarSelectedItemColor,
        ),
      ),
    ];
  }

  Widget _drawBody(BuildContext context, OwnedReportState state) {
    if (state is GetAllOwnedItemsSuccess) {
      if (state.allUserItemOwneds.isEmpty) {
        return SliverFillRemaining(
          child: Center(child: CustomTxt(title: "لم تتم إضافة عناصر بعد.")),
        );
      } else {
        return OwnedSliverList(
          allUserItemsOwned:state.allUserItemOwneds,
          userId: user.id,
        );
      }
    } else if (state is GetAllOwnedItemsFailure) {
      return SliverFillRemaining(child: Center(child: Text(state.errmesg)));
    } else {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }
}

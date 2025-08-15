import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/widgets/add_debit_item_screen_widgets/add_new_debit_item_button.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/widgets/debit_screen_widgets/debit_sliver_list.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubits/debit_report_cubit/debit_report_cubit.dart';

class DebitScreenBody extends StatelessWidget {
  final AppUser user;
  const DebitScreenBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          ..._drawHeader(),

          BlocConsumer<DebitReportCubit, DebitReportState>(
            listener: (context, state) {
              if (state is DeleteDebitItemSuccess) {
                context.read<DebitReportCubit>().getAllDebitItems(
                  userId: user.id,
                );
              }
            },
            builder: (BuildContext context, DebitReportState state) {
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

      // add new debit item button
      SliverToBoxAdapter(child: AddNewDebitItemButton(user: user)),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
        child: Divider(
          thickness: 2.00,
          color: AppColors.bottomNavBarSelectedItemColor,
        ),
      ),
    ];
  }

  Widget _drawBody(BuildContext context, DebitReportState state) {
    if (state is GetAllDebitItemsSuccess) {
      if (state.allUserItemDebits.isEmpty) {
        return SliverFillRemaining(
          child: Center(child: CustomTxt(title: "لم تتم إضافة عناصر بعد.")),
        );
      } else {
        return DebitSliverList(
          allUserItemDebits: state.allUserItemDebits,
          userId: user.id,
        );
      }
    } else if (state is GetAllDebitItemsFailure) {
      return SliverFillRemaining(child: Center(child: Text(state.errmesg)));
    } else {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }
}

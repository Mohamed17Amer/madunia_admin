import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/core/utils/router/app_screens.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_icon.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/widgets/debit_sliver_list.dart';
import 'package:madunia_admin/features/debit_report/presentation/view_model/cubit/debit_report_cubit.dart';

class DebitScreen extends StatelessWidget {
  const DebitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DebitReportCubit(),
      child: BlocBuilder<DebitReportCubit, DebitReportState>(
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.homeGradientColorsList,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SafeArea(child: SizedBox(height: 5)),
                      ),
                      SliverToBoxAdapter(
                        child: CustomAppBar(
                          title: "كشف المديونية المستحقة عليه",
                        ),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 20)),
                      SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                                          GoRouter.of(context).push(AppScreens.addNewDebitItemScreen);

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomIcon(
                                icon: Icons.add_circle_outline_rounded,
                                color: AppColors.homeAppBarIconsBackgroundColor,
                              ),
                              CustomTxt(title: "أضف عنصرًا جديدًا للمديونية"),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 10)),

                      SliverToBoxAdapter(
                        child: Divider(
                          thickness: 2.00,
                          color: AppColors.bottomNavBarSelectedItemColor,
                        ),
                      ),

                      DebitSliverList(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

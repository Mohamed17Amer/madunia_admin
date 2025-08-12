import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/features/app/presentation/view/widgets/custom_bottom_nav_bar.dart';
import 'package:madunia_admin/features/app/presentation/view_model/cubit/app_cubit.dart';

class StartingScreen extends StatefulWidget {
  final index;
  const StartingScreen({super.key, this.index});

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  AppCubit appCubit = AppCubit();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: Stack(
          // for background and body
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.homeGradientColorsList,
                ),
              ),

              child: BlocBuilder<AppCubit, AppState>(
                builder: (context, state) {
                  return AppCubit.pagesViews[widget.index?? AppCubit.currentIndex];
                },
              ),
            ),

            // for nav bar
            CustomBottomNavBar(),
          ],
        ),
      ),
    );
  }
}

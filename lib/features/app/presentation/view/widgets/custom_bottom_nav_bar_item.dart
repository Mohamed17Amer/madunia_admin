import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/features/app/presentation/view_model/cubit/app_cubit.dart';

class CustomBottomNavBarItem extends StatelessWidget {
  const CustomBottomNavBarItem({
    super.key,
    required this.pageIcon,
    this.pageName,
    required this.pageIndex,
  });
  final IconData pageIcon;
  final String? pageName;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return CircleAvatar(
          radius: 20,
          backgroundColor: AppCubit.currentIndex == pageIndex
              ? AppColors.bottomNavBarSelectedItemColor
              : Colors.transparent,
          child: IconButton(
            onPressed: () {
              context.read<AppCubit>().changeBottomNavBarIndex(pageIndex);
            },
            icon: Icon(pageIcon, size: 20, color: Colors.black),
          ),
        );
      },
    );
  }
}

import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:madunia_admin/features/all_users/presentation/view/pages/all_users_screen.dart';
import 'package:madunia_admin/features/app/presentation/view/widgets/custom_bottom_nav_bar_item.dart';
import 'package:madunia_admin/features/instructions/presentation/view/pages/annimated_instructions_screen.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view/pages/manipulate_users_screen.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static int currentIndex = 0;
  static final List<CustomBottomNavBarItem> bottomNavBarItems = [
    CustomBottomNavBarItem(
      pageIcon: Icons.home_outlined,
      pageName: 'Home',
      pageIndex: 0,
    ),
    CustomBottomNavBarItem(
      pageIcon: Icons.money,
      pageName: 'Debit Report',
      pageIndex: 1,
    ),
    CustomBottomNavBarItem(
      pageIcon: Icons.home_repair_service,
      pageName: 'Repair Request',
      pageIndex: 2,
    ),
    CustomBottomNavBarItem(
      pageIcon: Icons.integration_instructions,
      pageName: 'Sustainable instructions',
      pageIndex: 3,
    ),
  ];

  static final List<Widget> pagesViews = [
    AllUsersScreen(),
    ManipulateUsersScreen(),
    AllUsersScreen(),
    AnimatedInstructionsScreen(),
  ];

  void changeBottomNavBarIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState(index));
  }
}

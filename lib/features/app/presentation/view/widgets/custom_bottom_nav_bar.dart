import 'package:flutter/material.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';
import 'package:madunia_admin/features/app/presentation/view_model/cubit/app_cubit.dart';
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0), // space from bottom
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.bottomNavBarBackgroundColor,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: AppCubit.bottomNavBarItems,
            /*
            children: [
              CustomBottomNavBarItem(
                pageIcon: Icons.home_outlined,
                pageName: 'Home',
                pageIndex: 0,
              ),
              CustomBottomNavBarItem(
                pageIcon: Icons.video_call_outlined,
                pageName: 'Videos',
                pageIndex: 1,
              ),
              CustomBottomNavBarItem(
                pageIcon: Icons.video_library_outlined,
                pageName: 'Youtube',
                pageIndex: 2,
              ),
              CustomBottomNavBarItem(
                pageIcon: Icons.book_outlined,
                pageName: 'Books',
                pageIndex: 3,
              ),
            ],
            */
          ),
        ),
      ),
    );
  }

  /*
  Widget _navItem({required IconData icon, required int index}) {
    final isActive = index;
    return GestureDetector(
      onTap: () {
        
      },
      child: Icon(
        icon,
        size: 28,
       // color: isActive ? Colors.deepPurple : Colors.grey,
      ),
    );
  }

  */
}

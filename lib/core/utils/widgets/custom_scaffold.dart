import 'package:flutter/material.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';

class CustomScaffold extends StatelessWidget {
  Widget body;
  Widget? floatingActionButton;
  CustomScaffold({super.key, required this.body, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
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

          child: body,
        ),

        floatingActionButton:floatingActionButton ,
      ),
    );
  }
}

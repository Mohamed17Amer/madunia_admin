import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madunia_admin/core/utils/colors/app_colors.dart';

class CustomTxtFormField extends StatelessWidget {
  // You can add properties here if needed, like controller, decoration, etc.
  // For example:
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;


  const CustomTxtFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validator,

    this.keyboardType,
    this.inputFormatters,

    this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 18),

        focusColor: AppColors.customAppBarTitleColor,

        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.debitReportItemTitleColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.homePlayShortsIconColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.debitReportItemTitleColor),
        ),

        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType:keyboardType ,
      inputFormatters: inputFormatters,
    );
  }
}

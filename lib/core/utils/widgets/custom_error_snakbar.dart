import 'package:flutter/material.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';

class CustomErrorSnakbar {
  final String errMessage;
  final BuildContext context;
  final Color? color;

  CustomErrorSnakbar({
    required this.errMessage,
    required this.context,
    this.color,
  }) {
    buildErrorWidget(errMessage, context, color: color);
  }

  buildErrorWidget(String errMessage, BuildContext context, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomTxt(title: errMessage),
        backgroundColor: color ?? Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}

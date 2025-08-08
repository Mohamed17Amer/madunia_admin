import 'package:flutter/material.dart';

class CustomTxt extends StatelessWidget {
  final String title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? fontColor;

  const CustomTxt({
    super.key,
    required this.title,
    this.fontSize,
    this.fontWeight,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize ?? 24,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: fontColor,
        textBaseline: TextBaseline.alphabetic,
        wordSpacing: 0.1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

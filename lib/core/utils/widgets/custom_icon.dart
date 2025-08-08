import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  const CustomIcon({super.key, required this.icon, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: Icon(icon, size: 30, color: color?? Colors.black,));
  }
}

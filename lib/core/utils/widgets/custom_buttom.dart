import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  void Function()? onPressed;
  Widget? child;

  CustomButtom({super.key, this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Optional: customize color
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40), // Makes it oval
        ),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: child,
    );
  }
}

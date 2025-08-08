import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double? r1;
  final double? r2;
  ImageProvider<Object>? backgroundImage;

  CustomCircleAvatar({super.key, this.r1, this.r2, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: r1 ?? 40,
      backgroundColor: Colors.deepPurple,
      child: CircleAvatar(
        radius: r2 ?? 30,
        backgroundImage:
            backgroundImage ??
            AssetImage('assets/images/shorts_place_holder.png'),
      ),
    );
  }
}

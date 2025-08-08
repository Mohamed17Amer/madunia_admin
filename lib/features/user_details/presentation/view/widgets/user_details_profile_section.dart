import 'package:flutter/material.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';

class UserDetailsProfileSection extends StatelessWidget {
  const UserDetailsProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.deepPurple,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/images/shorts_place_holder.png',
              ),
            ),
          ),

          const SizedBox(height: 5),
          const CustomTxt(title: 'name', fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}

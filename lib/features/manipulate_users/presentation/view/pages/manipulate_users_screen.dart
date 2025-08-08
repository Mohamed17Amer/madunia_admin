import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:madunia_admin/core/utils/router/app_screens.dart';
import 'package:madunia_admin/core/utils/widgets/custom_app_bar.dart';
import 'package:madunia_admin/core/utils/widgets/custom_buttom.dart';
import 'package:madunia_admin/core/utils/widgets/custom_txt.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view_model/cubit/manipulate_users_cubit/manipulate_users_cubit.dart';

class ManipulateUsersScreen extends StatelessWidget {
  const ManipulateUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManipulateUsersCubit(),
      child: BlocBuilder<ManipulateUsersCubit, ManipulateUsersState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SafeArea(child: SizedBox(height: 5))),
                SliverToBoxAdapter(child: CustomAppBar(title: "خدمات الأدمن")),

                SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height:500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomButtom(
                          onPressed: () {

              GoRouter.of(context).push(AppScreens.addNewUserScreen);

                          },
                          child: const CustomTxt(
                            title: "  إضافة عضو جديد",
                            fontColor: Colors.white,
                          ),
                        ),
                    
                        CustomButtom(
                          onPressed: () {},
                          child: const CustomTxt(
                            title: "  حذف عضو موجود",
                            fontColor: Colors.white,
                          ),
                        ),
                        CustomButtom(
                          onPressed: () {},
                          child: const CustomTxt(
                            title: "   تعديل بيانات عضو موجود",
                            fontColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

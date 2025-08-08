import 'package:go_router/go_router.dart';
import 'package:madunia_admin/core/utils/router/app_screens.dart';
import 'package:madunia_admin/features/add_debit_item/presentation/view/pages/add_debit_item_screen.dart';
import 'package:madunia_admin/features/all_users/presentation/view/pages/all_users_screen.dart';
import 'package:madunia_admin/features/app/presentation/view/pages/starting_screen.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/pages/debit_screen.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view/pages/add_new_user_screen.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view/pages/manipulate_users_screen.dart';
import 'package:madunia_admin/features/user_details/presentation/view/pages/user_details_screen.dart';
import 'package:madunia_admin/features/instructions/presentation/view/pages/annimated_instructions_screen.dart';

abstract class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: AppScreens.userDetailsScreen,
        builder: (context, state) {
          return UserDetailsScreen();
        },
      ),

      GoRoute(
        path: AppScreens.startingScreen,
        builder: (context, state) {
          return StartingScreen();
        },
      ),

      GoRoute(
        path: AppScreens.allUsersScreen,
        builder: (context, state) {
          return AllUsersScreen();
        },
      ),

      GoRoute(
        path: AppScreens.debitScreen,
        builder: (context, state) {
          return DebitScreen();
        },
      ),

      

      GoRoute(
        path: AppScreens.animatedInstructionsScreen,
        builder: (context, state) {
          return AnimatedInstructionsScreen();
        },
      ),

        GoRoute(
        path: AppScreens.addNewDebitItemScreen,
        builder: (context, state) {
          return AddDebitItemScreen();
        },
      ),
    
          GoRoute(
        path: AppScreens.manipulateUsersScreen,
        builder: (context, state) {
          return ManipulateUsersScreen();
        },
      ),
    
       GoRoute(
        path: AppScreens.addNewUserScreen,
        builder: (context, state) {
          return AddNewUserScreen();
        },
      ),
    ],
  );
}

import 'package:go_router/go_router.dart';
import 'package:madunia_admin/core/utils/router/app_screens.dart';
import 'package:madunia_admin/features/all_users/presentation/view/pages/all_users_screen.dart';
import 'package:madunia_admin/features/app/presentation/pages/starting_screen.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/pages/debit_screen.dart';
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
        path: AppScreens.repairRequestScreen,
        builder: (context, state) {
          return AllUsersScreen();
        },
      ),

      GoRoute(
        path: AppScreens.animatedInstructionsScreen,
        builder: (context, state) {
          return AnimatedInstructionsScreen();
        },
      ),
    ],
  );
}

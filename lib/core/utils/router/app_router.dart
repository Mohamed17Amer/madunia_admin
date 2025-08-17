import 'package:go_router/go_router.dart';
import 'package:madunia_admin/core/utils/router/app_screens.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/pages/add_debit_item_screen.dart';
import 'package:madunia_admin/features/all_users/presentation/view/pages/all_users_screen.dart';
import 'package:madunia_admin/features/app/presentation/view/pages/starting_screen.dart';
import 'package:madunia_admin/features/debit_report/presentation/view/pages/debit_screen.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view/pages/add_new_user_screen.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view/pages/delete_user_screen.dart';
import 'package:madunia_admin/features/manipulate_users/presentation/view/pages/manipulate_users_screen.dart';
import 'package:madunia_admin/features/monthly_debits/presentation/view/pages/all_users_screen.dart';
import 'package:madunia_admin/features/owned_report/presentation/view/pages/add_owned_item_screen.dart';
import 'package:madunia_admin/features/owned_report/presentation/view/pages/owned_screen.dart';
import 'package:madunia_admin/features/user_details/presentation/view/pages/user_details_screen.dart';
import 'package:madunia_admin/features/instructions/presentation/view/pages/annimated_instructions_screen.dart';

abstract class AppRouter {
  static final router = GoRouter(
    routes: [
      // starting screen
      GoRoute(
        path: AppScreens.startingScreen,
        builder: (context, state) {
          return StartingScreen();
        },
      ),

      /// ********************************************************************************************

      // all users screen
      GoRoute(
        path: AppScreens.allUsersScreen,
        builder: (context, state) {
          return AllUsersScreen();
        },
      ),

      // user details
      GoRoute(
        path: AppScreens.userDetailsScreen,

        builder: (context, state) {
          final user = state.extra as AppUser;

          return UserDetailsScreen(user: user);
        },
      ),

      // debit items screen
      GoRoute(
        path: AppScreens.debitScreen,
        builder: (context, state) {
          final user = state.extra as AppUser;

          return DebitScreen(user: user);
        },
      ),

      // add new debit item
      GoRoute(
        path: AppScreens.addNewDebitItemScreen,
        builder: (context, state) {
          final user = state.extra as AppUser;
          return AddDebitItemScreen(user: user);
        },
      ),

      /// ********************************************************************************************

      // admin screen
      GoRoute(
        path: AppScreens.manipulateUsersScreen,
        builder: (context, state) {
          return ManipulateUsersScreen();
        },
      ),

      // add user screen
      GoRoute(
        path: AppScreens.addNewUserScreen,
        builder: (context, state) {
          return AddNewUserScreen();
        },
      ),

      // delete user screen
      GoRoute(
        path: AppScreens.deleteUserScreen,
        builder: (context, state) {
          return DeleteUserScreen();
        },
      ),

      /// ********************************************************************************************

      // instructions screen
      GoRoute(
        path: AppScreens.animatedInstructionsScreen,
        builder: (context, state) {
          return AnimatedInstructionsScreen();
        },
      ),
  
  
  
  
  
  
     // owned items screen
      GoRoute(
        path: AppScreens.ownedScreen,
        builder: (context, state) {
          final user = state.extra as AppUser;

          return OwnedScreen(user: user);
        },
      ),

         // add new owned item
      GoRoute(
        path: AppScreens.addNewOwnedItemScreen,
        builder: (context, state) {
          final user = state.extra as AppUser;
          return AddOwnedItemScreen(user: user);
        },
      ),


     // all users screen
      GoRoute(
        path: AppScreens.allUsersFormonthlyTransactionsScreen,
        builder: (context, state) {
          return AllUsersForMonthlyTransactionsScreen();
        },
      ),
  
  
  
  
  
    ],
  );





  
}

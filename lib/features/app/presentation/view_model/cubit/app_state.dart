part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

final class AppChangeBottomNavBarState extends AppState {
  AppChangeBottomNavBarState(this.index) {
    log("selected index is  $index");
  }
  final int index;
}

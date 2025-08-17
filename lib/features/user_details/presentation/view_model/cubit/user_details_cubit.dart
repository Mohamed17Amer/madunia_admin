import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:madunia_admin/core/services/firebase_sevices.dart';
import 'package:madunia_admin/core/utils/events/event_bus.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(UserDetailsInitial()) {
    eventBus.on<UserDataUpdatedEvent>().listen((event) => getTotalMoney(userId: event.userId));
  
  }

  FirestoreService firestoreService = FirestoreService();

  final userPaymentDetailsCategoriess = ["عليه", "له"];

  final userOtherDrtailsCategoriess = [" البلاغات والطلبات"];

  getTotalMoney({required String userId}) async {
    final List<double> total = [0, 0];
    total[0] = await firestoreService.getTotalDebitMoney(userId);
    total[1] = await firestoreService.getTotalOwnedMoney(userId);
    emit(GetTotalMoneySuccess(total: total));
    log('Total Money is $total', name: 'getTotalMoney');
    return total;
  }


  @override
  Future<void> close() {
    log('', error: 'User Details Cubit is Closed');
    return super.close();
  }
}

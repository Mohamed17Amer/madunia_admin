import 'package:event_bus/event_bus.dart';
import 'package:madunia_admin/features/all_users/data/models/app_user_model.dart';

// Create a single EventBus instance accessible from anywhere
final EventBus eventBus = EventBus();

fireEvent(EventType event) {
  eventBus.fire(event);
}

listenToEven(dynamic func) {
  //  eventBus.on<EventType>().listen((event){
  //   return func;

  //   });
  // eventBus.on<UserDataUpdatedEvent>().listen((event) => getTotalMoney(userId: event.userId));
}

// Define the event

abstract class EventType {
  // EventBus event;
  // EventBus({required this.event});
}

class UserDataUpdatedEvent extends EventType {
  final String userId;
  UserDataUpdatedEvent(this.userId);
}

class AddNewUserEvent extends EventType {
  AddNewUserEvent();
}

class DeleteUserEvent extends EventType {
  DeleteUserEvent();
}
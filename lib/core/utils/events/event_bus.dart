import 'package:event_bus/event_bus.dart';

// Create a single EventBus instance accessible from anywhere
final EventBus eventBus = EventBus();
// Define the event
class UserDataUpdatedEvent {
  final String userId;
  UserDataUpdatedEvent(this.userId);
}

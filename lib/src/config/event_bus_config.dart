
import 'package:event_bus/event_bus.dart';
import 'package:get_arch_core/get_arch_core.dart';

@module
abstract class EventBusConfig{
  EventBus get eventBus => EventBus();
}
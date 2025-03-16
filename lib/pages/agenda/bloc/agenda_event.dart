// ignore_for_file: must_be_immutable

part of 'agenda_bloc.dart';

@immutable
abstract class StoreEvent {
  const StoreEvent();
}

class StoreInitialEvent extends StoreEvent {
  const StoreInitialEvent();
}

class StoreLoadingEvent extends StoreEvent {
  bool isLoading = true;
  StoreLoadingEvent(this.isLoading);
}

class StoreSuccessEvent extends StoreEvent {
  const StoreSuccessEvent();
}

class StoreLoadedEvent extends StoreEvent {
  const StoreLoadedEvent();
}

class StoreErrorEvent extends StoreEvent {
  const StoreErrorEvent();
}

class StoreGoNextEvent extends StoreEvent {
  const StoreGoNextEvent();
}

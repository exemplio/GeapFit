part of 'details_bloc.dart';

@immutable
abstract class DetailsEvent {
  const DetailsEvent();
}

class DetailsInitialEvent extends DetailsEvent {
  const DetailsInitialEvent();
}

class DetailsLoadingEvent extends DetailsEvent {
  const DetailsLoadingEvent();
}

class DetailsSuccessEvent extends DetailsEvent {
  const DetailsSuccessEvent();
}

class DetailsLoadedEvent extends DetailsEvent {
  const DetailsLoadedEvent();
}

class DetailsErrorEvent extends DetailsEvent {
  const DetailsErrorEvent();
}

class DetailsErrorNotListEvent extends DetailsEvent {
  const DetailsErrorNotListEvent();
}

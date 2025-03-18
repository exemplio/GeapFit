part of 'business_bloc.dart';

abstract class BusinessEvent {
  const BusinessEvent();
}

class BusinessInitialEvent extends BusinessEvent {
  BusinessInitialEvent();
}

class BusinessLoadedEvent extends BusinessEvent {
  BusinessLoadedEvent();
}

class BusinessLoadingEvent extends BusinessEvent {
  BusinessLoadingEvent();
}

class BusinessErrorEvent extends BusinessEvent {
  BusinessErrorEvent();
}

class BusinessRefreshEvent extends BusinessEvent {
  BusinessRefreshEvent();
}

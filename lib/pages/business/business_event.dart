// ignore_for_file: must_be_immutable

part of 'business_bloc.dart';

@immutable
abstract class BusinessEvent {
  const BusinessEvent();
}

class BusinessInitialEvent extends BusinessEvent {
  const BusinessInitialEvent();
}

class BusinessLoadingEvent extends BusinessEvent {
  bool isLoading = true;
  BusinessLoadingEvent(this.isLoading);
}

class BusinessSuccessEvent extends BusinessEvent {
  const BusinessSuccessEvent();
}

class BusinessLoadedEvent extends BusinessEvent {
  const BusinessLoadedEvent();
}

class BusinessErrorEvent extends BusinessEvent {
  const BusinessErrorEvent();
}

class BusinessGoNextEvent extends BusinessEvent {
  const BusinessGoNextEvent();
}

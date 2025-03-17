// ignore_for_file: must_be_immutable

part of 'message_bloc.dart';

@immutable
abstract class MessageEvent {
  const MessageEvent();
}

class MessageInitialEvent extends MessageEvent {
  const MessageInitialEvent();
}

class MessageLoadingEvent extends MessageEvent {
  bool isLoading = true;
  MessageLoadingEvent(this.isLoading);
}

class MessageSuccessEvent extends MessageEvent {
  const MessageSuccessEvent();
}

class MessageLoadedEvent extends MessageEvent {
  const MessageLoadedEvent();
}

class MessageErrorEvent extends MessageEvent {
  const MessageErrorEvent();
}

class MessageGoNextEvent extends MessageEvent {
  const MessageGoNextEvent();
}

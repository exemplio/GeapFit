part of 'message_bloc.dart';

abstract class MessageEvent {
  const MessageEvent();
}

class MessageInitialEvent extends MessageEvent {
  MessageInitialEvent();
}

class MessageLoadedEvent extends MessageEvent {
  MessageLoadedEvent();
}

class MessageLoadingEvent extends MessageEvent {
  MessageLoadingEvent();
}

class MessageErrorEvent extends MessageEvent {
  MessageErrorEvent();
}

class MessageRefreshEvent extends MessageEvent {
  MessageRefreshEvent();
}

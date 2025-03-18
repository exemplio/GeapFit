part of 'chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class ChatInitialEvent extends ChatEvent {
  ChatInitialEvent();
}

class ChatLoadedEvent extends ChatEvent {
  ChatLoadedEvent();
}

class ChatLoadingEvent extends ChatEvent {
  ChatLoadingEvent();
}

class ChatErrorEvent extends ChatEvent {
  ChatErrorEvent();
}

class ChatRefreshEvent extends ChatEvent {
  ChatRefreshEvent();
}

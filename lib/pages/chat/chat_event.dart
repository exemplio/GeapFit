// ignore_for_file: must_be_immutable

part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {
  const ChatEvent();
}

class ChatInitialEvent extends ChatEvent {
  const ChatInitialEvent();
}

class ChatLoadingEvent extends ChatEvent {
  bool isLoading = true;
  ChatLoadingEvent(this.isLoading);
}

class ChatSuccessEvent extends ChatEvent {
  const ChatSuccessEvent();
}

class ChatLoadedEvent extends ChatEvent {
  const ChatLoadedEvent();
}

class ChatErrorEvent extends ChatEvent {
  const ChatErrorEvent();
}

class ChatGoNextEvent extends ChatEvent {
  const ChatGoNextEvent();
}

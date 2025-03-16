part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ExecuteChatEvent extends ChatEvent {
  const ExecuteChatEvent();
}

class InitEvent extends ChatEvent {
  const InitEvent();
}

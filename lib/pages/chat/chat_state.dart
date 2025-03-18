// ignore_for_file: must_be_immutable

part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  List<Fields>? chat = [];
  ChatState({this.chat});

  @override
  List<Object?> get props => [];
}

class ChatInitialState extends ChatState {
  ChatInitialState({super.chat});
}

class ChatLoadingProductState extends ChatState {
  ChatLoadingProductState();
}

class ChatLoadedProductState extends ChatState {
  ChatLoadedProductState({super.chat});
}

class ChatErrorProductState extends ChatState {
  String? errorMessage;
  ChatErrorProductState({this.errorMessage = "Error al cargar los servicios"});
}

// ignore_for_file: must_be_immutable

part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  List<Fields>? message = [];
  MessageState({this.message});

  @override
  List<Object?> get props => [];
}

class MessageInitialState extends MessageState {
  MessageInitialState({super.message});
}

class MessageLoadingProductState extends MessageState {
  MessageLoadingProductState();
}

class MessageLoadedProductState extends MessageState {
  MessageLoadedProductState({super.message});
}

class MessageErrorProductState extends MessageState {
  String? errorMessage;
  MessageErrorProductState({
    this.errorMessage = "Error al cargar los servicios",
  });
}

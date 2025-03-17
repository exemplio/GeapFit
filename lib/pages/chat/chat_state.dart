// ignore_for_file: must_be_immutable

part of 'chat_bloc.dart';

@immutable
abstract class ChatState {
  InventoryModel? inventory;
  Results? consigned;
  List<String>? listTypes = [];
  ChatState({this.inventory, this.consigned, this.listTypes});
}

class ChatInitialState extends ChatState {
  ChatInitialState({super.inventory, super.consigned, super.listTypes});
}

class ChatLoadingState extends ChatState {
  ChatLoadingState({super.inventory, super.consigned, super.listTypes});
}

class ChatSuccessState extends ChatState {
  ChatSuccessState({super.inventory, super.consigned, super.listTypes});
}

class ChatLoadedState extends ChatState {
  ChatLoadedState({super.inventory, super.consigned, super.listTypes});
}

class ChatErrorState extends ChatState {
  String errorMessage;
  ChatErrorState({required this.errorMessage});
}

class ChatGoNextState extends ChatState {
  String next;
  Results? product;
  ChatGoNextState({required this.next, this.product, super.listTypes});
}

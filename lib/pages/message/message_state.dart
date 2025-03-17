// ignore_for_file: must_be_immutable

part of 'message_bloc.dart';

@immutable
abstract class MessageState {
  InventoryModel? inventory;
  Results? consigned;
  List<String>? listTypes = [];
  MessageState({this.inventory, this.consigned, this.listTypes});
}

class MessageInitialState extends MessageState {
  MessageInitialState({super.inventory, super.consigned, super.listTypes});
}

class MessageLoadingState extends MessageState {
  MessageLoadingState({super.inventory, super.consigned, super.listTypes});
}

class MessageSuccessState extends MessageState {
  MessageSuccessState({super.inventory, super.consigned, super.listTypes});
}

class MessageLoadedState extends MessageState {
  MessageLoadedState({super.inventory, super.consigned, super.listTypes});
}

class MessageErrorState extends MessageState {
  String errorMessage;
  MessageErrorState({required this.errorMessage});
}

class MessageGoNextState extends MessageState {
  String next;
  Results? product;
  MessageGoNextState({required this.next, this.product, super.listTypes});
}

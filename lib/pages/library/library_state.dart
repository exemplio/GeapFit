// ignore_for_file: must_be_immutable

part of 'library_bloc.dart';

@immutable
abstract class LibraryState {
  InventoryModel? inventory;
  Results? consigned;
  List<String>? listTypes = [];
  LibraryState({this.inventory, this.consigned, this.listTypes});
}

class LibraryInitialState extends LibraryState {
  LibraryInitialState({super.inventory, super.consigned, super.listTypes});
}

class LibraryLoadingState extends LibraryState {
  LibraryLoadingState({super.inventory, super.consigned, super.listTypes});
}

class LibrarySuccessState extends LibraryState {
  LibrarySuccessState({super.inventory, super.consigned, super.listTypes});
}

class LibraryLoadedState extends LibraryState {
  LibraryLoadedState({super.inventory, super.consigned, super.listTypes});
}

class LibraryErrorState extends LibraryState {
  String errorMessage;
  LibraryErrorState({required this.errorMessage});
}

class LibraryGoNextState extends LibraryState {
  String next;
  Results? product;
  LibraryGoNextState({required this.next, this.product, super.listTypes});
}

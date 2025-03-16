// ignore_for_file: must_be_immutable

part of 'agenda_bloc.dart';

@immutable
abstract class StoreState {
  InventoryModel? inventory;
  Results? consigned;
  List<String>? listTypes = [];
  StoreState({this.inventory, this.consigned, this.listTypes});
}

class StoreInitialState extends StoreState {
  StoreInitialState({super.inventory, super.consigned, super.listTypes});
}

class StoreLoadingState extends StoreState {
  StoreLoadingState({super.inventory, super.consigned, super.listTypes});
}

class StoreSuccessState extends StoreState {
  StoreSuccessState({super.inventory, super.consigned, super.listTypes});
}

class StoreLoadedState extends StoreState {
  StoreLoadedState({super.inventory, super.consigned, super.listTypes});
}

class StoreErrorState extends StoreState {
  String errorMessage;
  StoreErrorState({required this.errorMessage});
}

class StoreGoNextState extends StoreState {
  String next;
  Results? product;
  StoreGoNextState({required this.next, this.product, super.listTypes});
}

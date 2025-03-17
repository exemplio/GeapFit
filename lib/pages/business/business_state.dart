// ignore_for_file: must_be_immutable

part of 'business_bloc.dart';

@immutable
abstract class BusinessState {
  InventoryModel? inventory;
  Results? consigned;
  List<String>? listTypes = [];
  BusinessState({this.inventory, this.consigned, this.listTypes});
}

class BusinessInitialState extends BusinessState {
  BusinessInitialState({super.inventory, super.consigned, super.listTypes});
}

class BusinessLoadingState extends BusinessState {
  BusinessLoadingState({super.inventory, super.consigned, super.listTypes});
}

class BusinessSuccessState extends BusinessState {
  BusinessSuccessState({super.inventory, super.consigned, super.listTypes});
}

class BusinessLoadedState extends BusinessState {
  BusinessLoadedState({super.inventory, super.consigned, super.listTypes});
}

class BusinessErrorState extends BusinessState {
  String errorMessage;
  BusinessErrorState({required this.errorMessage});
}

class BusinessGoNextState extends BusinessState {
  String next;
  Results? product;
  BusinessGoNextState({required this.next, this.product, super.listTypes});
}

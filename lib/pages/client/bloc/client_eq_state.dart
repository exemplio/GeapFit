// ignore_for_file: must_be_immutable

part of 'client_eq_bloc.dart';

abstract class SalesEqState extends Equatable {
  List<ProductModel>? products = [];
  ProfileModel? profile;
  SalesEqState({this.products, this.profile});

  @override
  List<Object?> get props => [];
}
class SalesInitialState extends SalesEqState {
  SalesInitialState({super.products, super.profile});
}
class SalesLoadingProductState extends SalesEqState {
  SalesLoadingProductState();
}
class SalesLoadedProductState extends SalesEqState {
  SalesLoadedProductState({super.products, super.profile});
}
class SalesErrorProductState extends SalesEqState {
  String? errorMessage;
  SalesErrorProductState({this.errorMessage = "Error al cargar los servicios"});
}
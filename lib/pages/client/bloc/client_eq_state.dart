// ignore_for_file: must_be_immutable

part of 'client_eq_bloc.dart';

abstract class ClientEqState extends Equatable {
  List<ProductModel>? products = [];
  ProfileModel? profile;
  ClientEqState({this.products, this.profile});

  @override
  List<Object?> get props => [];
}

class ClientInitialState extends ClientEqState {
  ClientInitialState({super.products, super.profile});
}

class ClientLoadingProductState extends ClientEqState {
  ClientLoadingProductState();
}

class ClientLoadedProductState extends ClientEqState {
  ClientLoadedProductState({super.products, super.profile});
}

class ClientErrorProductState extends ClientEqState {
  String? errorMessage;
  ClientErrorProductState({
    this.errorMessage = "Error al cargar los servicios",
  });
}

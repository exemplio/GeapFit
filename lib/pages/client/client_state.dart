// ignore_for_file: must_be_immutable

part of 'client_bloc.dart';

abstract class ClientEqState extends Equatable {
  List<Fields>? usuarios = [];
  ClientEqState({this.usuarios});

  @override
  List<Object?> get props => [];
}

class ClientInitialState extends ClientEqState {
  ClientInitialState({super.usuarios});
}

class ClientLoadingProductState extends ClientEqState {
  ClientLoadingProductState();
}

class ClientLoadedProductState extends ClientEqState {
  ClientLoadedProductState({super.usuarios});
}

class ClientErrorProductState extends ClientEqState {
  String? errorMessage;
  ClientErrorProductState({
    this.errorMessage = "Error al cargar los servicios",
  });
}

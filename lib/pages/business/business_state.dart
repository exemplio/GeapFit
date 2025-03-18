// ignore_for_file: must_be_immutable

part of 'business_bloc.dart';

abstract class BusinessState extends Equatable {
  List<Fields>? business = [];
  BusinessState({this.business});

  @override
  List<Object?> get props => [];
}

class BusinessInitialState extends BusinessState {
  BusinessInitialState({super.business});
}

class BusinessLoadingProductState extends BusinessState {
  BusinessLoadingProductState();
}

class BusinessLoadedProductState extends BusinessState {
  BusinessLoadedProductState({super.business});
}

class BusinessErrorProductState extends BusinessState {
  String? errorMessage;
  BusinessErrorProductState({
    this.errorMessage = "Error al cargar los servicios",
  });
}

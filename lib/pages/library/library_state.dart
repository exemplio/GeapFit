// ignore_for_file: must_be_immutable

part of 'library_bloc.dart';

abstract class LibraryState extends Equatable {
  List<Fields>? library = [];
  LibraryState({this.library});

  @override
  List<Object?> get props => [];
}

class LibraryInitialState extends LibraryState {
  LibraryInitialState({super.library});
}

class LibraryLoadingProductState extends LibraryState {
  LibraryLoadingProductState();
}

class LibraryLoadedProductState extends LibraryState {
  LibraryLoadedProductState({super.library});
}

class LibraryErrorProductState extends LibraryState {
  String? errorMessage;
  LibraryErrorProductState({
    this.errorMessage = "Error al cargar los servicios",
  });
}

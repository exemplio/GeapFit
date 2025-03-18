// ignore_for_file: must_be_immutable

part of 'agenda_bloc.dart';

abstract class AgendaState extends Equatable {
  List<Fields>? agenda = [];
  AgendaState({this.agenda});

  @override
  List<Object?> get props => [];
}

class AgendaInitialState extends AgendaState {
  AgendaInitialState({super.agenda});
}

class AgendaLoadingProductState extends AgendaState {
  AgendaLoadingProductState();
}

class AgendaLoadedProductState extends AgendaState {
  AgendaLoadedProductState({super.agenda});
}

class AgendaErrorProductState extends AgendaState {
  String? errorMessage;
  AgendaErrorProductState({
    this.errorMessage = "Error al cargar los servicios",
  });
}

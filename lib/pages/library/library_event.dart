part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object> get props => [];
}

class ExecuteLibraryEvent extends LibraryEvent {
  const ExecuteLibraryEvent();
}

class InitEvent extends LibraryEvent {
  const InitEvent();
}

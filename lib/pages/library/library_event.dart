// ignore_for_file: must_be_immutable

part of 'library_bloc.dart';

@immutable
abstract class LibraryEvent {
  const LibraryEvent();
}

class LibraryInitialEvent extends LibraryEvent {
  const LibraryInitialEvent();
}

class LibraryLoadingEvent extends LibraryEvent {
  bool isLoading = true;
  LibraryLoadingEvent(this.isLoading);
}

class LibrarySuccessEvent extends LibraryEvent {
  const LibrarySuccessEvent();
}

class LibraryLoadedEvent extends LibraryEvent {
  const LibraryLoadedEvent();
}

class LibraryErrorEvent extends LibraryEvent {
  const LibraryErrorEvent();
}

class LibraryGoNextEvent extends LibraryEvent {
  const LibraryGoNextEvent();
}

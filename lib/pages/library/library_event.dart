part of 'library_bloc.dart';

abstract class LibraryEvent {
  const LibraryEvent();
}

class LibraryInitialEvent extends LibraryEvent {
  LibraryInitialEvent();
}

class LibraryLoadedEvent extends LibraryEvent {
  LibraryLoadedEvent();
}

class LibraryLoadingEvent extends LibraryEvent {
  LibraryLoadingEvent();
}

class LibraryErrorEvent extends LibraryEvent {
  LibraryErrorEvent();
}

class LibraryRefreshEvent extends LibraryEvent {
  LibraryRefreshEvent();
}

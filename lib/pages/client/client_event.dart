part of 'client_bloc.dart';

abstract class ClientEqEvent {
  const ClientEqEvent();
}

class ClientInitialEvent extends ClientEqEvent {
  ClientInitialEvent();
}

class ClientLoadedEvent extends ClientEqEvent {
  ClientLoadedEvent();
}

class ClientLoadingEvent extends ClientEqEvent {
  ClientLoadingEvent();
}

class ClientErrorEvent extends ClientEqEvent {
  ClientErrorEvent();
}

class ClientRefreshEvent extends ClientEqEvent {
  ClientRefreshEvent();
}

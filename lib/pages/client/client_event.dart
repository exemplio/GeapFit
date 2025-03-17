part of 'client_bloc.dart';

abstract class ClientEqEvent {
  const ClientEqEvent();
}

class ClientInitialEvent extends ClientEqEvent {
  ClientInitialEvent();
}

class ClientLoadedProductEvent extends ClientEqEvent {
  ClientLoadedProductEvent();
}

class ClientLoadingProductEvent extends ClientEqEvent {
  ClientLoadingProductEvent();
}

class ClientErrorProductEvent extends ClientEqEvent {
  ClientErrorProductEvent();
}

class ClientRefreshProductEvent extends ClientEqEvent {
  ClientRefreshProductEvent();
}

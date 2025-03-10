part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class ExecuteRegisterEvent extends RegisterEvent {
  const ExecuteRegisterEvent();
}

class InitEvent extends RegisterEvent {
  const InitEvent();
}

class RegisterInitialEvent extends RegisterEvent {
  const RegisterInitialEvent();
}

// class RegisterCleanEvent extends RegisterEvent {
//   RegisterCleanEvent();
// }
class RegisterLoadingEvent extends RegisterEvent {
  const RegisterLoadingEvent();
}

class RegisterLoadedEvent extends RegisterEvent {
  const RegisterLoadedEvent();
}

class RegisterSuccessEvent extends RegisterEvent {
  const RegisterSuccessEvent();
}

class RegisterErrorEvent extends RegisterEvent {
  final String errorMessage;

  const RegisterErrorEvent({
    required this.errorMessage,
  });
}

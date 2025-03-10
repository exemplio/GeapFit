// ignore_for_file: must_be_immutable

part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterInitialState extends RegisterState {
  const RegisterInitialState();
}

class RegisterLoadingState extends RegisterState {
  const RegisterLoadingState();
}

class RegisterSuccessState extends RegisterState {
  const RegisterSuccessState();
}

class RegisterCleanState extends RegisterState {
  const RegisterCleanState();
}

class RegisterLoadedState extends RegisterState {
  const RegisterLoadedState();
}

class RegisterErrorState extends RegisterState {
  String errorMessage;
  RegisterErrorState({required this.errorMessage});
}

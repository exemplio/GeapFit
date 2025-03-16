part of 'business_bloc.dart';

abstract class BusinessEvent extends Equatable {
  const BusinessEvent();

  @override
  List<Object> get props => [];
}

class ExecuteBusinessEvent extends BusinessEvent {
  const ExecuteBusinessEvent();
}

class InitEvent extends BusinessEvent {
  const InitEvent();
}

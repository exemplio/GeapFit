part of 'business_bloc.dart';

abstract class BusinessState extends Equatable {
  const BusinessState();

  @override
  List<Object> get props => [];
}

class BusinessInitial extends BusinessState {
  const BusinessInitial();
}

class GotoLoginState extends BusinessState {
  const GotoLoginState();
}

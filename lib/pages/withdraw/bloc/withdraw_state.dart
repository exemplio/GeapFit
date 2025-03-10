part of 'withdraw_bloc.dart';

@immutable
abstract class WithdrawState {
  const WithdrawState();
}

class WithdrawInitState extends WithdrawState {
  const WithdrawInitState();
}

class WithdrawReloadingState extends WithdrawState {
  final bool loaded;
  const WithdrawReloadingState(this.loaded);
}

class WithdrawLoadingState extends WithdrawState {
  const WithdrawLoadingState();
}

class WithdrawSuccessState extends WithdrawState {
  const WithdrawSuccessState();
}

class WithdrawErrorState extends WithdrawState {
  final String errorMsg;
  const WithdrawErrorState(this.errorMsg);
}

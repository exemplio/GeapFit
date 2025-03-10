part of 'withdraw_bloc.dart';

@immutable
abstract class WithdrawEvent {
  const WithdrawEvent();
}

class WithdrawInitEvent extends WithdrawEvent {
  const WithdrawInitEvent();
}

class WithdrawReloadingEvent extends WithdrawEvent {
  final bool loaded;
  const WithdrawReloadingEvent(this.loaded);
}

class WithdrawLoadingEvent extends WithdrawEvent {
  const WithdrawLoadingEvent();
}

class WithdrawSuccessEvent extends WithdrawEvent {
  const WithdrawSuccessEvent();
}

class WithdrawErrorEvent extends WithdrawEvent {
  final String errorMsg;
  const WithdrawErrorEvent(this.errorMsg);
}

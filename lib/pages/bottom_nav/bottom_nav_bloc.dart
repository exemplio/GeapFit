// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:geap_fit/services/cacheService.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

@injectable
class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  final _logger = Logger();

  // ignore: unused_field
  final Cache _cache;

  BottomNavBloc(this._cache) : super(BottomNavInitial()) {
    on<BottomNavEvent>((event, emit) {});
  }

  void init() {
    /* _subscription?.cancel();
    _subscription =
        _flutterPluginQpos.onPosListenerCalled!.listen(_solveQPOSModel);*/
  }

  @override
  Future<void> close() {
    // _subscription?.cancel();
    return super.close();
  }

  void _clearDevice() {}

  void disconnectDevice() async {
    try {
      _clearDevice();
    } catch (err) {
      _logger.e("DISCONNECT_TO_DEVICE", err);
    }
  }
}

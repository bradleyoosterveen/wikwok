import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class ConnectivityCubit extends WCubit<List<ConnectivityResult>?> {
  ConnectivityCubit(
    this._connectivity,
    this._exceptionHandler,
  ) : super(null);

  final Connectivity _connectivity;
  final ExceptionHandler _exceptionHandler;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future initialize() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      _exceptionHandler.handle(e);
      result = [ConnectivityResult.none];
    }

    return _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) => emit(result);

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}

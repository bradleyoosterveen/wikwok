import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class ConnectivityCubit extends WCubit<List<ConnectivityResult>?> {
  ConnectivityCubit(
    this._connectivity,
  ) : super(null);

  final Connectivity _connectivity;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future initialize() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) => emit(result);

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WCubit<T> extends Cubit<T> {
  WCubit(super.initialState);

  @override
  void onChange(Change<T> change) {
    if (kDebugMode) {
      developer.log(
        '$runtimeType ${change.currentState} -> ${change.nextState}',
        name: 'State change',
      );
    }
    super.onChange(change);
  }
}

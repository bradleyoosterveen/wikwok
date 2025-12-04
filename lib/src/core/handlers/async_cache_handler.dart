import 'dart:async';

import 'package:flutter/foundation.dart';

class AsyncCacheHandler {
  @visibleForTesting
  final Map<String, Completer> completers = {};

  Future<T> run<T>({
    required String key,
    required Future<T> Function() action,
    Duration duration = Duration.zero,
  }) async {
    if (completers.containsKey(key)) {
      return completers[key]!.future as Future<T>;
    }

    final completer = Completer<T>();
    completers[key] = completer;

    try {
      final result = await action();
      completer.complete(result);
    } catch (e) {
      completer.completeError(e);
    }

    if (duration > Duration.zero) {
      scheduleInvalidate(key, duration);
    } else {
      invalidate(key);
    }

    return completer.future;
  }

  void scheduleInvalidate(String key, Duration duration) =>
      Timer(duration, () => invalidate(key));

  void invalidate(String key) => completers.remove(key);

  void clear() => completers.clear();
}

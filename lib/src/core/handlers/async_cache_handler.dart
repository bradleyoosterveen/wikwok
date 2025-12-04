import 'dart:async';

import 'package:flutter/foundation.dart';

class AsyncCacheHandler {
  @visibleForTesting
  final Map<dynamic, Completer> completers = {};

  /// Runs the given asynchronous [action] and caches its future.
  ///
  /// This method ensures that for a given [key], the [action] is only
  /// executed once, even if `run` is called multiple times concurrently.
  /// Subsequent calls with the same [key] while the original action is
  /// still in progress will receive the same `Future` instance.
  ///
  /// - [key]: A unique key to identify the action.
  /// - [action]: The asynchronous function to execute, which returns a `Future<T>`.
  /// - [duration]: The `Duration` for which the result should be cached.
  ///   - If `Duration > zero`, the result is cached for the specified duration.
  ///   - If `Duration.zero` (the default), the cache is invalidated immediately
  ///     after the future completes, effectively only preventing concurrent
  ///     executions but not caching the result for future calls.
  Future<T> run<T>({
    required dynamic key,
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

  Timer scheduleInvalidate(dynamic key, Duration duration) =>
      Timer(duration, () => invalidate(key));

  void invalidate(dynamic key) => completers.remove(key);

  void clear() => completers.clear();
}

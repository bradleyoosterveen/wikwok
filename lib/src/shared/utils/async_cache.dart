import 'dart:async';

class AsyncCache {
  final Map<String, Completer> _completers = {};

  Future<T> handle<T>({
    required String key,
    required Future<T> Function() action,
  }) async {
    if (_completers.containsKey(key)) {
      return _completers[key]!.future as Future<T>;
    }

    final completer = Completer<T>();
    _completers[key] = completer;

    try {
      final result = await action();
      completer.complete(result);
    } catch (e) {
      completer.completeError(e);
      invalidate(key);
    }

    return completer.future;
  }

  void invalidate(String key) => _completers.remove(key);
}

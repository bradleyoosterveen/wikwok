import 'package:fpdart/fpdart.dart';

extension SafeMapLookup<K, V> on Map<K, V> {
  Either<SafeMapLookupError, T> get<T>(K key) => containsKey(key)
      ? Either.right(this[key] as T)
      : Either.left(.keyNotFound);

  Either<SafeMapLookupError, V> set(K key, V value) {
    this[key] = value;
    return Either.right(value);
  }

  Either<SafeMapLookupError, T> rem<T>(K key) {
    if (containsKey(key)) {
      final value = remove(key);
      return Either.right(value as T);
    }
    return Either.left(.keyNotFound);
  }
}

enum SafeMapLookupError {
  keyNotFound,
}

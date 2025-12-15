import 'package:fpdart/fpdart.dart';

extension SafeMapLookupExtension<K, V> on Map<K, V> {
  Either<SafeMapLookupError, T> get<T>(K key) {
    try {
      return containsKey(key)
          ? Either.right(this[key] as T)
          : Either.left(.keyNotFound);
    } on TypeError catch (_) {
      return Either.left(.typeMismatch);
    } catch (_) {
      return Either.left(.somethingWentWrong);
    }
  }

  Either<SafeMapLookupError, V> set(K key, V value) {
    try {
      return Either.right(this[key] = value);
    } on TypeError catch (_) {
      return Either.left(.typeMismatch);
    } catch (_) {
      return Either.left(.somethingWentWrong);
    }
  }

  Either<SafeMapLookupError, T> rem<T>(K key) {
    try {
      return containsKey(key)
          ? Either.right(remove(key) as T)
          : Either.left(.keyNotFound);
    } on TypeError catch (_) {
      return Either.left(.typeMismatch);
    } catch (_) {
      return Either.left(.somethingWentWrong);
    }
  }
}

enum SafeMapLookupError {
  keyNotFound,
  typeMismatch,
  somethingWentWrong,
}

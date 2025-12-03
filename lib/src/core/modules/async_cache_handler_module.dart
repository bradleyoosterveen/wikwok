import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';

@module
abstract class AsyncCacheHandlerModule {
  @singleton
  AsyncCacheHandler get asyncCacheHandler => AsyncCacheHandler();
}

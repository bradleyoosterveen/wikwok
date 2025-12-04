import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class LoggerModule {
  @singleton
  Logger get logger => Logger(
    printer: PrettyPrinter(methodCount: null),
    filter: _LogFilter(),
  );
}

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => kDebugMode;
}

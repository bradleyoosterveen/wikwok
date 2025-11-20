import 'dart:developer' as developer;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wikwok/app.dart';
import 'package:wikwok/core/exception_handler.dart';
import 'package:wikwok/core/inject.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  await initInject();

  FlutterNativeSplash.preserve(widgetsBinding: binding);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  WExceptionHandler().errorStream.listen((error) => developer.log(
        error,
        name: 'Exception',
      ));

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    WExceptionHandler().handleAnything(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    WExceptionHandler().handleAnything(error);
    return true;
  };

  runApp(const App());
}

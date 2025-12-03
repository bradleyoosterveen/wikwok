import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/presentation.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  await initInject();

  FlutterNativeSplash.preserve(widgetsBinding: binding);

  SystemChrome.setEnabledSystemUIMode(.edgeToEdge);

  runApp(const App());
}

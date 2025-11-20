import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'inject.config.dart';

final inject = GetIt.instance;

@InjectableInit()
void _() => inject.init();

Future<void> initInject() async => _();

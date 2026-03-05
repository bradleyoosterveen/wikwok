import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@injectable
@singleton
class NetworkConstants {
  NetworkConstants(
    this._packageInfo,
  );

  final PackageInfo _packageInfo;

  late final String userAgent =
      'WikWok/${_packageInfo.version} (https://github.com/bradleyoosterveen/wikwok)';
}

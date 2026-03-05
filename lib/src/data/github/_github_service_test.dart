// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.withData({});
  PackageInfo.setMockInitialValues(
    appName: 'WikWok (test)',
    packageName: 'WikWok',
    version: '0.0.1',
    buildNumber: '1',
    buildSignature: '',
  );

  await initInject();

  final service = inject<GithubService>();

  group('GithubService', () {
    group('fetchLatestRelease()', () {
      test('should return a map containing a tag_name', () async {
        final articleResult = await service.fetchLatestRelease().run();

        expect(articleResult.isRight(), true);

        final article = articleResult.toNullable()!;

        expect(article.containsKey('tag_name'), true);
      });
    });
  });
}

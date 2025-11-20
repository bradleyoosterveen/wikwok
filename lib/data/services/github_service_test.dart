// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:wikwok/core/inject.dart';
import 'package:wikwok/data/services/github_service.dart';

final _tags = ['integration'];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.withData({});

  await initInject();

  final service = inject<GithubService>();

  group('GithubService', () {
    group('fetchLatestRelease()', () {
      test('should return a map containing a tag_name', () async {
        final article = await service.fetchLatestRelease();

        expect(article.containsKey('tag_name'), true);
      }, tags: _tags);
    });
  });
}

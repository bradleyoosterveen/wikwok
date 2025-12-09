// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.withData({});

  await initInject();

  final service = inject<WikipediaService>();

  group('WikipediaService', () {
    group('fetchRandomArticle()', () {
      test('should return a map containing a pageid', () async {
        final articleResult = await service.fetchRandomArticle().run();

        expect(articleResult.isRight(), true);

        final article = articleResult.toNullable()!;

        expect(article.containsKey('pageid'), true);
      });

      test('should return a different article each time', () async {
        final titles = <String>[];
        const iterations = 3;

        Future<void> runTest() async {
          final articleResult = await service.fetchRandomArticle().run();

          switch (articleResult) {
            case Right(value: final article):
              final title = article['titles']['normalized'] as String;
              titles.add(title);
            case Left():
              return;
          }
        }

        await Future.wait(
          List.generate(iterations, (index) => runTest()),
        );

        expect(titles.length, iterations);
        expect(titles.toSet().length, iterations);
      });
    });

    group('fetchArticleByTitle()', () {
      test('should return a map containing a pageid', () async {
        final articleResult = await service
            .fetchArticleByTitle('Flutter')
            .run();

        expect(articleResult.isRight(), true);

        final article = articleResult.toNullable()!;

        expect(article.containsKey('pageid'), true);
      });

      test('should return an article with the given title', () async {
        final articleData = await service
            .fetchArticleByTitle('Flutter_(software)')
            .run();

        expect(articleData.isRight(), true);

        final article = articleData.toNullable()!;

        expect(article['titles']['normalized'], 'Flutter (software)');
      });
    });
  });
}

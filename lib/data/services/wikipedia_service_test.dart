// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wikwok/core/inject.dart';
import 'package:wikwok/data/services/wikipedia_service.dart';

final _tags = ['integration'];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initInject();

  final service = inject<WikipediaService>();

  group('WikipediaService', () {
    group('fetchRandomArticle()', () {
      test('should return a map containing a pageid', () async {
        final article = await service.fetchRandomArticle();

        expect(article.containsKey('pageid'), true);
      }, tags: _tags);

      test('should return a different article each time', () async {
        final article1 = await service.fetchRandomArticle();
        final article2 = await service.fetchRandomArticle();
        final article3 = await service.fetchRandomArticle();

        final pageid1 = article1['pageid'] as int;
        final pageid2 = article2['pageid'] as int;
        final pageid3 = article3['pageid'] as int;

        expect(pageid1, isNot(pageid2));
        expect(pageid2, isNot(pageid3));
        expect(pageid1, isNot(pageid3));
      }, tags: _tags);
    });

    group('fetchArticleByTitle()', () {
      test('should return a map containing a pageid', () async {
        final article = await service.fetchArticleByTitle('Flutter');

        expect(article.containsKey('pageid'), true);
      }, tags: _tags);

      test('should return an article with the given title', () async {
        final article = await service.fetchArticleByTitle('Flutter_(software)');

        expect(article['titles']['normalized'], 'Flutter (software)');
      }, tags: _tags);
    });
  });
}

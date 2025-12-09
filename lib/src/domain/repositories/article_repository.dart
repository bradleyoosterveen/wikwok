import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/data.dart';
import 'package:wikwok/domain.dart';

@singleton
@injectable
class ArticleRepository {
  ArticleRepository(
    this._preferences,
    this._settingsRepository,
    this._wikipediaService,
  );

  final SharedPreferencesAsync _preferences;
  final SettingsRepository _settingsRepository;
  final WikipediaService _wikipediaService;

  static const _maxCache = 99;
  static const _key = 'saved';

  final _articlePageMap = <int, Article>{};

  TaskEither<ArticleRepositoryError, Article> fetch(int currentIndex) =>
      TaskEither.Do(
        ($) async {
          final cachedArticleResult = _articlePageMap
              .get<Article>(currentIndex)
              .mapLeft(_toError);

          late final Article article;
          switch (cachedArticleResult) {
            case Right(value: final r):
              article = r;
            case Left():
              article = await $(_fetchRandomArticle());
          }

          _articlePageMap.set(currentIndex, article);

          await $(_prefetchNext(currentIndex));

          return article;
        },
      );

  TaskEither<ArticleRepositoryError, void> _prefetchNext(
    int currentIndex,
  ) => TaskEither.tryCatch(
    () async {
      final prefetchAmount =
          switch ((await _settingsRepository.get()).articlePrefetchRange) {
            .none => 0,
            .short => 1,
            .medium => 2,
            .large => 3,
          };

      for (var i = 0; i < prefetchAmount; i++) {
        unawaited(_fetchNextArticle(currentIndex + i).run());
      }

      return;
    },
    (e, _) => _toError(e),
  );

  TaskEither<ArticleRepositoryError, void> _fetchNextArticle(
    int index,
  ) => TaskEither.Do(
    ($) async {
      final nextIndex = index + 1;

      if (_articlePageMap.containsKey(nextIndex)) return;

      final nextArticle = await $(_fetchRandomArticle());

      $(
        TaskEither.fromEither(
          _articlePageMap.set(nextIndex, nextArticle).mapLeft(_toError),
        ),
      );

      if (_articlePageMap.length > _maxCache) {
        $(
          TaskEither.fromEither(
            _articlePageMap.rem(_articlePageMap.keys.first).mapLeft(_toError),
          ),
        );
      }

      return;
    },
  );

  Future<bool> isArticleSaved(String title) async {
    final saved = await getSavedArticles().run();

    return saved.fold((e) => false, (list) => list.contains(title));
  }

  Future<bool> saveArticle(String title) async {
    if (await isArticleSaved(title)) return true;

    final savedResult = await getSavedArticles().run();

    return savedResult.fold((e) => false, (list) async {
      list.add(title);

      await _preferences.setStringList(
        _key,
        list.map((e) => e.toString()).toList(),
      );

      return true;
    });
  }

  Future<bool> unsaveArticle(String title) async {
    if (!await isArticleSaved(title)) return false;

    final savedResult = await getSavedArticles().run();

    return savedResult.fold((e) => false, (list) async {
      list.remove(title);

      await _preferences.setStringList(
        _key,
        list.map((e) => e.toString()).toList(),
      );

      return true;
    });
  }

  TaskEither<ArticleRepositoryError, List<String>> getSavedArticles() =>
      TaskEither.tryCatch(() async {
        final saved = await _preferences.getStringList(_key);

        if (saved == null) {
          await _preferences.setStringList(_key, []);

          return [];
        }

        return saved;
      }, (e, _) => _toError(e));

  TaskEither<ArticleRepositoryError, Article> _fetchRandomArticle() =>
      _wikipediaService
          .fetchRandomArticle()
          .map((data) => Article.fromJson(data))
          .mapLeft(_toError);

  Future<Article> fetchArticleByTitle(String title) async {
    final data = await _wikipediaService.fetchArticleByTitle(title);

    return Article.fromJson(data);
  }
}

enum ArticleRepositoryError {
  unknown,
  somethingWentWrong,
  connectionError,
}

ArticleRepositoryError _toError(dynamic e) => switch (e) {
  ArticleRepositoryError e => e,
  WikipediaServiceError e => switch (e) {
    .unknown => .somethingWentWrong,
    .clientError => .somethingWentWrong,
    .timeout => .somethingWentWrong,
    .serverError => .somethingWentWrong,
    .connectionError => .connectionError,
  },
  SafeMapLookupError e => switch (e) {
    .keyNotFound => .somethingWentWrong,
  },
  _ => .unknown,
};

import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class SavedArticlesListCubit extends WCubit<SavedArticlesListState> {
  SavedArticlesListCubit(
    this._articleRepository,
    this._alertRepository,
  ) : super(const SavedArticlesListLoadingState());

  final ArticleRepository _articleRepository;
  final AlertRepository _alertRepository;
  StreamSubscription? _librarySubscription;

  Future<void> get() async {
    final savedResult = await _articleRepository.getSavedArticles().run();

    savedResult.fold(
      (e) => emit(const SavedArticlesListErrorState()),
      (list) async {
        if (list.isEmpty) {
          return emit(const SavedArticlesListEmptyState());
        }

        emit(SavedArticlesListLoadingState(current: 0, total: list.length));

        var current = 0;
        final result = await TaskEither.sequenceList(
          list
              .map(
                (e) => _articleRepository.fetchArticleByTitle(e).tapRight(
                  (_) {
                    current++;
                    emit(
                      SavedArticlesListLoadingState(
                        current: current,
                        total: list.length,
                      ),
                    );
                  },
                ),
              )
              .toList(),
        ).run();

        result.fold(
          ((e) => emit(const SavedArticlesListErrorState())),
          (r) async {
            emit(SavedArticlesListLoadedState(r));
          },
        );
      },
    );
  }

  Future<void> listen() async {
    _librarySubscription ??= _articleRepository.libraryStream.listen(
      (_) => unawaited(get()),
    );
  }

  Future<void> delete(Article article) async {
    final result = await _articleRepository.unsaveArticle(article.title);

    if (result) {
      await _alertRepository.saveAlert(
        Alert.info(
          l10n.library_updated,
          l10n.article_has_been_removed_from_your_library(article.title),
        ),
      );
    }
  }

  Future<void> deleteAll() async {
    final savedResult = await _articleRepository.getSavedArticles().run();

    savedResult.fold(
      (e) => emit(const SavedArticlesListErrorState()),
      (list) async {
        var allSucceeded = true;
        for (final title in list) {
          final result = await _articleRepository.unsaveArticle(title);

          if (!result) {
            allSucceeded = false;
            break;
          }
        }

        if (!allSucceeded) return;

        await _alertRepository.saveAlert(
          Alert.info(
            l10n.library_updated,
            l10n.all_articles_have_been_removed_from_your_library,
          ),
        );

        emit(const SavedArticlesListEmptyState());
      },
    );
  }

  @override
  Future<void> close() async {
    await _librarySubscription?.cancel();
    _librarySubscription = null;
    return super.close();
  }
}

abstract class SavedArticlesListState {
  const SavedArticlesListState();
}

class SavedArticlesListLoadingState extends SavedArticlesListState {
  final int current;
  final int total;

  const SavedArticlesListLoadingState({this.current = 0, this.total = 0});

  double get progress => total == 0 ? .0 : current / total;
}

class SavedArticlesListErrorState extends SavedArticlesListState {
  const SavedArticlesListErrorState();
}

class SavedArticlesListEmptyState extends SavedArticlesListState {
  const SavedArticlesListEmptyState();
}

class SavedArticlesListLoadedState extends SavedArticlesListState {
  final List<Article> articles;

  const SavedArticlesListLoadedState(this.articles);
}

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
  ) : super(const SavedArticlesListLoadingState());

  final ArticleRepository _articleRepository;

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

  Future<void> deleteAll() async {
    final savedResult = await _articleRepository.getSavedArticles().run();

    savedResult.fold(
      (e) => emit(const SavedArticlesListErrorState()),
      (list) async {
        for (final title in list) {
          await _articleRepository.unsaveArticle(title);
        }

        emit(const SavedArticlesListEmptyState());
      },
    );
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

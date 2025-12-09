import 'package:injectable/injectable.dart';
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
      (list) {
        if (list.isEmpty) {
          return emit(const SavedArticlesListEmptyState());
        }

        emit(SavedArticlesListLoadedState(list));
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
  const SavedArticlesListLoadingState();
}

class SavedArticlesListErrorState extends SavedArticlesListState {
  const SavedArticlesListErrorState();
}

class SavedArticlesListEmptyState extends SavedArticlesListState {
  const SavedArticlesListEmptyState();
}

class SavedArticlesListLoadedState extends SavedArticlesListState {
  final List<String> articleTitles;

  const SavedArticlesListLoadedState(this.articleTitles);
}

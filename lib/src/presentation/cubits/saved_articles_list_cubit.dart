import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

class SavedArticlesListCubit extends WCubit<SavedArticlesListState> {
  SavedArticlesListCubit() : super(const SavedArticlesListLoadingState());

  final _articleRepository = inject<ArticleRepository>();

  Future<void> get() async {
    final saved = await _articleRepository.getSavedArticles();

    if (saved.isEmpty) {
      return emit(const SavedArticlesListEmptyState());
    }

    emit(SavedArticlesListLoadedState(saved));
  }

  Future<void> deleteAll() async {
    try {
      final saved = await _articleRepository.getSavedArticles();

      for (var title in saved) {
        await _articleRepository.unsaveArticle(title);
      }

      emit(const SavedArticlesListEmptyState());
    } on Exception catch (e) {
      WExceptionHandler().handleException(e);
      emit(const SavedArticlesListErrorState());
    }
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

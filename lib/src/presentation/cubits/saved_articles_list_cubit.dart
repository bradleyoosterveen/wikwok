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
    try {
      final saved = await _articleRepository.getSavedArticles();

      if (saved.isEmpty) {
        return emit(const SavedArticlesListEmptyState());
      }

      emit(SavedArticlesListLoadedState(saved));
    } catch (_) {
      emit(const SavedArticlesListErrorState());
    }
  }

  Future<void> deleteAll() async {
    try {
      final saved = await _articleRepository.getSavedArticles();

      for (var title in saved) {
        await _articleRepository.unsaveArticle(title);
      }

      emit(const SavedArticlesListEmptyState());
    } catch (_) {
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

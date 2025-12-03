import 'package:injectable/injectable.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class SavedArticlesListItemCubit extends WCubit<SavedArticlesListItemState> {
  SavedArticlesListItemCubit(
    this._articleRepository,
  ) : super(const SavedArticlesListItemLoadingState());

  final ArticleRepository _articleRepository;

  Future<void> get(String title) async {
    emit(const SavedArticlesListItemLoadingState());

    try {
      final article = await _articleRepository.fetchArticleByTitle(title);

      emit(SavedArticlesListItemLoadedState(article));
    } catch (_) {
      emit(const SavedArticlesListItemErrorState());
    }
  }
}

abstract class SavedArticlesListItemState {
  const SavedArticlesListItemState();
}

class SavedArticlesListItemLoadingState extends SavedArticlesListItemState {
  const SavedArticlesListItemLoadingState();
}

class SavedArticlesListItemErrorState extends SavedArticlesListItemState {
  const SavedArticlesListItemErrorState();
}

class SavedArticlesListItemLoadedState extends SavedArticlesListItemState {
  final Article article;

  const SavedArticlesListItemLoadedState(this.article);
}

import 'package:injectable/injectable.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class SaveArticleCubit extends WCubit<SaveArticleState> {
  SaveArticleCubit(
    this._articleRepository,
  ) : super(const SaveArticleLoadingState());

  final ArticleRepository _articleRepository;

  Future<void> get(String title) async {
    emit(const SaveArticleLoadingState());

    try {
      final saved = await _articleRepository.isArticleSaved(title);

      emit(SaveArticleLoadedState(saved));
    } catch (_) {
      emit(const SaveArticleErrorState());
    }
  }

  Future<bool> toggle(String title) async {
    try {
      final saved = await _articleRepository.isArticleSaved(title);

      if (saved) {
        await _articleRepository.unsaveArticle(title);
      } else {
        await _articleRepository.saveArticle(title);
      }

      emit(SaveArticleLoadedState(!saved));

      return !saved;
    } catch (_) {
      emit(const SaveArticleErrorState());

      return false;
    }
  }
}

abstract class SaveArticleState {
  const SaveArticleState();
}

class SaveArticleLoadingState extends SaveArticleState {
  const SaveArticleLoadingState();
}

class SaveArticleLoadedState extends SaveArticleState {
  final bool saved;

  const SaveArticleLoadedState(this.saved);
}

class SaveArticleErrorState extends SaveArticleState {
  const SaveArticleErrorState();
}

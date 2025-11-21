import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

class SaveArticleCubit extends WCubit<SaveArticleState> {
  SaveArticleCubit() : super(const SaveArticleLoadingState());

  final _articleRepository = inject<ArticleRepository>();
  final _exceptionHandler = inject<ExceptionHandler>();

  Future<void> get(String title) async {
    emit(const SaveArticleLoadingState());

    try {
      final saved = await _articleRepository.isArticleSaved(title);

      emit(SaveArticleLoadedState(saved));
    } on Exception catch (e) {
      _exceptionHandler.handle(e);
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
    } on Exception catch (e) {
      _exceptionHandler.handle(e);
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

import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class ArticleCubit extends WCubit<ArticleState> {
  ArticleCubit(
    this._articleRepository,
    this._exceptionHandler,
  ) : super(const ArticleLoadingState());

  final ArticleRepository _articleRepository;
  final ExceptionHandler _exceptionHandler;

  Future<void> fetch(int currentIndex) async {
    emit(const ArticleLoadingState());

    try {
      final article = await _articleRepository.fetch(currentIndex);

      if (article == null) {
        return emit(const ArticleNotFoundState());
      }

      emit(ArticleLoadedState(article));
    } on Exception catch (e) {
      _exceptionHandler.handle(e);
      emit(const ArticleErrorState());
    }
  }
}

abstract class ArticleState {
  const ArticleState();
}

class ArticleLoadingState extends ArticleState {
  const ArticleLoadingState();
}

class ArticleLoadedState extends ArticleState {
  final Article article;

  const ArticleLoadedState(this.article);
}

class ArticleNotFoundState extends ArticleState {
  const ArticleNotFoundState();
}

class ArticleErrorState extends ArticleState {
  const ArticleErrorState();
}

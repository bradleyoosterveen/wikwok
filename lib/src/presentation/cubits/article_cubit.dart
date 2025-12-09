import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class ArticleCubit extends WCubit<ArticleState> {
  ArticleCubit(
    this._articleRepository,
  ) : super(const ArticleLoadingState());

  final ArticleRepository _articleRepository;

  Future<void> fetch(int currentIndex) async {
    final result = await _articleRepository.fetch(currentIndex).run();

    switch (result) {
      case Right(value: final r):
        emit(ArticleLoadedState(r));
      case Left(value: final l):
        emit(ArticleErrorState(l));
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
  final ArticleRepositoryError error;

  const ArticleErrorState(this.error);
}

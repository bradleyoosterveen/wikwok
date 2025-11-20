import 'dart:math';

import 'package:wikwok/core/exception_handler.dart';
import 'package:wikwok/domain/models/article.dart';
import 'package:wikwok/domain/repositories/article_repository.dart';
import 'package:wikwok/presentation/cubits/cubit.dart';

class SavedArticlesListItemCubit extends WCubit<SavedArticlesListItemState> {
  SavedArticlesListItemCubit()
      : super(const SavedArticlesListItemLoadingState());

  final _articleRepository = ArticleRepository();

  Future<void> get(String title) async {
    emit(const SavedArticlesListItemLoadingState());

    await Future.delayed(Duration(milliseconds: Random().nextInt(500) + 500));

    try {
      final article = await _articleRepository.fetchArticleByTitle(title);

      emit(SavedArticlesListItemLoadedState(article));
    } on Exception catch (e) {
      WExceptionHandler().handleException(e);
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

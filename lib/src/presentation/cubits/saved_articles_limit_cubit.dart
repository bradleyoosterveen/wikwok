import 'package:injectable/injectable.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class SavedArticlesLimitCubit extends WCubit<SavedArticlesLimitState> {
  SavedArticlesLimitCubit(
    this._libraryConstants,
    this._articleRepository,
  ) : super(const SavedArticlesLimitLoadingState());

  final LibraryConstants _libraryConstants;
  final ArticleRepository _articleRepository;

  Future<void> get() async {
    emit(const SavedArticlesLimitLoadingState());

    final limit = _libraryConstants.libraryLimit;
    final current = await _articleRepository.getSavedArticles().run();

    current.fold(
      (e) => emit(const SavedArticlesLimitErrorState()),
      (list) => emit(SavedArticlesLimitLoadedState(list.length, limit)),
    );
  }

  Future<void> listen() async =>
      _articleRepository.libraryStream.listen((_) => get());
}

abstract class SavedArticlesLimitState {
  const SavedArticlesLimitState();
}

class SavedArticlesLimitErrorState extends SavedArticlesLimitState {
  const SavedArticlesLimitErrorState();
}

class SavedArticlesLimitLoadingState extends SavedArticlesLimitState {
  const SavedArticlesLimitLoadingState();
}

class SavedArticlesLimitLoadedState extends SavedArticlesLimitState {
  final int current;
  final int limit;

  const SavedArticlesLimitLoadedState(this.current, this.limit);

  bool get hasReachedLimit => current >= limit;
}

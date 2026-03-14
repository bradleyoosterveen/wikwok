import 'package:injectable/injectable.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class SaveArticleCubit extends WCubit<SaveArticleState> {
  SaveArticleCubit(
    this._articleRepository,
    this._alertRepository,
  ) : super(const SaveArticleLoadingState());

  final ArticleRepository _articleRepository;
  final AlertRepository _alertRepository;

  Future<void> get(String title) async {
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

      final bool result;
      if (saved) {
        result = await _articleRepository.unsaveArticle(title);
      } else {
        result = await _articleRepository.saveArticle(title);
      }

      if (!result) return false;

      emit(SaveArticleLoadedState(!saved));

      if (!saved) {
        await _alertRepository.saveAlert(
          Alert.info(
            'Library updated',
            'Article "$title" has been added to your library.',
          ),
        );
      } else {
        await _alertRepository.saveAlert(
          Alert.info(
            'Library updated',
            'Article "$title" has been removed from your library.',
          ),
        );
      }

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

import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class CurrentVersionCubit extends WCubit<CurrentVersionState> {
  CurrentVersionCubit(
    this._versionRepository,
    this._exceptionHandler,
  ) : super(const CurrentVersionLoadingState());

  final VersionRepository _versionRepository;
  final ExceptionHandler _exceptionHandler;

  Future get() async {
    emit(const CurrentVersionLoadingState());

    try {
      final version = await _versionRepository.getCurrentVersion();

      emit(CurrentVersionLoadedState(version));
    } on Exception catch (e) {
      _exceptionHandler.handle(e);
      emit(const CurrentVersionErrorState());
    }
  }
}

abstract class CurrentVersionState {
  const CurrentVersionState();
}

class CurrentVersionLoadingState extends CurrentVersionState {
  const CurrentVersionLoadingState();
}

class CurrentVersionLoadedState extends CurrentVersionState {
  final Version version;

  const CurrentVersionLoadedState(this.version);
}

class CurrentVersionErrorState extends CurrentVersionState {
  const CurrentVersionErrorState();
}

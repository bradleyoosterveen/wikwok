import 'package:injectable/injectable.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class UpdateCubit extends WCubit<UpdateState> {
  UpdateCubit(
    this._versionRepository,
    this._exceptionHandler,
  ) : super(const UpdateLoadingState());

  final VersionRepository _versionRepository;
  final ExceptionHandler _exceptionHandler;

  Future get() async {
    emit(const UpdateLoadingState());

    try {
      final updateAvailable = await _versionRepository.isUpdateAvailable();

      if (!updateAvailable) return emit(const UpdateUnavailableState());

      final url = await _versionRepository.getUpdateUrl();
      final version = await _versionRepository.getLatestVersion();

      emit(UpdateAvailableState(url, version));
    } on Exception catch (e) {
      _exceptionHandler.handle(e);
      emit(const UpdateErrorState());
    }
  }
}

abstract class UpdateState {
  const UpdateState();
}

class UpdateLoadingState extends UpdateState {
  const UpdateLoadingState();
}

class UpdateAvailableState extends UpdateState {
  final String url;
  final Version version;

  const UpdateAvailableState(
    this.url,
    this.version,
  );
}

class UpdateUnavailableState extends UpdateState {
  const UpdateUnavailableState();
}

class UpdateErrorState extends UpdateState {
  const UpdateErrorState();
}

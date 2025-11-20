import 'package:wikwok/core/exception_handler.dart';
import 'package:wikwok/core/inject.dart';
import 'package:wikwok/domain/models/version.dart';
import 'package:wikwok/domain/repositories/version_repository.dart';
import 'package:wikwok/presentation/cubits/cubit.dart';

class UpdateCubit extends WCubit<UpdateState> {
  UpdateCubit() : super(const UpdateLoadingState());

  final _versionRepository = inject<VersionRepository>();

  Future get() async {
    emit(const UpdateLoadingState());

    try {
      final updateAvailable = await _versionRepository.isUpdateAvailable();

      if (!updateAvailable) return emit(const UpdateUnavailableState());

      final url = await _versionRepository.getUpdateUrl();
      final version = await _versionRepository.getLatestVersion();

      emit(UpdateAvailableState(url, version));
    } on Exception catch (e) {
      WExceptionHandler().handleException(e);
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

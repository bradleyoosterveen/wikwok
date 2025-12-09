import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class UpdateCubit extends WCubit<UpdateState> {
  UpdateCubit(
    this._versionRepository,
  ) : super(const UpdateLoadingState());

  final VersionRepository _versionRepository;

  Future<void> get() async {
    final result = await _versionRepository.isUpdateAvailable().run();

    result.match(
      (error) => emit(const UpdateErrorState()),
      (isUpdateAvailable) async {
        if (!isUpdateAvailable) {
          return emit(const UpdateUnavailableState());
        }

        final detailsResult =
            await TaskEither<VersionRepositoryError, (String, Version)>.Do(
              ($) async {
                final url = await $(_versionRepository.getUpdateUrl());
                final version = await $(_versionRepository.getLatestVersion());
                return (url, version);
              },
            ).run();

        detailsResult.match(
          (error) => emit(const UpdateErrorState()),
          (details) => emit(UpdateAvailableState(details.$1, details.$2)),
        );
      },
    );
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

  const UpdateAvailableState(this.url, this.version);
}

class UpdateUnavailableState extends UpdateState {
  const UpdateUnavailableState();
}

class UpdateErrorState extends UpdateState {
  const UpdateErrorState();
}

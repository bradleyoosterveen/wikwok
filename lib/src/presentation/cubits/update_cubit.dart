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

        final shouldSkipResult = await _versionRepository
            .shouldSkipUpdate()
            .run();

        shouldSkipResult.match(
          (error) => emit(const UpdateErrorState()),
          (shouldSkip) async {
            final detailsResult = await _getDetails().run();

            detailsResult.match(
              (error) => emit(const UpdateErrorState()),
              (details) {
                if (shouldSkip) {
                  return emit(
                    UpdateSkippedState(UpdateViewModel(details.$1, details.$2)),
                  );
                }

                emit(
                  UpdateAvailableState(UpdateViewModel(details.$1, details.$2)),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> skip() async {
    final result = await _versionRepository.skipUpdate().run();

    result.match(
      (error) => emit(const UpdateErrorState()),
      (_) async {
        final detailsResult = await _getDetails().run();

        detailsResult.match(
          (error) => emit(const UpdateErrorState()),
          (details) => emit(
            UpdateSkippedState(UpdateViewModel(details.$1, details.$2)),
          ),
        );
      },
    );
  }

  TaskEither<VersionRepositoryError, (String, Version)> _getDetails() =>
      TaskEither<VersionRepositoryError, (String, Version)>.Do(
        ($) async {
          final url = await $(_versionRepository.getUpdateUrl());
          final version = await $(
            _versionRepository.getLatestVersion(),
          );
          return (url, version);
        },
      );
}

abstract class UpdateState {
  const UpdateState();
}

class UpdateLoadingState extends UpdateState {
  const UpdateLoadingState();
}

class UpdateAvailableState extends UpdateState {
  final UpdateViewModel viewModel;

  const UpdateAvailableState(this.viewModel);
}

class UpdateSkippedState extends UpdateState {
  final UpdateViewModel viewModel;
  const UpdateSkippedState(this.viewModel);
}

class UpdateUnavailableState extends UpdateState {
  const UpdateUnavailableState();
}

class UpdateErrorState extends UpdateState {
  const UpdateErrorState();
}

class UpdateViewModel {
  final String url;
  final Version version;

  const UpdateViewModel(this.url, this.version);
}

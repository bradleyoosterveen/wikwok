import 'package:injectable/injectable.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

@injectable
@singleton
class CurrentVersionCubit extends WCubit<CurrentVersionState> {
  CurrentVersionCubit(
    this._versionRepository,
  ) : super(const CurrentVersionLoadingState());

  final VersionRepository _versionRepository;

  Future<void> get() async {
    final result = await _versionRepository.getCurrentVersion().run();

    result.match(
      (error) => emit(const CurrentVersionErrorState()),
      (version) => emit(CurrentVersionLoadedState(version)),
    );
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

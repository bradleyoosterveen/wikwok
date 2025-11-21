import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

class CurrentVersionCubit extends WCubit<CurrentVersionState> {
  CurrentVersionCubit() : super(const CurrentVersionLoadingState());

  final _versionRepository = inject<VersionRepository>();

  Future get() async {
    emit(const CurrentVersionLoadingState());

    try {
      final version = await _versionRepository.getCurrentVersion();

      emit(CurrentVersionLoadedState(version));
    } on Exception catch (e) {
      WExceptionHandler().handleException(e);
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

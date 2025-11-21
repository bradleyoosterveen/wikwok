import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

class CurrentVersionCubit extends WCubit<CurrentVersionState> {
  CurrentVersionCubit() : super(const CurrentVersionLoadingState());

  final _versionRepository = inject<VersionRepository>();
  final _exceptionHandler = inject<ExceptionHandler>();

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

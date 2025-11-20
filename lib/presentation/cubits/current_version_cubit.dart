import 'package:wikwok/core/exception_handler.dart';
import 'package:wikwok/core/inject.dart';
import 'package:wikwok/domain/models/version.dart';
import 'package:wikwok/domain/repositories/version_repository.dart';
import 'package:wikwok/presentation/cubits/cubit.dart';

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

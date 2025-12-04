import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/data.dart';
import 'package:wikwok/domain.dart';

@singleton
@injectable
class VersionRepository {
  VersionRepository(this._githubService);

  final GithubService _githubService;

  TaskEither<VersionRepositoryError, Version> getCurrentVersion() =>
      TaskEither.tryCatch(() async {
        final packageInfo = await PackageInfo.fromPlatform();
        return Version.parse(packageInfo.version);
      }, (e, _) => _toError(e));

  TaskEither<VersionRepositoryError, Version> getLatestVersion() =>
      TaskEither.Do(
        ($) async {
          final data = await $(
            _githubService.fetchLatestRelease().mapLeft(_toError),
          );

          final tagName = await $(
            TaskEither.fromEither(
              data.get<String>('tag_name'),
            ).map((tag) => tag.substring(1)).mapLeft(_toError),
          );

          return await $(
            TaskEither.tryCatch(
              () async => .parse(tagName),
              (e, _) => _toError(e),
            ),
          );
        },
      );

  TaskEither<VersionRepositoryError, bool> isUpdateAvailable() => TaskEither.Do(
    ($) async {
      final currentVersion = await $(getCurrentVersion());
      final latestVersion = await $(getLatestVersion());

      return latestVersion.isNewerThan(currentVersion);
    },
  );

  TaskEither<VersionRepositoryError, String> getUpdateUrl() => TaskEither.Do(
    ($) async {
      final data = await $(
        _githubService.fetchLatestRelease().mapLeft(_toError),
      );

      return await $(
        TaskEither<VersionRepositoryError, String>.fromEither(
          data.get<String>('html_url').mapLeft(_toError),
        ),
      );
    },
  );
}

enum VersionRepositoryError {
  unknown,
  somethingWentWrong,
  connectionError,
}

VersionRepositoryError _toError(dynamic e) => switch (e) {
  VersionRepositoryError _ => e,
  GithubServiceError githubServiceError => switch (githubServiceError) {
    GithubServiceError.unknown => .somethingWentWrong,
    GithubServiceError.clientError => .somethingWentWrong,
    GithubServiceError.timeout => .somethingWentWrong,
    GithubServiceError.serverError => .somethingWentWrong,
    GithubServiceError.connectionError => .connectionError,
  },
  SafeMapLookupError _ => .somethingWentWrong,
  _ => .unknown,
};

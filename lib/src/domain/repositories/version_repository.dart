import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/data.dart';
import 'package:wikwok/domain.dart';

@singleton
@injectable
class VersionRepository {
  VersionRepository(
    this._preferences,
    this._githubService,
  );

  final SharedPreferencesAsync _preferences;
  final GithubService _githubService;

  final String _latestSkippedVersionKey = 'latest_skipped_version';

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

  TaskEither<VersionRepositoryError, void> skipUpdate() =>
      TaskEither.Do(($) async {
        final currentVersion = await $(getLatestVersion());

        await _preferences.setString(
          _latestSkippedVersionKey,
          currentVersion.toString(),
        );
      });

  TaskEither<VersionRepositoryError, bool> shouldSkipUpdate() =>
      TaskEither.Do(($) async {
        final latestVersion = await $(getLatestVersion());

        final latestSkippedVersionPure = await _preferences.getString(
          _latestSkippedVersionKey,
        );

        if (latestSkippedVersionPure == null) return false;

        final latestSkippedVersion = await $(
          TaskEither.tryCatch(
            () async => Version.parse(latestSkippedVersionPure),
            (e, _) => _toError(e),
          ),
        );

        if (latestVersion.isNewerThan(latestSkippedVersion)) {
          return false;
        }

        return true;
      });

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
  VersionRepositoryError e => e,
  GithubServiceError e => switch (e) {
    GithubServiceError.unknown => .somethingWentWrong,
    GithubServiceError.clientError => .somethingWentWrong,
    GithubServiceError.timeout => .somethingWentWrong,
    GithubServiceError.serverError => .somethingWentWrong,
    GithubServiceError.connectionError => .connectionError,
  },
  SafeMapLookupError _ => .somethingWentWrong,
  _ => .unknown,
};

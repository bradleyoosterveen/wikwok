// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:wikwok/_test/nice.mocks.dart';
import 'package:wikwok/data.dart';
import 'package:wikwok/domain.dart';

void main() async {
  late final MockSharedPreferencesAsync mockSharedPreferencesAsync;
  late final MockGithubService mockGithubService;
  late final MockPackageInfo mockPackageInfo;
  late final MockSettingsRepository mockSettingsRepository;

  late final VersionRepository versionRepository;

  setUpAll(() async {
    mockSharedPreferencesAsync = MockSharedPreferencesAsync();
    mockGithubService = MockGithubService();
    mockPackageInfo = MockPackageInfo();
    mockSettingsRepository = MockSettingsRepository();

    versionRepository = VersionRepository(
      mockSharedPreferencesAsync,
      mockGithubService,
      mockPackageInfo,
      mockSettingsRepository,
    );
  });

  provideDummy<TaskEither<GithubServiceError, Map<String, dynamic>>>(
    TaskEither.right({
      'tag_name': 'v1.0.0',
      'html_url': 'https://github.com/',
    }),
  );

  group('VersionRepository', () {
    group('shouldSkipUpdate()', () {
      setUp(() {
        when(mockSettingsRepository.get()).thenAnswer(
          (_) async => Settings.fromMap({
            Settings.versionUpdateLevelKey: VersionUpdateLevel.patch.index,
          }),
        );
      });

      test(
        'should return false when latest version is newer than latest skipped version',
        () async {
          when(mockPackageInfo.version).thenReturn('0.0.1');

          when(
            mockSharedPreferencesAsync.getString(
              VersionRepository.latestSkippedVersionKey,
            ),
          ).thenAnswer((_) async => '0.1.0');

          when(mockGithubService.fetchLatestRelease()).thenAnswer(
            (_) => TaskEither.right({
              'tag_name': 'v1.0.0',
              'html_url': 'https://github.com/',
            }),
          );

          final shouldSkipUpdateResult = await versionRepository
              .shouldSkipUpdate()
              .run();

          expect(shouldSkipUpdateResult.isRight(), true);

          final shouldSkipUpdate = shouldSkipUpdateResult.toNullable()!;

          expect(shouldSkipUpdate, false);
        },
      );
      test(
        'should return false when latest skipped version is not set',
        () async {
          when(mockPackageInfo.version).thenReturn('0.0.1');

          when(
            mockSharedPreferencesAsync.getString(
              VersionRepository.latestSkippedVersionKey,
            ),
          ).thenAnswer((_) async => null);

          when(mockGithubService.fetchLatestRelease()).thenAnswer(
            (_) => TaskEither.right({
              'tag_name': 'v1.0.0',
              'html_url': 'https://github.com/',
            }),
          );

          final shouldSkipUpdateResult = await versionRepository
              .shouldSkipUpdate()
              .run();

          expect(shouldSkipUpdateResult.isRight(), true);

          final shouldSkipUpdate = shouldSkipUpdateResult.toNullable()!;

          expect(shouldSkipUpdate, false);
        },
      );
      test(
        'should return true when latest version is older than or equal to the latest skipped version',
        () async {
          when(mockPackageInfo.version).thenReturn('0.0.1');

          when(
            mockSharedPreferencesAsync.getString(
              VersionRepository.latestSkippedVersionKey,
            ),
          ).thenAnswer((_) async => '1.0.0');

          when(mockGithubService.fetchLatestRelease()).thenAnswer(
            (_) => TaskEither.right({
              'tag_name': 'v1.0.0',
              'html_url': 'https://github.com/',
            }),
          );

          final shouldSkipUpdateResult = await versionRepository
              .shouldSkipUpdate()
              .run();

          expect(shouldSkipUpdateResult.isRight(), true);

          final shouldSkipUpdate = shouldSkipUpdateResult.toNullable()!;

          expect(shouldSkipUpdate, true);
        },
      );
      test(
        'should return an error when the stored latest skipped version is invalid',
        () async {
          when(mockPackageInfo.version).thenReturn('0.0.1');

          when(
            mockSharedPreferencesAsync.getString(
              VersionRepository.latestSkippedVersionKey,
            ),
          ).thenAnswer((_) async => 'invalid');

          when(mockGithubService.fetchLatestRelease()).thenAnswer(
            (_) => TaskEither.right({
              'tag_name': 'v1.0.0',
              'html_url': 'https://github.com/',
            }),
          );

          final shouldSkipUpdateResult = await versionRepository
              .shouldSkipUpdate()
              .run();

          expect(shouldSkipUpdateResult.isLeft(), true);

          final error = shouldSkipUpdateResult.getLeft().toNullable()!;

          expect(error, VersionRepositoryError.somethingWentWrong);
        },
      );
    });
  });
}

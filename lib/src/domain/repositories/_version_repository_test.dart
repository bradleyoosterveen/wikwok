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

  late final VersionRepository versionRepository;

  setUpAll(() async {
    mockSharedPreferencesAsync = MockSharedPreferencesAsync();
    mockGithubService = MockGithubService();

    versionRepository = VersionRepository(
      mockSharedPreferencesAsync,
      mockGithubService,
    );
  });

  provideDummy<TaskEither<GithubServiceError, Map<String, dynamic>>>(
    TaskEither.right({
      'tag_name': 'v1.0.0',
      'html_url': 'https://github.com/',
    }),
  );

  group('VersionRepository', () {
    group('skipUpdate()', () {
      test(
        'should update the latest skipped version when latest version is known',
        () async {
          when(mockGithubService.fetchLatestRelease()).thenAnswer(
            (_) => TaskEither.right({
              'tag_name': 'v1.0.0',
              'html_url': 'https://github.com/',
            }),
          );

          final skipUpdateResult = await versionRepository.skipUpdate().run();

          expect(skipUpdateResult.isRight(), true);
          verify(
            mockSharedPreferencesAsync.setString(
              VersionRepository.latestSkippedVersionKey,
              '1.0.0',
            ),
          );
        },
      );
      test(
        'should not update the latest skipped version when latest version is not known',
        () async {
          when(mockGithubService.fetchLatestRelease()).thenAnswer(
            (_) => TaskEither.left(GithubServiceError.connectionError),
          );

          final skipUpdateResult = await versionRepository.skipUpdate().run();

          expect(skipUpdateResult.isLeft(), true);
          verifyNever(
            mockSharedPreferencesAsync.setString(
              VersionRepository.latestSkippedVersionKey,
              any,
            ),
          );
        },
      );
    });
    group('shouldSkipUpdate()', () {
      test(
        'should return false when latest version is newer than latest skipped version',
        () async {
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

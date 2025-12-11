// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:wikwok/_test/nice.mocks.dart';
import 'package:wikwok/data.dart';
import 'package:wikwok/domain.dart';

void main() async {
  final mockSharedPreferencesAsync = MockSharedPreferencesAsync();
  final mockGithubService = MockGithubService();

  final versionRepository = VersionRepository(
    mockSharedPreferencesAsync,
    mockGithubService,
  );

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
  });
}

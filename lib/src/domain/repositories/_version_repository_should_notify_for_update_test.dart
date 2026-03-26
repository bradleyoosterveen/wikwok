// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:wikwok/_test/nice.mocks.dart';
import 'package:wikwok/data.dart';
import 'package:wikwok/domain.dart';

class _Case {
  final Version currentVersion;
  final Version latestVersion;
  final VersionUpdateLevel updateLevel;
  final bool expected;

  const _Case({
    required this.currentVersion,
    required this.latestVersion,
    required this.updateLevel,
    required this.expected,
  });
}

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
    group('shouldNotifyForUpdate()', () {
      final cases = <_Case>[
        _Case(
          currentVersion: Version.parse('1.0.0'),
          latestVersion: Version.parse('1.0.1'),
          updateLevel: VersionUpdateLevel.patch,
          expected: true,
        ),
        _Case(
          currentVersion: Version.parse('1.0.0'),
          latestVersion: Version.parse('1.1.0'),
          updateLevel: VersionUpdateLevel.patch,
          expected: true,
        ),
        _Case(
          currentVersion: Version.parse('1.0.0'),
          latestVersion: Version.parse('2.0.0'),
          updateLevel: VersionUpdateLevel.patch,
          expected: true,
        ),
        _Case(
          currentVersion: Version.parse('1.0.0'),
          latestVersion: Version.parse('1.0.1'),
          updateLevel: VersionUpdateLevel.minor,
          expected: false,
        ),
        _Case(
          currentVersion: Version.parse('1.0.0'),
          latestVersion: Version.parse('1.1.0'),
          updateLevel: VersionUpdateLevel.minor,
          expected: true,
        ),
        _Case(
          currentVersion: Version.parse('1.0.0'),
          latestVersion: Version.parse('2.0.0'),
          updateLevel: VersionUpdateLevel.minor,
          expected: true,
        ),
        _Case(
          currentVersion: Version.parse('1.0.0'),
          latestVersion: Version.parse('1.0.1'),
          updateLevel: VersionUpdateLevel.major,
          expected: false,
        ),
        _Case(
          currentVersion: Version.parse('1.0.0'),
          latestVersion: Version.parse('1.1.0'),
          updateLevel: VersionUpdateLevel.major,
          expected: false,
        ),
        _Case(
          currentVersion: Version.parse('1.0.0'),
          latestVersion: Version.parse('2.0.0'),
          updateLevel: VersionUpdateLevel.major,
          expected: true,
        ),
        _Case(
          currentVersion: Version.parse('2.0.0'),
          latestVersion: Version.parse('1.9.0'),
          updateLevel: VersionUpdateLevel.minor,
          expected: false,
        ),
      ];

      for (final case_ in cases) {
        test(
          '${case_.currentVersion} -> ${case_.latestVersion} (${case_.updateLevel}) should return ${case_.expected}',
          () {
            expect(
              versionRepository.shouldNotifyForUpdate(
                case_.currentVersion,
                case_.latestVersion,
                case_.updateLevel,
              ),
              case_.expected,
              reason:
                  'currentVersion: ${case_.currentVersion}, latestVersion: ${case_.latestVersion}, updateLevel: ${case_.updateLevel}',
            );
          },
        );
      }
    });
  });
}

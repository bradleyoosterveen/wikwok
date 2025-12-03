import 'package:injectable/injectable.dart';

@singleton
@injectable
class GithubServiceConfig {
  final String baseUrl = 'https://api.github.com/';

  String latestReleasePath() =>
      'repos/bradleyoosterveen/wikwok/releases/latest';
}

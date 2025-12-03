import 'package:injectable/injectable.dart';

@singleton
@injectable
class WikipediaServiceConfig {
  final String baseUrl = 'https://en.wikipedia.org/api/rest_v1/';

  String randomArticlePath() => 'page/random/summary';

  String articleByTitlePath(String title) => 'page/summary/$title';
}

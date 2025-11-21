import 'package:share_plus/share_plus.dart';

class Article {
  final int id;
  final String subtitle;
  final String title;
  final String content;
  final String thumbnailUrl;
  final String originalImageUrl;
  final String url;

  Article({
    required this.id,
    required this.subtitle,
    required this.title,
    required this.content,
    required this.thumbnailUrl,
    required this.originalImageUrl,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['pageid'] as int,
        subtitle: json['description'] as String,
        title: json['titles']['normalized'] as String,
        content: json['extract'] as String,
        thumbnailUrl: json['thumbnail']['source'] as String,
        originalImageUrl: json['originalimage']['source'] as String,
        url: json['content_urls']['mobile']['page'] as String,
      );

  void share() => SharePlus.instance.share(ShareParams(
        title: title,
        uri: Uri.parse(url),
      ));
}

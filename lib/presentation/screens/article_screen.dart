import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikwok/domain/models/article.dart';
import 'package:wikwok/domain/models/settings.dart';
import 'package:wikwok/presentation/cubits/connectivity_cubit.dart';
import 'package:wikwok/presentation/cubits/save_article_cubit.dart';
import 'package:wikwok/presentation/cubits/saved_articles_list_cubit.dart';
import 'package:wikwok/presentation/cubits/settings_cubit.dart';
import 'package:wikwok/presentation/widgets/banner.dart';
import 'package:wikwok/presentation/widgets/border.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen._({
    required this.article,
  });

  final Article article;

  static push(
    BuildContext context, {
    required Article article,
  }) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => SaveArticleCubit()),
            ],
            child: ArticleScreen._(
              article: article,
            ),
          ),
        ),
      );

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen>
    with TickerProviderStateMixin {
  late final _popoverController = FPopoverController(vsync: this);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SaveArticleCubit, SaveArticleState>(
          listener: (context, state) => switch (state) {
            SaveArticleLoadedState _ =>
              context.read<SavedArticlesListCubit>().get(),
            _ => {},
          },
        ),
      ],
      child: FScaffold(
        childPad: false,
        footer: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).systemGestureInsets.bottom,
            left: 24.0,
            right: 24.0,
            top: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FButton(
                onPress: () => launchUrl(
                  Uri.parse(widget.article.url),
                ),
                child: const Text('Visit'),
              ),
              const SizedBox(height: 16),
              FButton(
                style: FButtonStyle.outline(),
                onPress: () => widget.article.share(),
                child: const Text('Share'),
              ),
            ],
          ),
        ),
        header: FHeader.nested(
          prefixes: [
            FButton.icon(
              style: FButtonStyle.ghost(),
              child: const Icon(FIcons.arrowLeft),
              onPress: () => Navigator.pop(context),
            ),
          ],
          suffixes: [
            FPopoverMenu(
              popoverController: _popoverController,
              menuAnchor: Alignment.topRight,
              childAnchor: Alignment.bottomRight,
              menu: [
                FItemGroup(
                  children: [
                    FItem(
                      prefix: const Icon(FIcons.x),
                      title: const Text(
                        'Remove from library (permanent)',
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                      onPress: () {
                        context
                            .read<SaveArticleCubit>()
                            .toggle(widget.article.title);

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
              child: FButton.icon(
                style: FButtonStyle.ghost(),
                child: const Icon(FIcons.ellipsisVertical),
                onPress: () => _popoverController.show(),
              ),
            ),
          ],
        ),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  child: Builder(builder: (context) {
                    final shouldDownloadFullSizeImages = context.select(
                      (SettingsCubit settings) =>
                          settings.state.shouldDownloadFullSizeImages,
                    );

                    final hasWifi = context.select(
                          (ConnectivityCubit connectivity) => connectivity.state
                              ?.contains(ConnectivityResult.wifi),
                        ) ??
                        false;

                    final urlWifiOnly = hasWifi
                        ? widget.article.originalImageUrl
                        : widget.article.thumbnailUrl;

                    return WBanner(
                      shouldWrapInSafeArea: false,
                      src: switch (shouldDownloadFullSizeImages) {
                        ShouldDownloadFullSizeImages.yes =>
                          widget.article.originalImageUrl,
                        ShouldDownloadFullSizeImages.no =>
                          widget.article.thumbnailUrl,
                        _ => urlWifiOnly,
                      },
                    );
                  }),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FCard(
                      style: (style) => style.copyWith(
                        decoration: style.decoration.copyWith(
                          border: WBorder.zero,
                        ),
                      ),
                      title: Text(widget.article.title),
                      subtitle: Text(widget.article.subtitle),
                      child: Text(widget.article.content),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

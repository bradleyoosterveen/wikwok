import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({
    required this.index,
    super.key,
  });

  final int index;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => inject<ArticleCubit>()),
        BlocProvider(create: (context) => inject<SaveArticleCubit>()),
      ],
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<ArticleCubit, ArticleState>(
              listenWhen: (previous, current) =>
                  previous is ArticleLoadingState &&
                  current is! ArticleLoadingState,
              listener: (context, state) => FlutterNativeSplash.remove(),
            ),
            BlocListener<ArticleCubit, ArticleState>(
              listener: (context, state) => switch (state) {
                ArticleLoadedState state =>
                  context.read<SaveArticleCubit>().get(state.article.title),
                _ => {},
              },
            ),
          ],
          child: _View(index: widget.index),
        ),
      ),
    );
  }
}

class _View extends StatefulWidget {
  const _View({
    required this.index,
  });

  final int index;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> with TickerProviderStateMixin {
  late final _saveAnimationController = AnimationController(vsync: this);
  late final _unsaveAnimationController = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();

    context.read<ArticleCubit>().fetch(widget.index);
  }

  @override
  void dispose() {
    _saveAnimationController.dispose();
    _unsaveAnimationController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _saveAnimationController.stop();
    _unsaveAnimationController.stop();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (state) {
          ArticleLoadedState state => _content(state.article),
          ArticleErrorState _ => WErrorRetryWidget(
              title: 'Something went wrong fetching this article.',
              onRetry: () => context.read<ArticleCubit>().fetch(widget.index),
            ),
          _ => const WCircularProgress(),
        },
      ),
    );
  }

  Widget _content(Article article) => MultiBlocListener(
        listeners: [
          BlocListener<SavedArticlesListCubit, SavedArticlesListState>(
            listener: (context, state) => switch (state) {
              SavedArticlesListLoadedState _ =>
                context.read<SaveArticleCubit>().get(article.title),
              SavedArticlesListEmptyState _ =>
                context.read<SaveArticleCubit>().get(article.title),
              _ => {},
            },
          ),
        ],
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onDoubleTap: () async {
                  final saved = await context
                      .read<SaveArticleCubit>()
                      .toggle(article.title);

                  if (saved) {
                    _saveAnimationController.forward(from: 0);
                  } else {
                    _unsaveAnimationController.forward(from: 0);
                  }
                },
                child: Stack(
                  children: [
                    Builder(builder: (context) {
                      final shouldDownloadFullSizeImages = context.select(
                        (SettingsCubit settings) =>
                            settings.state.shouldDownloadFullSizeImages,
                      );

                      final hasWifi = context.select(
                            (ConnectivityCubit connectivity) => connectivity
                                .state
                                ?.contains(ConnectivityResult.wifi),
                          ) ??
                          false;

                      final urlWifiOnly = hasWifi
                          ? article.originalImageUrl
                          : article.thumbnailUrl;

                      return WBanner(
                        src: switch (shouldDownloadFullSizeImages) {
                          ShouldDownloadFullSizeImages.yes =>
                            article.originalImageUrl,
                          ShouldDownloadFullSizeImages.no =>
                            article.thumbnailUrl,
                          _ => urlWifiOnly,
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24).subtract(
                const EdgeInsets.only(top: 24),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              WToggleSaveAnimation.save(
                                controller: _saveAnimationController,
                              ),
                              WToggleSaveAnimation.unsave(
                                controller: _unsaveAnimationController,
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<SaveArticleCubit, SaveArticleState>(
                          builder: (context, state) => switch (state) {
                            SaveArticleLoadedState state => FButton.icon(
                                style: FButtonStyle.ghost(),
                                onPress: () => context
                                    .read<SaveArticleCubit>()
                                    .toggle(article.title),
                                child: Icon(
                                  state.saved ? FIcons.bookMarked : FIcons.book,
                                ),
                              ),
                            _ => const SizedBox.shrink(),
                          },
                        ),
                        const SizedBox(width: 8),
                        FButton.icon(
                          style: FButtonStyle.ghost(),
                          onPress: () => article.share(),
                          child: const Icon(FIcons.share2),
                        ),
                        const SizedBox(width: 8),
                        FButton.icon(
                          style: FButtonStyle.ghost(),
                          onPress: () => launchUrl(Uri.parse(article.url)),
                          child: const Icon(FIcons.externalLink),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FCard(
                      subtitle: Text(
                        article.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      title: Text(article.title),
                      child: Text(
                        article.content,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

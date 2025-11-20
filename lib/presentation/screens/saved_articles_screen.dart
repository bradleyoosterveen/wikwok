import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/presentation/cubits/saved_articles_list_cubit.dart';
import 'package:wikwok/presentation/cubits/saved_articles_list_item_cubit.dart';
import 'package:wikwok/presentation/screens/article_screen.dart';
import 'package:wikwok/presentation/widgets/banner.dart';
import 'package:wikwok/presentation/widgets/border.dart';
import 'package:wikwok/presentation/widgets/circular_progress.dart';
import 'package:wikwok/presentation/widgets/error_retry_widget.dart';
import 'package:wikwok/presentation/widgets/shimmer.dart';

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  static push(BuildContext context) => Navigator.of(context).push(SavedArticlesScreen._route());

  static MaterialPageRoute _route() => MaterialPageRoute(builder: (context) => const SavedArticlesScreen());

  @override
  State<SavedArticlesScreen> createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> with TickerProviderStateMixin {
  late final _popoverController = FPopoverController(vsync: this);

  @override
  void initState() {
    super.initState();

    context.read<SavedArticlesListCubit>().get();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: Builder(builder: (context) {
        final hasArticles = context.watch<SavedArticlesListCubit>().state is SavedArticlesListLoadedState;

        return FHeader.nested(
          prefixes: [
            FButton.icon(
              style: FButtonStyle.ghost(),
              child: const Icon(FIcons.arrowLeft),
              onPress: () => Navigator.pop(context),
            ),
          ],
          suffixes: [
            if (hasArticles) ...[
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
                          'Remove all from library (permanent)',
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                        onPress: () async {
                          await _popoverController.hide();

                          if (!context.mounted) return;

                          context.read<SavedArticlesListCubit>().deleteAll();
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
          ],
          title: const Text('Library'),
        );
      }),
      child: SafeArea(
        top: false,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(builder: (context) {
                final savedArticlesListState = context.watch<SavedArticlesListCubit>().state;

                return switch (savedArticlesListState) {
                  SavedArticlesListLoadedState state => Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: state.articleTitles.length,
                        itemBuilder: (context, index) => BlocProvider(
                          create: (context) => SavedArticlesListItemCubit(),
                          child: _ListItem(
                            title: state.articleTitles[index],
                          ),
                        ),
                      ),
                    ),
                  SavedArticlesListEmptyState _ => FCard(
                      style: (style) => style.copyWith(
                        decoration: style.decoration.copyWith(
                          border: WBorder.zero,
                        ),
                      ),
                      title: const Text('Your library is empty'),
                      subtitle: const SizedBox.shrink(),
                      child: const Text(
                        'Add some articles to your library.',
                      ),
                    ),
                  SavedArticlesListErrorState _ => WErrorRetryWidget(
                      title: 'Something went wrong fetching your library.',
                      onRetry: () => context.read<SavedArticlesListCubit>().get(),
                    ),
                  _ => const SizedBox.shrink(),
                };
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListItem extends StatefulWidget {
  const _ListItem({
    required this.title,
  });

  final String title;

  @override
  State<_ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<_ListItem> {
  static final _random = Random();

  @override
  void initState() {
    super.initState();

    context.read<SavedArticlesListItemCubit>().get(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final savedArticleListItemState = context.watch<SavedArticlesListItemCubit>().state;

    return FItem(
      prefix: SizedBox(
        width: 64,
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: switch (savedArticleListItemState) {
              SavedArticlesListItemLoadedState state => WBanner(
                  src: state.article.thumbnailUrl,
                  fill: true,
                  showGradient: false,
                  showBackground: false,
                  shouldWrapInSafeArea: false,
                ),
              SavedArticlesListItemLoadingState _ => const WCircularProgress(),
              _ => const Icon(FIcons.circleSlash),
            },
          ),
        ),
      ),
      title: LayoutBuilder(
        builder: (context, constraints) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (savedArticleListItemState) {
            SavedArticlesListItemLoadedState state => Text(state.article.title),
            SavedArticlesListItemLoadingState _ => WShimmer(
                width: constraints.maxWidth * 0.3 * _random.nextDouble() + 32,
              ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
      subtitle: LayoutBuilder(
        builder: (context, constraints) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (savedArticleListItemState) {
            SavedArticlesListItemLoadedState state => Text(state.article.subtitle),
            SavedArticlesListItemLoadingState _ => WShimmer(
                width: constraints.maxWidth * 0.5 * _random.nextDouble() + 32,
              ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
      onPress: () => switch (savedArticleListItemState) {
        SavedArticlesListItemLoadedState state => ArticleScreen.push(context, article: state.article),
        _ => {}
      },
    );
  }
}

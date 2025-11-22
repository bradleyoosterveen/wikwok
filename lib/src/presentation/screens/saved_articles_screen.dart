import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/presentation.dart';

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  static push(BuildContext context) =>
      Navigator.of(context).push(SavedArticlesScreen._route());

  static MaterialPageRoute _route() =>
      MaterialPageRoute(builder: (context) => const SavedArticlesScreen());

  @override
  State<SavedArticlesScreen> createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen>
    with TickerProviderStateMixin {
  late final _popoverController = FPopoverController(vsync: this);

  @override
  void initState() {
    super.initState();

    context.read<SavedArticlesListCubit>().get();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      header: Builder(
        builder: (context) {
          final hasArticles =
              context.watch<SavedArticlesListCubit>().state
                  is SavedArticlesListLoadedState;

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
                  menuAnchor: .topRight,
                  childAnchor: .bottomRight,
                  menu: [
                    FItemGroup(
                      children: [
                        FItem(
                          prefix: const Icon(FIcons.x),
                          title: Text(
                            context.l10n.remove_all_from_library_permanent,
                            overflow: .visible,
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
            title: Text(context.l10n.library),
          );
        },
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const .symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Builder(
                builder: (context) {
                  final savedArticlesListState = context
                      .watch<SavedArticlesListCubit>()
                      .state;

                  return switch (savedArticlesListState) {
                    SavedArticlesListLoadedState state => Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: state.articleTitles.length,
                        itemBuilder: (context, index) =>
                            _ListItem(title: state.articleTitles[index]),
                      ),
                    ),
                    SavedArticlesListEmptyState _ => FCard(
                      style: (style) => style.copyWith(
                        decoration: style.decoration.copyWith(
                          border: WBorder.zero,
                        ),
                      ),
                      title: Text(context.l10n.your_library_is_empty),
                      subtitle: const SizedBox.shrink(),
                      child: Text(
                        context.l10n.add_some_articles_to_your_library,
                      ),
                    ),
                    SavedArticlesListErrorState _ => WErrorRetryWidget(
                      title: context
                          .l10n
                          .something_went_wrong_fetching_your_library,
                      onRetry: () =>
                          context.read<SavedArticlesListCubit>().get(),
                    ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({required this.title});

  final String title;

  static const _titleWidthMultiplier = 0.5;

  static const _subtitleWidthMultiplier = 0.3;

  double _titleWidth(BoxConstraints constraints) =>
      constraints.maxWidth * _titleWidthMultiplier;

  double _subtitleWidth(BoxConstraints constraints) =>
      constraints.maxWidth * _subtitleWidthMultiplier;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => inject<SavedArticlesListItemCubit>()..get(title),
      child: Builder(
        builder: (context) {
          final savedArticleListItemState = context
              .watch<SavedArticlesListItemCubit>()
              .state;

          return FItem(
            prefix: SizedBox(
              width: 64,
              child: AspectRatio(
                aspectRatio: 1,
                child: AnimatedSwitcher(
                  duration: 300.milliseconds,
                  child: switch (savedArticleListItemState) {
                    SavedArticlesListItemLoadedState state => WBanner(
                      src: state.article.thumbnailUrl,
                      fill: true,
                      showGradient: false,
                      showBackground: false,
                      shouldWrapInSafeArea: false,
                    ),
                    SavedArticlesListItemLoadingState _ =>
                      const WCircularProgress(),
                    _ => const Icon(FIcons.circleSlash),
                  },
                ),
              ),
            ),
            title: LayoutBuilder(
              builder: (context, constraints) => AnimatedSwitcher(
                duration: 300.milliseconds,
                child: switch (savedArticleListItemState) {
                  SavedArticlesListItemLoadedState state => Text(
                    state.article.title,
                  ),
                  SavedArticlesListItemLoadingState _ => WShimmer(
                    width: _titleWidth(constraints),
                  ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
            subtitle: LayoutBuilder(
              builder: (context, constraints) => AnimatedSwitcher(
                duration: 300.milliseconds,
                child: switch (savedArticleListItemState) {
                  SavedArticlesListItemLoadedState state => Text(
                    state.article.subtitle,
                  ),
                  SavedArticlesListItemLoadingState _ => WShimmer(
                    width: _subtitleWidth(constraints),
                  ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
            onPress: () => switch (savedArticleListItemState) {
              SavedArticlesListItemLoadedState state => ArticleScreen.push(
                context,
                article: state.article,
              ),
              _ => {},
            },
          );
        },
      ),
    );
  }
}

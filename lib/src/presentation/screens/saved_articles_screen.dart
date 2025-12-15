import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/domain.dart';
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
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Builder(
              builder: (context) {
                final savedArticlesListState = context
                    .watch<SavedArticlesListCubit>()
                    .state;

                return Expanded(
                  child: AnimatedSwitcher(
                    duration: 300.milliseconds,
                    child: switch (savedArticlesListState) {
                      SavedArticlesListLoadedState state => ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: state.articles.length,
                        itemBuilder: (context, index) =>
                            _ListItem(article: state.articles[index]),
                      ),
                      SavedArticlesListEmptyState _ =>
                        WInformationalLayoutWidget(
                          icon: FIcons.searchSlash,
                          title: context.l10n.your_library_is_empty,
                          subtitle:
                              context.l10n.add_some_articles_to_your_library,
                          actions: [
                            FButton(
                              onPress: () => Navigator.of(context).pop(),
                              child: Text(context.l10n.go_back),
                            ),
                          ],
                        ),
                      SavedArticlesListErrorState _ =>
                        WInformationalLayoutWidget(
                          title: context
                              .l10n
                              .something_went_wrong_fetching_your_library,
                          actions: [
                            FButton(
                              onPress: () =>
                                  context.read<SavedArticlesListCubit>().get(),
                              child: Text(context.l10n.try_again),
                            ),
                          ],
                        ),
                      SavedArticlesListLoadingState state =>
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: state.progress),
                          duration: 300.milliseconds,
                          curve: Curves.easeOutExpo,
                          builder: (context, value, _) => Padding(
                            padding: const EdgeInsets.all(32),
                            child: LinearProgressIndicator(
                              value: value,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      _ => const WCircularProgress(),
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return FItem(
          prefix: SizedBox(
            width: 64,
            child: AspectRatio(
              aspectRatio: 1,
              child: AnimatedSwitcher(
                duration: 300.milliseconds,
                child: WBanner(
                  src: article.thumbnailUrl,
                  fill: true,
                  showGradient: false,
                  showBackground: false,
                  shouldWrapInSafeArea: false,
                ),
              ),
            ),
          ),
          title: LayoutBuilder(
            builder: (context, constraints) => AnimatedSwitcher(
              duration: 300.milliseconds,
              child: Text(article.title),
            ),
          ),
          subtitle: LayoutBuilder(
            builder: (context, constraints) => AnimatedSwitcher(
              duration: 300.milliseconds,
              child: Text(article.subtitle),
            ),
          ),
          onPress: () => ArticleScreen.push(
            context,
            article: article,
          ),
        );
      },
    );
  }
}

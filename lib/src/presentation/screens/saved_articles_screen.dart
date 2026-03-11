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
        bottom: false,
        child: WFlex.column(
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
                      SavedArticlesListLoadedState state => _List(state: state),
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

class _List extends StatefulWidget {
  const _List({required this.state});

  final SavedArticlesListLoadedState state;

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  bool _sortAscending = true;

  List<Article> get _articles {
    final articles = List<Article>.from(widget.state.articles);
    articles.sort((a, b) {
      final comparison = a.title.compareTo(b.title);
      return _sortAscending ? comparison : -comparison;
    });
    return articles;
  }

  Widget _listItemBuilder(
    BuildContext context,
    int index,
    SavedArticlesListLoadedState state,
  ) {
    if (index < state.articles.length - 1) {
      return _ListItem(article: _articles[index]);
    }

    return Column(
      children: [
        _ListItem(article: _articles[index]),
        SizedBox(
          height:
              MediaQuery.of(context).viewPadding.bottom +
              (MediaQuery.sizeOf(context).height * 0.1),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 24.0,
    ),
    child: WFlex.column(
      divider: const SizedBox(height: 16),
      children: [
        WFlex.row(
          mainAxisAlignment: .end,
          divider: const SizedBox(width: 16),
          children: [
            FButton.icon(
              onPress: () => setState(() => _sortAscending = !_sortAscending),
              child: Icon(
                _sortAscending ? FIcons.arrowDownAZ : FIcons.arrowDownZA,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: widget.state.articles.length,
            itemBuilder: (context, index) =>
                _listItemBuilder(context, index, widget.state),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 32),
          ),
        ),
      ],
    ),
  );
}

class _ListItem extends StatelessWidget {
  const _ListItem({required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => ArticleScreen.push(
      context,
      article: article,
    ),
    child: FCard(
      style: (style) => style.copyWith(
        contentStyle: style.contentStyle
            .copyWith(
              padding: .zero,
            )
            .call,
        decoration: style.decoration.copyWith(
          border: Border.all(color: Colors.transparent),
        ),
      ),
      image: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .2,
        ),
        child: WBanner(
          shouldWrapInSafeArea: false,
          showGradient: false,
          src: article.thumbnailUrl,
        ),
      ),
      title: Text(article.title),
      subtitle: Text(article.subtitle),
    ),
  );
}

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
      header: _Header(
        popoverController: _popoverController,
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

class _Header extends StatelessWidget {
  const _Header({
    required this.popoverController,
  });

  final FPopoverController popoverController;

  @override
  Widget build(BuildContext context) {
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
            popoverController: popoverController,
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
                      await popoverController.hide();

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
              onPress: () => popoverController.show(),
            ),
          ),
        ],
      ],
      title: Column(
        children: [
          Text(context.l10n.library),
          Builder(
            builder: (context) {
              final savedArticlesLimitState = context
                  .watch<SavedArticlesLimitCubit>()
                  .state;

              final text = switch (savedArticlesLimitState) {
                SavedArticlesLimitLoadedState state =>
                  "${state.current} / ${state.limit}",
                SavedArticlesLimitErrorState _ =>
                  context.l10n.something_went_wrong,
                SavedArticlesLimitLoadingState _ => context.l10n.loading,
                _ => context.l10n.loading,
              };

              return Text(
                text,
                style: context.theme.typography.sm.copyWith(
                  color: context.theme.colors.mutedForeground,
                  fontWeight: FontWeight.w400,
                ),
              );
            },
          ),
        ],
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
  final TextEditingController _searchController = TextEditingController();

  bool _sortAscending = true;

  List<Article> get _articles {
    var articles = List<Article>.from(widget.state.articles);

    articles = articles.where((article) {
      final searchText = '${article.title} ${article.subtitle}'.toLowerCase();

      final query = _searchController.text.toLowerCase();
      return searchText.contains(query);
    }).toList();

    if (articles.isEmpty) return [];

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
    if (index < _articles.length - 1) {
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
      horizontal: 12.0,
    ),
    child: WFlex.column(
      divider: const SizedBox(height: 16),
      children: [
        WFlex.row(
          mainAxisAlignment: .end,
          divider: const SizedBox(width: 12),
          children: [
            Expanded(
              child: FTextField(
                style: (style) => style.copyWith(
                  contentPadding: style.contentPadding.add(
                    const .symmetric(vertical: 4),
                  ),
                ),
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                onChange: (value) => setState(() {}),
                controller: _searchController,
                prefixBuilder: (_, __, ___) => const Padding(
                  padding: .only(left: 12, right: 4),
                  child: Icon(FIcons.search),
                ),
                suffixBuilder: (_, __, ___) {
                  if (_searchController.text.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const .only(left: 4, right: 6),
                    child: FButton.icon(
                      style: FButtonStyle.ghost(),
                      onPress: () =>
                          setState(() => _searchController.text = ''),
                      child: const Icon(FIcons.x),
                    ),
                  );
                },
              ),
            ),
            FButton.icon(
              onPress: () => setState(() => _sortAscending = !_sortAscending),
              child: Icon(
                _sortAscending ? FIcons.arrowDownAZ : FIcons.arrowDownZA,
              ),
            ),
          ],
        ),
        if (_articles.isNotEmpty) ...[
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _articles.length,
              itemBuilder: (context, index) =>
                  _listItemBuilder(context, index, widget.state),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 32),
            ),
          ),
        ] else ...[
          const Expanded(
            child: Text("Not found"),
          ),
        ],
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

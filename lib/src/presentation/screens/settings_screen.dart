import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';
import 'package:wikwok/src/gen/assets.gen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen._({super.key});

  static push(BuildContext context, {Key? key}) => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => SettingsScreen._(key: key)));

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      footer: Padding(
        padding: .only(
          bottom: MediaQuery.of(context).systemGestureInsets.bottom,
          left: 24.0,
          right: 24.0,
          top: 24.0,
        ),
        child: BlocBuilder<CurrentVersionCubit, CurrentVersionState>(
          builder: (context, state) => Column(
            mainAxisSize: .min,
            children: [
              Opacity(
                opacity: 0.64,
                child: Text(
                  context
                      .l10n
                      .this_app_is_not_affiliated_with_the_wikimedia_foundation,
                  textAlign: .center,
                  style: context.theme.typography.sm,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  FLabel(
                    axis: .vertical,
                    label: Text(context.l10n.current_version),
                    child: switch (state) {
                      CurrentVersionLoadedState state => Text(
                        state.version.toString(),
                      ),
                      CurrentVersionErrorState _ => Text(
                        context.l10n.something_went_wrong,
                      ),
                      _ => Text(context.l10n.loading),
                    },
                  ),
                  SizedBox(
                    height: 32,
                    child: SvgPicture.asset(
                      Assets.logo,
                      fit: .cover,
                      height: 72,
                      colorFilter: ColorFilter.mode(
                        context.theme.colors.secondaryForeground,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
        title: Text(context.l10n.settings),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const .symmetric(horizontal: 24),
          child: Column(
            children: [
              Builder(
                builder: (context) {
                  final settings = context.watch<SettingsCubit>().state;

                  return FTileGroup(
                    divider: .full,
                    children: [
                      _OptionTile<WThemeMode>(
                        prefix: FIcons.sunMoon,
                        title: context.l10n.theme,
                        initialValue: settings.themeMode,
                        onChange: (WThemeMode value) =>
                            settings.copyWith(themeMode: value),
                        labelBuilder: (WThemeMode value) => switch (value) {
                          .system => context.l10n.system,
                          .light => context.l10n.light,
                          .dark => context.l10n.dark,
                          .pink => context.l10n.pink,
                        },
                        options: WThemeMode.values,
                      ),
                      _OptionTile<WLocale>(
                        prefix: FIcons.languages,
                        title: context.l10n.interface_language,
                        initialValue: settings.locale,
                        onChange: (WLocale value) =>
                            settings.copyWith(locale: value),
                        labelBuilder: (WLocale value) => switch (value) {
                          .system => context.l10n.system,
                          .en => 'English',
                          .nl => 'Nederlands',
                        },
                        options: WLocale.values,
                      ),
                      _OptionTile<Axis>(
                        prefix: FIcons.move3d,
                        title: context.l10n.swipe_direction,
                        initialValue: settings.doomScrollDirection,
                        onChange: (Axis value) =>
                            settings.copyWith(doomScrollDirection: value),
                        labelBuilder: (Axis value) => switch (value) {
                          .vertical => context.l10n.vertical,
                          .horizontal => context.l10n.horizontal,
                        },
                        options: Axis.values,
                      ),
                      _OptionTile<ArticlePrefetchRange>(
                        prefix: FIcons.arrowBigRightDash,
                        title: context.l10n.article_prefetch_range,
                        initialValue: settings.articlePrefetchRange,
                        onChange: (ArticlePrefetchRange value) =>
                            settings.copyWith(articlePrefetchRange: value),
                        labelBuilder: (ArticlePrefetchRange value) =>
                            switch (value) {
                              .none => context.l10n.none,
                              .short => '1',
                              .medium => '2',
                              .large => '3',
                            },
                        options: ArticlePrefetchRange.values,
                      ),
                      _OptionTile<ShouldDownloadFullSizeImages>(
                        prefix: FIcons.proportions,
                        title: context.l10n.download_full_size_images,
                        initialValue: settings.shouldDownloadFullSizeImages,
                        onChange: (ShouldDownloadFullSizeImages value) =>
                            settings.copyWith(
                              shouldDownloadFullSizeImages: value,
                            ),
                        labelBuilder: (ShouldDownloadFullSizeImages value) =>
                            switch (value) {
                              .yes => context.l10n.yes,
                              .no => context.l10n.no,
                              .wifiOnly => context.l10n.wifi_only,
                            },
                        options: ShouldDownloadFullSizeImages.values,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Builder(
                builder: (context) {
                  final updateViewModel = switch (context
                      .watch<UpdateCubit>()
                      .state) {
                    UpdateAvailableState state => state.viewModel,
                    UpdateSkippedState state => state.viewModel,
                    _ => null,
                  };

                  return FTileGroup(
                    divider: .full,
                    children: [
                      FTile(
                        prefix: const Icon(FIcons.gitPullRequestArrow),
                        title: Text(context.l10n.suggest_feature),
                        suffix: const Icon(FIcons.chevronRight),
                        onPress: () => launchUrl(
                          .parse(
                            'https://github.com/bradleyoosterveen/WikWok/issues/new?template=enhancement.yml',
                          ),
                        ),
                      ),
                      FTile(
                        prefix: const Icon(FIcons.bug),
                        title: Text(context.l10n.report_a_bug),
                        suffix: const Icon(FIcons.chevronRight),
                        onPress: () => launchUrl(
                          .parse(
                            'https://github.com/bradleyoosterveen/WikWok/issues/new?template=bug.yml',
                          ),
                        ),
                      ),
                      FTile(
                        prefix: const Icon(FIcons.code),
                        title: Text(context.l10n.view_source_code),
                        suffix: const Icon(FIcons.chevronRight),
                        onPress: () => launchUrl(
                          .parse('https://github.com/bradleyoosterveen/WikWok'),
                        ),
                      ),
                      if (updateViewModel != null) ...[
                        FTile(
                          prefix: const Icon(FIcons.download),
                          title: Text(
                            context.l10n.update_to(
                              updateViewModel.version.toString(),
                            ),
                          ),
                          suffix: const Icon(FIcons.chevronRight),
                          onPress: () => UpdateScreen.push(
                            context,
                            viewModel: updateViewModel,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              FTileGroup(
                divider: FItemDivider.full,
                children: [
                  FTile(
                    prefix: const Icon(FIcons.heart),
                    title: Text(
                      context.l10n.donate_to_the_wikimedia_foundation,
                    ),
                    suffix: const Icon(FIcons.chevronRight),
                    onPress: () =>
                        launchUrl(.parse('https://donate.wikimedia.org/')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile<T> extends StatefulWidget with FTileMixin {
  const _OptionTile({
    required this.prefix,
    required this.title,
    required this.initialValue,
    required this.onChange,
    required this.labelBuilder,
    required this.options,
    this.enabled = true,
  });

  final IconData prefix;
  final String title;
  final T initialValue;
  final Settings Function(T value) onChange;
  final String Function(T value) labelBuilder;
  final List<T> options;
  final bool enabled;

  @override
  _OptionTileState<T> createState() => _OptionTileState<T>();
}

class _OptionTileState<T> extends State<_OptionTile<T>> {
  final FSelectMenuTileController<T> _controller = .radio();

  @override
  void initState() {
    super.initState();

    _controller.value = {widget.initialValue};

    _controller.addListener(_onThemeSelected);
  }

  void _onThemeSelected() {
    final selectedValue = _controller.value.firstOrNull;

    if (selectedValue == null) return;

    context.read<SettingsCubit>().change(widget.onChange.call(selectedValue));
  }

  @override
  Widget build(BuildContext context) {
    return FSelectMenuTile<T>(
      enabled: widget.enabled,
      selectController: _controller,
      autoHide: true,
      prefix: Icon(widget.prefix),
      title: Text(widget.title),
      detailsBuilder: (context, selected, _) => Text(
        widget.labelBuilder.call(selected.firstOrNull ?? widget.initialValue),
      ),
      menu: widget.options
          .map(
            (mode) => FSelectTile<T>(
              title: Text(widget.labelBuilder(mode)),
              value: mode,
            ),
          )
          .toList(),
    );
  }
}

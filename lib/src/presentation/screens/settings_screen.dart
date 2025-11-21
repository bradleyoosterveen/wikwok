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
                  'This app is not affiliated with, endorsed by, or sponsored by Wikipedia or the Wikimedia Foundation. All trademarks and registered trademarks are the property of their respective owners.',
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
                    label: const Text('Current version'),
                    child: switch (state) {
                      CurrentVersionLoadedState state => Text(
                        state.version.toString(),
                      ),
                      CurrentVersionErrorState _ => const Text('Error'),
                      _ => const Text('Loading...'),
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
        title: const Text('Settings'),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Builder(
                builder: (context) {
                  final settings = context.watch<SettingsCubit>().state;

                  return FTileGroup(
                    label: const Text('Settings'),
                    divider: .full,
                    children: [
                      _OptionTile<WThemeMode>(
                        prefix: FIcons.sunMoon,
                        title: 'Theme',
                        initialValue: settings.themeMode,
                        onChange: (WThemeMode value) =>
                            settings.copyWith(themeMode: value),
                        labelBuilder: (WThemeMode value) => switch (value) {
                          WThemeMode.light => 'Light',
                          WThemeMode.dark => 'Dark',
                          WThemeMode.system => 'System',
                          WThemeMode.pink => 'Pink',
                        },
                        options: WThemeMode.values,
                      ),
                      _OptionTile<Axis>(
                        prefix: FIcons.move3d,
                        title: 'Swipe direction',
                        initialValue: settings.doomScrollDirection,
                        onChange: (Axis value) =>
                            settings.copyWith(doomScrollDirection: value),
                        labelBuilder: (Axis value) => switch (value) {
                          Axis.vertical => 'Vertical',
                          Axis.horizontal => 'Horizontal',
                        },
                        options: Axis.values,
                      ),
                      _OptionTile<ArticlePrefetchRange>(
                        prefix: FIcons.arrowBigRightDash,
                        title: 'Article prefetch range',
                        initialValue: settings.articlePrefetchRange,
                        onChange: (ArticlePrefetchRange value) =>
                            settings.copyWith(articlePrefetchRange: value),
                        labelBuilder: (ArticlePrefetchRange value) =>
                            switch (value) {
                              ArticlePrefetchRange.none => 'None',
                              ArticlePrefetchRange.short => '1',
                              ArticlePrefetchRange.medium => '2',
                              ArticlePrefetchRange.large => '3',
                            },
                        options: ArticlePrefetchRange.values,
                      ),
                      _OptionTile<ShouldDownloadFullSizeImages>(
                        prefix: FIcons.proportions,
                        title: 'Download full size images',
                        initialValue: settings.shouldDownloadFullSizeImages,
                        onChange: (ShouldDownloadFullSizeImages value) =>
                            settings.copyWith(
                              shouldDownloadFullSizeImages: value,
                            ),
                        labelBuilder: (ShouldDownloadFullSizeImages value) =>
                            switch (value) {
                              ShouldDownloadFullSizeImages.yes => 'Yes',
                              ShouldDownloadFullSizeImages.no => 'No',
                              ShouldDownloadFullSizeImages.wifiOnly =>
                                'Wifi only',
                            },
                        options: ShouldDownloadFullSizeImages.values,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              FTileGroup(
                divider: FItemDivider.full,
                children: [
                  FTile(
                    prefix: const Icon(FIcons.gitPullRequestArrow),
                    title: const Text('Suggest feature'),
                    suffix: const Icon(FIcons.chevronRight),
                    onPress: () => launchUrl(
                      Uri.parse(
                        'https://github.com/bradleyoosterveen/WikWok/issues/new?template=enhancement.yml',
                      ),
                    ),
                  ),
                  FTile(
                    prefix: const Icon(FIcons.bug),
                    title: const Text('Report a bug'),
                    suffix: const Icon(FIcons.chevronRight),
                    onPress: () => launchUrl(
                      Uri.parse(
                        'https://github.com/bradleyoosterveen/WikWok/issues/new?template=bug.yml',
                      ),
                    ),
                  ),
                  FTile(
                    prefix: const Icon(FIcons.code),
                    title: const Text('View source code'),
                    suffix: const Icon(FIcons.chevronRight),
                    onPress: () => launchUrl(
                      Uri.parse('https://github.com/bradleyoosterveen/WikWok'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FTileGroup(
                divider: FItemDivider.full,
                children: [
                  FTile(
                    prefix: const Icon(FIcons.heart),
                    title: const Text('Donate to the Wikimedia Foundation'),
                    suffix: const Icon(FIcons.chevronRight),
                    onPress: () =>
                        launchUrl(Uri.parse('https://donate.wikimedia.org/')),
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

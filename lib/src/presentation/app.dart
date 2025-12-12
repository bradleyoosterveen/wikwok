import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';
import 'package:wikwok/src/l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final _platformBrightness = MediaQuery.of(context).platformBrightness;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => inject<SavedArticlesListCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => inject<UpdateCubit>()..get(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => inject<CurrentVersionCubit>()..get(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => inject<SettingsCubit>()..get(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => inject<ConnectivityCubit>()..initialize(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final themeMode = context.select(
            (SettingsCubit cubit) => cubit.state.themeMode,
          );

          final theme = switch (themeMode) {
            WThemeMode.light => FThemes.zinc.light,
            WThemeMode.dark => FThemes.zinc.dark,
            WThemeMode.system =>
              _platformBrightness == Brightness.dark
                  ? FThemes.zinc.dark
                  : FThemes.zinc.light,
            WThemeMode.pink => WThemes.pink,
          };

          return MultiBlocListener(
            listeners: _blocListenersBuilder(),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: theme.colors.systemOverlayStyle,
              child: Builder(
                builder: (context) {
                  final locale = switch (context.select(
                    (SettingsCubit cubit) => cubit.state.locale,
                  )) {
                    WLocale.en => const Locale('en'),
                    WLocale.nl => const Locale('nl'),
                    WLocale.system =>
                      Platform.localeName.split('_').first == 'nl'
                          ? const Locale('nl')
                          : const Locale('en'),
                  };

                  return MaterialApp(
                    title: 'WikWok',
                    navigatorKey: App.navigatorKey,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: locale,
                    theme: theme.toApproximateMaterialTheme().copyWith(
                      pageTransitionsTheme: PageTransitionsTheme(
                        builders: {
                          for (var platform in TargetPlatform.values)
                            platform:
                                const WOpenForwardsPageTransitionsBuilder(),
                        },
                      ),
                    ),
                    builder: (context, child) => FAnimatedTheme(
                      data: theme,
                      child: child ?? const SizedBox.shrink(),
                    ),
                    home: const ArticlesScreen(),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

List<BlocListener> _blocListenersBuilder() {
  return [
    BlocListener<UpdateCubit, UpdateState>(
      listener: (context, state) => switch (state) {
        UpdateAvailableState state => switch (Never) {
          _ when App.navigatorKey.currentContext != null => UpdateScreen.push(
            App.navigatorKey.currentContext as BuildContext,
            viewModel: state.viewModel,
          ),
          _ => {},
        },
        _ => {},
      },
    ),
  ];
}

extension WThemes on Never {
  static final pink = FThemeData(
    debugLabel: 'Rose Light ThemeData',
    colors: const FColors(
      brightness: Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      barrier: Color(0x33000000),
      background: Color(0xFFFCEEF3),
      foreground: Color(0xFF230610),
      primary: Color(0xFF9A5B7F),
      primaryForeground: Color(0xFFFFF1F2),
      secondary: Color(0xFFF0E5EB),
      secondaryForeground: Color(0xFF18181B),
      muted: Color(0xFFF4F4F5),
      mutedForeground: Color(0xFFA88994),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFAFAFA),
      error: Color(0xFFEF4444),
      errorForeground: Color(0xFFFAFAFA),
      border: Color(0xFFE1CCD8),
    ),
  );
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/core.dart';
import 'package:wikwok/domain.dart';
import 'package:wikwok/presentation.dart';
import 'package:wikwok/src/l10n/app_localizations.dart';

extension on WLocale {
  Locale get toLocale => switch (this) {
    .en => const Locale('en'),
    .nl => const Locale('nl'),
    .system =>
      Platform.localeName.split('_').first == 'nl'
          ? const Locale('nl')
          : const Locale('en'),
  };
}

extension on WThemeMode {
  FThemeData toFThemeData(BuildContext context) => switch (this) {
    .light => FThemes.zinc.light,
    .dark => FThemes.zinc.dark,
    .pink => WThemes.pink,
    .system =>
      MediaQuery.of(context).platformBrightness == .dark
          ? FThemes.zinc.dark
          : FThemes.zinc.light,
  };
}

List<BlocListener> _blocListenersBuilder() => [
  BlocListener<UpdateCubit, UpdateState>(
    listener: (context, state) => switch (state) {
      UpdateAvailableState state => () {
        final context = App.navigatorKey.currentContext;

        if (context == null) return;

        UpdateScreen.push(
          context,
          viewModel: state.viewModel,
        );
      }(),
      _ => {},
    },
  ),
];

class App extends StatefulWidget {
  const App({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
          final theme = context
              .select((SettingsCubit cubit) => cubit.state.themeMode)
              .toFThemeData(context);

          return MultiBlocListener(
            listeners: _blocListenersBuilder(),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: theme.colors.systemOverlayStyle,
              child: Builder(
                builder: (context) {
                  final locale = context
                      .select((SettingsCubit cubit) => cubit.state.locale)
                      .toLocale;

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

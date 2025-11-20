import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/presentation/cubits/connectivity_cubit.dart';
import 'package:wikwok/presentation/cubits/current_version_cubit.dart';
import 'package:wikwok/presentation/cubits/saved_articles_list_cubit.dart';
import 'package:wikwok/presentation/cubits/settings_cubit.dart';
import 'package:wikwok/presentation/cubits/update_cubit.dart';
import 'package:wikwok/presentation/screens/articles_screen.dart';

import 'domain/models/settings.dart';

class App extends StatefulWidget {
  const App({super.key});

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
          create: (context) => SavedArticlesListCubit(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => UpdateCubit()..get(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => CurrentVersionCubit()..get(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => SettingsCubit()..get(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => ConnectivityCubit()..initialize(),
        ),
      ],
      child: Builder(builder: (context) {
        final themeMode = context.select(
          (SettingsCubit cubit) => cubit.state.themeMode,
        );

        final theme = switch (themeMode) {
          WThemeMode.light => FThemes.zinc.light,
          WThemeMode.dark => FThemes.zinc.dark,
          WThemeMode.system => _platformBrightness == Brightness.dark
              ? FThemes.zinc.dark
              : FThemes.zinc.light,
          WThemeMode.pink => WThemes.pink,
        };

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: MaterialApp(
            title: 'WikWok',
            theme: theme.toApproximateMaterialTheme().copyWith(
                  pageTransitionsTheme: PageTransitionsTheme(
                    builders: {
                      for (var platform in TargetPlatform.values)
                        platform: const CupertinoPageTransitionsBuilder(),
                    },
                  ),
                ),
            builder: (_, child) => FAnimatedTheme(
              data: theme,
              child: child ?? const SizedBox.shrink(),
            ),
            home: const ArticlesScreen(),
          ),
        );
      }),
    );
  }
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

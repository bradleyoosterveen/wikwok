import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/presentation.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final direction = context.select(
      (SettingsCubit cubit) => cubit.state.doomScrollDirection,
    );

    return FScaffold(
      childPad: false,
      child: Stack(
        children: [
          PageView.builder(
            scrollDirection: direction,
            itemBuilder: (context, index) => ArticlePage(index: index),
          ),
          Positioned(
            child: Align(
              alignment: .bottomCenter,
              child: Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).viewPadding.bottom + 16,
              ),
            ),
          ),
          const _Header(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .topCenter,
      child: FHeader.nested(
        suffixes: [
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: () => SavedArticlesScreen.push(context),
            child: const Icon(FIcons.library),
          ),
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: () => SettingsScreen.push(context),
            child: const Icon(FIcons.settings2),
          ),
        ],
      ),
    );
  }
}

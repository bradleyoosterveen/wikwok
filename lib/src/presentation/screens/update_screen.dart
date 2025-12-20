import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/presentation.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({
    required this.viewModel,
    super.key,
  });

  final UpdateViewModel viewModel;

  static push(
    BuildContext context, {
    required UpdateViewModel viewModel,
  }) => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => UpdateScreen(
        viewModel: viewModel,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateCubit, UpdateState>(
          listener: (context, state) => switch (state) {
            UpdateSkippedState _ => Navigator.pop(context),
            _ => {},
          },
        ),
      ],
      child: FScaffold(
        childPad: false,
        header: FHeader.nested(
          prefixes: [
            FButton.icon(
              style: FButtonStyle.ghost(),
              child: const Icon(FIcons.arrowLeft),
              onPress: () => Navigator.pop(context),
            ),
          ],
        ),
        child: Center(
          child: WInformationalLayoutWidget(
            icon: FIcons.download,
            title: context.l10n.version_available(
              viewModel.version.toString(),
            ),
            subtitle: context.l10n.a_new_version_is_available,
            actions: [
              FButton(
                onPress: () => WUrlLauncher.show(context, viewModel.url),
                child: Text(context.l10n.update),
              ),
              FButton(
                onPress: () => context.read<UpdateCubit>().skip(),
                style: FButtonStyle.ghost(),
                child: Text(context.l10n.skip_this_version),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

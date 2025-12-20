import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikwok/presentation.dart';

class WUrlLauncher extends StatelessWidget {
  const WUrlLauncher._({
    required this.url,
  });

  final String url;

  static show(BuildContext context, String url) => showModalBottomSheet(
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.8,
    ),
    context: context,
    builder: (context) => WUrlLauncher._(
      url: url,
    ),
  );

  void _onConfirm(BuildContext context) {
    launchUrl(.parse(url));
    Navigator.pop(context);
  }

  void _onCancel(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 8),
      child: Container(
        clipBehavior: .antiAlias,
        decoration: BoxDecoration(
          borderRadius: const .all(.circular(16)),
          color: context.theme.colors.background,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            clipBehavior: .none,
            child: Stack(
              children: [
                // Assuming the informational widget has a centered icon,
                // we can align the cancel button to the top right corner.
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const .all(16),
                    child: FButton.icon(
                      onPress: () => _onCancel(context),
                      style: FButtonStyle.ghost(),
                      child: const Icon(FIcons.x),
                    ),
                  ),
                ),
                WInformationalLayoutWidget(
                  icon: FIcons.externalLink,
                  title: context.l10n.open_in_browser,
                  subtitle: context
                      .l10n
                      .you_are_about_to_open_this_link_in_your_default_browser,
                  actions: [
                    WUrlPreviewer(url: url),
                    FButton(
                      onPress: () => _onConfirm(context),
                      child: Text(context.l10n.continue_text),
                    ),
                    FButton(
                      onPress: () => _onCancel(context),
                      style: FButtonStyle.ghost(),
                      child: Text(context.l10n.cancel),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
  Widget build(BuildContext context) => WConfirmBottomSheet(
    icon: FIcons.externalLink,
    title: context.l10n.open_in_browser,
    subtitle:
        context.l10n.you_are_about_to_open_this_link_in_your_default_browser,
    body: WUrlPreviewer(url: url),
    onConfirm: _onConfirm,
    onCancel: _onCancel,
  );
}

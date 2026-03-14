import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/presentation.dart';

class WConfirmBottomSheet extends StatelessWidget {
  const WConfirmBottomSheet({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.onConfirm,
    required this.onCancel,
    this.confirmText,
    this.cancelText,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget body;
  final void Function(BuildContext context) onConfirm;
  final void Function(BuildContext context) onCancel;
  final Widget? confirmText;
  final Widget? cancelText;

  @override
  Widget build(BuildContext context) {
    final confirmText = this.confirmText ?? Text(context.l10n.continue_text);
    final cancelText = this.cancelText ?? Text(context.l10n.cancel);

    return WBottomSheet(
      child: Stack(
        children: [
          // Assuming the informational widget has a centered icon,
          // we can align the cancel button to the top right corner.
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const .all(16),
              child: FButton.icon(
                onPress: () => onCancel.call(context),
                style: FButtonStyle.ghost(),
                child: const Icon(FIcons.x),
              ),
            ),
          ),
          WInformationalLayoutWidget(
            icon: icon,
            title: title,
            subtitle: subtitle,
            actions: [
              Padding(
                padding: const .only(bottom: 16.0),
                child: body,
              ),
              FButton(
                onPress: () => onConfirm.call(context),
                child: confirmText,
              ),
              FButton(
                onPress: () => onCancel.call(context),
                style: FButtonStyle.ghost(),
                child: cancelText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

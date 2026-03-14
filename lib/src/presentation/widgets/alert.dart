import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/domain.dart';

class WAlert extends StatelessWidget {
  const WAlert({
    required this.alert,
    this.onPressed,
    super.key,
  });

  final Alert alert;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = switch (alert.type) {
      AlertType.info => FIcons.info,
      AlertType.warning => FIcons.triangleAlert,
      AlertType.error => FIcons.bug,
    };

    FAlertStyle styleBuilder(FAlertStyle style) => switch (alert.type) {
      AlertType.error => style.copyWith(
        titleTextStyle: style.titleTextStyle.copyWith(
          color: context.theme.colors.foreground,
        ),
        subtitleTextStyle: style.subtitleTextStyle.copyWith(
          color: context.theme.colors.foreground,
        ),
        decoration: style.decoration.copyWith(
          border: Border.all(color: context.theme.colors.error),
          color: context.theme.colors.error.withValues(alpha: .08),
        ),
      ),
      _ => style,
    };

    final content = alert.content;

    return GestureDetector(
      onTap: onPressed,
      child: FAlert(
        icon: Icon(icon),
        title: Text(alert.title),
        subtitle: content != null ? Text(content) : null,
        style: styleBuilder,
      ),
    );
  }
}

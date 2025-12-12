import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/presentation.dart';

class WInformationalLayoutWidget extends StatelessWidget {
  const WInformationalLayoutWidget({
    required this.title,
    this.subtitle,
    this.icon,
    this.actions = const [],
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final subtitle = this.subtitle;

    return Center(
      child: Padding(
        padding: const .all(24.0),
        child: WFlex.column(
          mainAxisSize: .min,
          divider: const SizedBox(height: 32),
          children: [
            Padding(
              padding: const .symmetric(horizontal: 8),
              child: WFlex.column(
                mainAxisSize: .min,
                divider: const SizedBox(height: 16),
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: context.theme.colors.foreground,
                    ),
                  ],
                  Text(
                    title,
                    textAlign: .center,
                    style: context.theme.typography.xl2.copyWith(
                      color: context.theme.colors.foreground,
                      fontWeight: .w600,
                      height: 1.5,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    Text(
                      subtitle,
                      textAlign: .center,
                      style: context.theme.typography.sm.copyWith(
                        color: context.theme.colors.mutedForeground,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (actions.isNotEmpty) ...[
              WFlex.column(
                mainAxisSize: .min,
                divider: const SizedBox(height: 8),
                children: actions,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

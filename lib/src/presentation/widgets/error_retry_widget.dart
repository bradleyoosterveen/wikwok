import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/presentation.dart';

class WErrorRetryWidget extends StatelessWidget {
  const WErrorRetryWidget({
    required this.title,
    required this.onRetry,
    super.key,
  });

  final String title;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const .all(24.0),
        child: Column(
          mainAxisSize: .min,
          children: [
            const Icon(FIcons.circleSlash),
            const SizedBox(height: 16),
            Text(title, textAlign: .center, style: context.theme.typography.lg),
            const SizedBox(height: 16),
            FButton(
              onPress: onRetry,
              child: Text(context.l10n.try_again),
            ),
          ],
        ),
      ),
    );
  }
}

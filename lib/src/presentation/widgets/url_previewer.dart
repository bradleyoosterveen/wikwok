import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/presentation.dart';

class WUrlPreviewer extends StatelessWidget {
  const WUrlPreviewer({
    required this.url,
    super.key,
  });

  final String url;

  void _onCopy() => Clipboard.setData(ClipboardData(text: url));

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _onCopy,
    behavior: .translucent,
    child: Container(
      padding: const .all(16),
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        borderRadius: const .all(.circular(8)),
        color: context.theme.colors.border,
      ),
      child: WFlex.row(
        divider: const SizedBox(width: 8),
        children: [
          Expanded(child: Text(url)),
          const Icon(FIcons.clipboard),
        ],
      ),
    ),
  );
}

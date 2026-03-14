import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class WBottomSheet extends StatelessWidget {
  const WBottomSheet({
    this.child,
    super.key,
  });

  final Widget? child;

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
            child: child,
          ),
        ),
      ),
    );
  }
}

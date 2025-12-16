import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:wikwok/presentation.dart';

class WBanner extends StatelessWidget {
  const WBanner({
    required this.src,
    this.showGradient = true,
    this.fill = false,
    this.showBackground = true,
    this.shouldWrapInSafeArea = true,
    super.key,
  });

  final String src;
  final bool showGradient;
  final bool fill;
  final bool showBackground;
  final bool shouldWrapInSafeArea;

  double get _opacity => .08;

  EdgeInsetsGeometry get _padding => fill
      ? .zero
      : const EdgeInsets.symmetric(
          horizontal: 24,
        ).add(.only(top: shouldWrapInSafeArea ? 64 : 0));

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.theme.scaffoldStyle.backgroundColor;

    return ClipRect(
      clipBehavior: .antiAlias,
      child: Stack(
        children: [
          if (showBackground) ...[
            Positioned.fill(
              child: WCachedNetworkImage(
                src: src,
                fit: .cover,
                opacity: _opacity,
              ),
            ),
          ],
          if (showGradient && showBackground) ...[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .topCenter,
                    end: .bottomCenter,
                    colors: [
                      backgroundColor,
                      backgroundColor.withValues(alpha: 0),
                      backgroundColor.withValues(alpha: 0),
                      backgroundColor,
                    ],
                    stops: const [0, 0.2, 0.8, 1],
                  ),
                ),
              ),
            ),
          ],
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              top: shouldWrapInSafeArea,
              child: Padding(
                padding: _padding,
                child: WCachedNetworkImage(src: src, fit: .contain),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

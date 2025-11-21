import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class WShimmer extends StatelessWidget {
  const WShimmer({
    this.width,
    super.key,
  });

  final double? width;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: FProgress(
          style: (style) => style.copyWith(
            fillDecoration: style.fillDecoration.copyWith(
              color: style.fillDecoration.color?.withValues(alpha: .08),
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class WCircularProgress extends StatelessWidget {
  const WCircularProgress({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: FCircularProgress.loader(
          style: (style) => style.copyWith(
            iconStyle: style.iconStyle.copyWith(
              size: 32,
            ),
          ),
        ),
      );
}

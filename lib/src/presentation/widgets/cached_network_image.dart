import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:forui/assets.dart';

class WCachedNetworkImage extends StatelessWidget {
  const WCachedNetworkImage({
    required this.src,
    this.fit = .contain,
    this.opacity = 1,
    super.key,
  });

  final String src;
  final BoxFit fit;
  final double opacity;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: opacity,
    child: CachedNetworkImage(
      fadeInDuration: 300.milliseconds,
      fadeOutDuration: 300.milliseconds,
      fadeInCurve: Curves.easeInOut,
      fadeOutCurve: Curves.easeInOut,
      imageUrl: src,
      fit: fit,
      errorWidget: (context, url, error) => const Center(
        child: Opacity(opacity: 0.32, child: Icon(FIcons.imageOff, size: 32)),
      ),
    ),
  );
}

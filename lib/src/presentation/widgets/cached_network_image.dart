import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/assets.dart';

class WCachedNetworkImage extends StatelessWidget {
  const WCachedNetworkImage({
    required this.src,
    this.fit = BoxFit.contain,
    super.key,
  });

  final String src;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
        fadeInCurve: Curves.easeInOut,
        fadeOutCurve: Curves.easeInOut,
        imageUrl: src,
        fit: fit,
        errorWidget: (context, url, error) => const Center(
          child: Opacity(
            opacity: 0.32,
            child: Icon(
              FIcons.imageOff,
              size: 32,
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:forui/forui.dart';

class WToggleSaveAnimation extends StatelessWidget {
  const WToggleSaveAnimation._({
    required this.controller,
    required this.type,
  });

  factory WToggleSaveAnimation.save({
    required AnimationController controller,
  }) =>
      WToggleSaveAnimation._(
        controller: controller,
        type: WToggleSaveAnimationType.save,
      );

  factory WToggleSaveAnimation.unsave({
    required AnimationController controller,
  }) =>
      WToggleSaveAnimation._(
          controller: controller, type: WToggleSaveAnimationType.unsave);

  final AnimationController controller;
  final WToggleSaveAnimationType type;

  IconData get _icon => switch (type) {
        WToggleSaveAnimationType.save => FIcons.bookCheck,
        WToggleSaveAnimationType.unsave => FIcons.bookX,
      };

  String get _text => switch (type) {
        WToggleSaveAnimationType.save => 'Saved to library',
        WToggleSaveAnimationType.unsave => 'Removed from library',
      };

  Duration get _scaleDuration => 100.milliseconds;

  Duration get _delayDuration => 1.6.seconds;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icon, size: 16),
        const SizedBox(width: 8),
        Text(_text),
      ],
    )
        .animate(
          controller: controller,
          autoPlay: false,
          onComplete: (c) => c.reset(),
        )
        .fade(
          begin: 0,
          end: 1,
          curve: Curves.easeOut,
          duration: _scaleDuration,
        )
        .fade(
          delay: _delayDuration,
          begin: 1,
          end: 0,
          curve: Curves.easeIn,
          duration: _scaleDuration,
        );
  }
}

enum WToggleSaveAnimationType {
  save,
  unsave;
}

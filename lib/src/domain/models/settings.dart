import 'dart:convert';

import 'package:flutter/material.dart';

class Settings {
  final WThemeMode themeMode;
  final ArticlePrefetchRange articlePrefetchRange;
  final ShouldDownloadFullSizeImages shouldDownloadFullSizeImages;
  final Axis doomScrollDirection;

  Settings._({
    required this.themeMode,
    required this.articlePrefetchRange,
    required this.shouldDownloadFullSizeImages,
    required this.doomScrollDirection,
  });

  factory Settings.asDefault() => Settings._(
        themeMode: WThemeMode.system,
        articlePrefetchRange: ArticlePrefetchRange.short,
        shouldDownloadFullSizeImages: ShouldDownloadFullSizeImages.no,
        doomScrollDirection: Axis.vertical,
      );

  Settings copyWith({
    WThemeMode? themeMode,
    ArticlePrefetchRange? articlePrefetchRange,
    ShouldDownloadFullSizeImages? shouldDownloadFullSizeImages,
    Axis? doomScrollDirection,
  }) =>
      Settings._(
        themeMode: themeMode ?? this.themeMode,
        articlePrefetchRange: articlePrefetchRange ?? this.articlePrefetchRange,
        shouldDownloadFullSizeImages:
            shouldDownloadFullSizeImages ?? this.shouldDownloadFullSizeImages,
        doomScrollDirection: doomScrollDirection ?? this.doomScrollDirection,
      );

  Map<String, dynamic> toMap() => {
        'themeMode': themeMode.index,
        'articlePrefetchRange': articlePrefetchRange.index,
        'shouldDownloadFullSizeImages': shouldDownloadFullSizeImages.index,
        'doomScrollDirection': doomScrollDirection.index,
      };

  String toJson() => json.encode(toMap());

  factory Settings.fromMap(Map<String, dynamic> map) {
    try {
      return Settings._(
        themeMode: WThemeMode.values[map['themeMode']],
        articlePrefetchRange:
            ArticlePrefetchRange.values[map['articlePrefetchRange']],
        shouldDownloadFullSizeImages: ShouldDownloadFullSizeImages
            .values[map['shouldDownloadFullSizeImages']],
        doomScrollDirection: Axis.values[map['doomScrollDirection']],
      );
    } catch (e) {
      return Settings.asDefault();
    }
  }

  factory Settings.fromJson(String source) =>
      Settings.fromMap(json.decode(source));
}

enum WThemeMode {
  system,
  light,
  dark,
  pink,
}

enum ArticlePrefetchRange {
  none,
  short,
  medium,
  large;
}

enum ShouldDownloadFullSizeImages {
  yes,
  no,
  wifiOnly;
}

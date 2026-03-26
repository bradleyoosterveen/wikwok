import 'dart:convert';

import 'package:flutter/material.dart';

class Settings {
  static const themeModeKey = 'themeMode';
  static const articlePrefetchRangeKey = 'articlePrefetchRange';
  static const shouldDownloadFullSizeImagesKey = 'shouldDownloadFullSizeImages';
  static const doomScrollDirectionKey = 'doomScrollDirection';
  static const localeKey = 'locale';
  static const versionUpdateLevelKey = 'versionUpdateLevel';

  final WThemeMode themeMode;
  final ArticlePrefetchRange articlePrefetchRange;
  final ShouldDownloadFullSizeImages shouldDownloadFullSizeImages;
  final Axis doomScrollDirection;
  final WLocale locale;
  final VersionUpdateLevel versionUpdateLevel;

  Settings._({
    required this.themeMode,
    required this.articlePrefetchRange,
    required this.shouldDownloadFullSizeImages,
    required this.doomScrollDirection,
    required this.locale,
    required this.versionUpdateLevel,
  });

  factory Settings.asDefault() => Settings._(
    themeMode: WThemeMode.system,
    articlePrefetchRange: ArticlePrefetchRange.short,
    shouldDownloadFullSizeImages: ShouldDownloadFullSizeImages.no,
    doomScrollDirection: Axis.vertical,
    locale: WLocale.system,
    versionUpdateLevel: VersionUpdateLevel.patch,
  );

  Settings copyWith({
    WThemeMode? themeMode,
    ArticlePrefetchRange? articlePrefetchRange,
    ShouldDownloadFullSizeImages? shouldDownloadFullSizeImages,
    Axis? doomScrollDirection,
    WLocale? locale,
    VersionUpdateLevel? versionUpdateLevel,
  }) => Settings._(
    themeMode: themeMode ?? this.themeMode,
    articlePrefetchRange: articlePrefetchRange ?? this.articlePrefetchRange,
    shouldDownloadFullSizeImages:
        shouldDownloadFullSizeImages ?? this.shouldDownloadFullSizeImages,
    doomScrollDirection: doomScrollDirection ?? this.doomScrollDirection,
    locale: locale ?? this.locale,
    versionUpdateLevel: versionUpdateLevel ?? this.versionUpdateLevel,
  );

  Map<String, dynamic> toMap() => {
    themeModeKey: themeMode.index,
    articlePrefetchRangeKey: articlePrefetchRange.index,
    shouldDownloadFullSizeImagesKey: shouldDownloadFullSizeImages.index,
    doomScrollDirectionKey: doomScrollDirection.index,
    localeKey: locale.index,
    versionUpdateLevelKey: versionUpdateLevel.index,
  };

  String toJson() => json.encode(toMap());

  factory Settings.fromMap(Map<String, dynamic> map) {
    try {
      return Settings._(
        themeMode: WThemeMode.values[map.getOrDefault<int>(themeModeKey)],
        articlePrefetchRange: ArticlePrefetchRange
            .values[map.getOrDefault<int>(articlePrefetchRangeKey)],
        shouldDownloadFullSizeImages: ShouldDownloadFullSizeImages
            .values[map.getOrDefault<int>(shouldDownloadFullSizeImagesKey)],
        doomScrollDirection:
            Axis.values[map.getOrDefault<int>(doomScrollDirectionKey)],
        locale: WLocale.values[map.getOrDefault<int>(localeKey)],
        versionUpdateLevel: VersionUpdateLevel
            .values[map.getOrDefault<int>(versionUpdateLevelKey)],
      );
    } catch (e) {
      return Settings.asDefault();
    }
  }

  factory Settings.fromJson(String source) =>
      Settings.fromMap(json.decode(source));
}

enum WThemeMode { system, light, dark, pink }

enum ArticlePrefetchRange { none, short, medium, large }

enum ShouldDownloadFullSizeImages { yes, no, wifiOnly }

enum WLocale { system, en, nl }

enum VersionUpdateLevel { major, minor, patch }

extension on Map<String, dynamic> {
  T getOrDefault<T>(String key) {
    try {
      return this[key] as T;
    } catch (e) {
      final def = Settings.asDefault().toMap();
      return def[key] as T;
    }
  }
}

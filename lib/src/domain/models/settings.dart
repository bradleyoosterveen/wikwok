import 'dart:convert';

import 'package:flutter/material.dart';

class Settings {
  static const _themeModeKey = 'themeMode';
  static const _articlePrefetchRangeKey = 'articlePrefetchRange';
  static const _shouldDownloadFullSizeImagesKey =
      'shouldDownloadFullSizeImages';
  static const _doomScrollDirectionKey = 'doomScrollDirection';
  static const _localeKey = 'locale';

  final WThemeMode themeMode;
  final ArticlePrefetchRange articlePrefetchRange;
  final ShouldDownloadFullSizeImages shouldDownloadFullSizeImages;
  final Axis doomScrollDirection;
  final WLocale locale;

  Settings._({
    required this.themeMode,
    required this.articlePrefetchRange,
    required this.shouldDownloadFullSizeImages,
    required this.doomScrollDirection,
    required this.locale,
  });

  factory Settings.asDefault() => Settings._(
    themeMode: WThemeMode.system,
    articlePrefetchRange: ArticlePrefetchRange.short,
    shouldDownloadFullSizeImages: ShouldDownloadFullSizeImages.no,
    doomScrollDirection: Axis.vertical,
    locale: WLocale.system,
  );

  Settings copyWith({
    WThemeMode? themeMode,
    ArticlePrefetchRange? articlePrefetchRange,
    ShouldDownloadFullSizeImages? shouldDownloadFullSizeImages,
    Axis? doomScrollDirection,
    WLocale? locale,
  }) => Settings._(
    themeMode: themeMode ?? this.themeMode,
    articlePrefetchRange: articlePrefetchRange ?? this.articlePrefetchRange,
    shouldDownloadFullSizeImages:
        shouldDownloadFullSizeImages ?? this.shouldDownloadFullSizeImages,
    doomScrollDirection: doomScrollDirection ?? this.doomScrollDirection,
    locale: locale ?? this.locale,
  );

  Map<String, dynamic> toMap() => {
    _themeModeKey: themeMode.index,
    _articlePrefetchRangeKey: articlePrefetchRange.index,
    _shouldDownloadFullSizeImagesKey: shouldDownloadFullSizeImages.index,
    _doomScrollDirectionKey: doomScrollDirection.index,
    _localeKey: locale.index,
  };

  String toJson() => json.encode(toMap());

  factory Settings.fromMap(Map<String, dynamic> map) {
    try {
      return Settings._(
        themeMode: WThemeMode.values[map.getOrDefault<int>(_themeModeKey)],
        articlePrefetchRange: ArticlePrefetchRange
            .values[map.getOrDefault<int>(_articlePrefetchRangeKey)],
        shouldDownloadFullSizeImages: ShouldDownloadFullSizeImages
            .values[map.getOrDefault<int>(_shouldDownloadFullSizeImagesKey)],
        doomScrollDirection:
            Axis.values[map.getOrDefault<int>(_doomScrollDirectionKey)],
        locale: WLocale.values[map.getOrDefault<int>(_localeKey)],
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

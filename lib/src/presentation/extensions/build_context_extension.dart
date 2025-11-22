import 'package:flutter/widgets.dart';
import 'package:wikwok/src/l10n/app_localizations.dart';
import 'package:wikwok/src/l10n/app_localizations_en.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? AppLocalizationsEn();
}

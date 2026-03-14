import 'package:flutter/cupertino.dart';
import 'package:wikwok/presentation.dart';
import 'package:wikwok/src/l10n/app_localizations.dart';

AppLocalizations? _l10n;

AppLocalizations get l10n {
  final value = _l10n;
  if (value == null) {
    throw StateError(
      'Localization has not been initialized. Call initL10n(context) before accessing l10n.',
    );
  }
  return value;
}

void initL10n(BuildContext context) => _l10n = context.l10n;

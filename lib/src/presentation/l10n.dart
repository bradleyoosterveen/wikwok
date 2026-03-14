import 'package:flutter/cupertino.dart';
import 'package:wikwok/presentation.dart';
import 'package:wikwok/src/l10n/app_localizations.dart';

AppLocalizations? _l10n;

AppLocalizations get l10n => _l10n != null ? _l10n! : throw Exception();

void initL10n(BuildContext context) => _l10n = context.l10n;

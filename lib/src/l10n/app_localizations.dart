import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get go_back;

  /// No description provided for @something_went_wrong_fetching_this_article.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong when fetching this article. Please try again, or submit a bug report.'**
  String get something_went_wrong_fetching_this_article;

  /// No description provided for @connection_error_fetching_this_article.
  ///
  /// In en, this message translates to:
  /// **'Connection error fetching this article. Please check your internet connection and try again. If the problem persists, please submit a bug report.'**
  String get connection_error_fetching_this_article;

  /// No description provided for @visit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get visit;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @your_library_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Your library is empty'**
  String get your_library_is_empty;

  /// No description provided for @add_some_articles_to_your_library.
  ///
  /// In en, this message translates to:
  /// **'Start by doomscrolling through the articles and saving the ones that interest you.'**
  String get add_some_articles_to_your_library;

  /// No description provided for @something_went_wrong_fetching_your_library.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong fetching your library.'**
  String get something_went_wrong_fetching_your_library;

  /// No description provided for @remove_from_library_permanent.
  ///
  /// In en, this message translates to:
  /// **'Remove from library (permanent)'**
  String get remove_from_library_permanent;

  /// No description provided for @remove_all_from_library_permanent.
  ///
  /// In en, this message translates to:
  /// **'Remove all from library (permanent)'**
  String get remove_all_from_library_permanent;

  /// No description provided for @added_to_library.
  ///
  /// In en, this message translates to:
  /// **'Added to library'**
  String get added_to_library;

  /// No description provided for @removed_from_library.
  ///
  /// In en, this message translates to:
  /// **'Removed from library'**
  String get removed_from_library;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get pink;

  /// No description provided for @interface_language.
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get interface_language;

  /// No description provided for @swipe_direction.
  ///
  /// In en, this message translates to:
  /// **'Swipe direction'**
  String get swipe_direction;

  /// No description provided for @vertical.
  ///
  /// In en, this message translates to:
  /// **'Vertical'**
  String get vertical;

  /// No description provided for @horizontal.
  ///
  /// In en, this message translates to:
  /// **'Horizontal'**
  String get horizontal;

  /// No description provided for @article_prefetch_range.
  ///
  /// In en, this message translates to:
  /// **'Article prefetch range'**
  String get article_prefetch_range;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @download_full_size_images.
  ///
  /// In en, this message translates to:
  /// **'Download full size images'**
  String get download_full_size_images;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @wifi_only.
  ///
  /// In en, this message translates to:
  /// **'Wifi only'**
  String get wifi_only;

  /// No description provided for @suggest_feature.
  ///
  /// In en, this message translates to:
  /// **'Suggest feature'**
  String get suggest_feature;

  /// No description provided for @report_a_bug.
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get report_a_bug;

  /// No description provided for @view_source_code.
  ///
  /// In en, this message translates to:
  /// **'View source code'**
  String get view_source_code;

  /// No description provided for @current_version.
  ///
  /// In en, this message translates to:
  /// **'Current version'**
  String get current_version;

  /// No description provided for @donate_to_the_wikimedia_foundation.
  ///
  /// In en, this message translates to:
  /// **'Donate to the Wikimedia Foundation'**
  String get donate_to_the_wikimedia_foundation;

  /// No description provided for @this_app_is_not_affiliated_with_the_wikimedia_foundation.
  ///
  /// In en, this message translates to:
  /// **'This app is not affiliated with, endorsed by, or sponsored by Wikipedia or the Wikimedia Foundation. All trademarks and registered trademarks are the property of their respective owners.'**
  String get this_app_is_not_affiliated_with_the_wikimedia_foundation;

  /// No description provided for @version_available.
  ///
  /// In en, this message translates to:
  /// **'Version {version} available'**
  String version_available(Object version);

  /// No description provided for @a_new_version_is_available.
  ///
  /// In en, this message translates to:
  /// **'A new version is available. Tap the button below to get the latest features and improvements.'**
  String get a_new_version_is_available;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @copy_url.
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get copy_url;

  /// No description provided for @skip_this_version.
  ///
  /// In en, this message translates to:
  /// **'Skip this version'**
  String get skip_this_version;

  /// No description provided for @update_to.
  ///
  /// In en, this message translates to:
  /// **'Update to {version}'**
  String update_to(Object version);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

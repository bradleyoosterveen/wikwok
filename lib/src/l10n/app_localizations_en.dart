// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loading => 'Loading';

  @override
  String get something_went_wrong => 'Something went wrong';

  @override
  String get try_again => 'Try again';

  @override
  String get go_back => 'Go back';

  @override
  String get something_went_wrong_fetching_this_article =>
      'Something went wrong when fetching this article. Please try again, or submit a bug report.';

  @override
  String get connection_error_fetching_this_article =>
      'Connection error fetching this article. Please check your internet connection and try again. If the problem persists, please submit a bug report.';

  @override
  String get visit => 'Visit';

  @override
  String get share => 'Share';

  @override
  String get library => 'Library';

  @override
  String get your_library_is_empty => 'Your library is empty';

  @override
  String get add_some_articles_to_your_library =>
      'Start by doomscrolling through the articles and saving the ones that interest you.';

  @override
  String get something_went_wrong_fetching_your_library =>
      'Something went wrong fetching your library.';

  @override
  String get remove_from_library_permanent => 'Remove from library (permanent)';

  @override
  String get remove_all_from_library_permanent =>
      'Remove all from library (permanent)';

  @override
  String get added_to_library => 'Added to library';

  @override
  String get removed_from_library => 'Removed from library';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get pink => 'Pink';

  @override
  String get interface_language => 'Interface language';

  @override
  String get swipe_direction => 'Swipe direction';

  @override
  String get vertical => 'Vertical';

  @override
  String get horizontal => 'Horizontal';

  @override
  String get article_prefetch_range => 'Article prefetch range';

  @override
  String get none => 'None';

  @override
  String get download_full_size_images => 'Download full size images';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get wifi_only => 'Wifi only';

  @override
  String get suggest_feature => 'Suggest feature';

  @override
  String get report_a_bug => 'Report a bug';

  @override
  String get view_source_code => 'View source code';

  @override
  String get current_version => 'Current version';

  @override
  String get donate_to_the_wikimedia_foundation =>
      'Donate to the Wikimedia Foundation';

  @override
  String get this_app_is_not_affiliated_with_the_wikimedia_foundation =>
      'This app is not affiliated with, endorsed by, or sponsored by Wikipedia or the Wikimedia Foundation. All trademarks and registered trademarks are the property of their respective owners.';

  @override
  String version_available(Object version) {
    return 'Version $version available';
  }

  @override
  String get a_new_version_is_available =>
      'A new version is available. Tap the button below to get the latest features and improvements.';

  @override
  String get update => 'Update';

  @override
  String get copy_url => 'Copy URL';

  @override
  String get skip_this_version => 'Skip this version';

  @override
  String update_to(Object version) {
    return 'Update to $version';
  }
}

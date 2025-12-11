// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get loading => 'Laden';

  @override
  String get something_went_wrong => 'Er is iets misgegaan';

  @override
  String get try_again => 'Probeer opnieuw';

  @override
  String get go_back => 'Ga terug';

  @override
  String get something_went_wrong_fetching_this_article =>
      'Er is iets misgegaan bij het ophalen van dit artikel. Probeer het opnieuw, of maak een bug-report.';

  @override
  String get connection_error_fetching_this_article =>
      'Er is iets misgegaan bij het ophalen van dit artikel. Controleer je internetverbinding en probeer het opnieuw. Als het probleem blijft, maak een bug-report.';

  @override
  String get visit => 'Bezoek';

  @override
  String get share => 'Delen';

  @override
  String get library => 'Bibliotheek';

  @override
  String get your_library_is_empty => 'Je bibliotheek is leeg';

  @override
  String get add_some_articles_to_your_library =>
      'Begin door te doomscrollen door de artikelen heen en sla de artikelen op die jij interessant vindt.';

  @override
  String get something_went_wrong_fetching_your_library =>
      'Er is iets misgegaan bij het ophalen van je bibliotheek.';

  @override
  String get remove_from_library_permanent =>
      'Verwijder uit bibliotheek (permanent)';

  @override
  String get remove_all_from_library_permanent =>
      'Verwijder alles uit bibliotheek (permanent)';

  @override
  String get added_to_library => 'Toegevoegd aan bibliotheek';

  @override
  String get removed_from_library => 'Verwijderd uit bibliotheek';

  @override
  String get settings => 'Instellingen';

  @override
  String get theme => 'Thema';

  @override
  String get system => 'Systeem';

  @override
  String get light => 'Licht';

  @override
  String get dark => 'Donker';

  @override
  String get pink => 'Roze';

  @override
  String get interface_language => 'Interfacetaal';

  @override
  String get swipe_direction => 'Veegrichting';

  @override
  String get vertical => 'Verticaal';

  @override
  String get horizontal => 'Horizontaal';

  @override
  String get article_prefetch_range => 'Artikel prefetch-bereik';

  @override
  String get none => 'Geen';

  @override
  String get download_full_size_images =>
      'Download afbeeldingen op volledige grootte';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get wifi_only => 'Alleen wifi';

  @override
  String get suggest_feature => 'Stel een functie voor';

  @override
  String get report_a_bug => 'Meld een fout';

  @override
  String get view_source_code => 'Bekijk broncode';

  @override
  String get current_version => 'Huidige versie';

  @override
  String get donate_to_the_wikimedia_foundation =>
      'Doneer aan de Wikimedia Foundation';

  @override
  String get this_app_is_not_affiliated_with_the_wikimedia_foundation =>
      'Deze app is niet gelieerd aan, goedgekeurd door, of gesponsord door Wikipedia of de Wikimedia Foundation. Alle handelsmerken en geregistreerde handelsmerken zijn het eigendom van hun respectieve eigenaren.';

  @override
  String version_available(Object version) {
    return 'Versie $version beschikbaar';
  }

  @override
  String get a_new_version_is_available =>
      'Een nieuwe versie is beschikbaar. Tik op de knop hieronder om de nieuwste functies en verbeteringen te krijgen.';

  @override
  String get update => 'Update';

  @override
  String get copy_url => 'Kopieer URL';

  @override
  String get skip_this_version => 'Sla deze versie over';

  @override
  String update_to(Object version) {
    return 'Update naar $version';
  }
}

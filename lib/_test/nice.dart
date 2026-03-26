// ignore_for_file: depend_on_referenced_packages
import 'package:mockito/annotations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikwok/data.dart';
import 'package:wikwok/domain.dart';

@GenerateNiceMocks([
  MockSpec<SharedPreferencesAsync>(),
  MockSpec<GithubService>(),
  MockSpec<PackageInfo>(),
  MockSpec<SettingsRepository>(),
])
// ignore: unused_element, camel_case_types
class _ {}

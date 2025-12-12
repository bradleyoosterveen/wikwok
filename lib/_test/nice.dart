// ignore_for_file: depend_on_referenced_packages
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikwok/data.dart';

@GenerateNiceMocks([
  MockSpec<SharedPreferencesAsync>(),
  MockSpec<GithubService>(),
])
// ignore: unused_element, camel_case_types
class _ {}

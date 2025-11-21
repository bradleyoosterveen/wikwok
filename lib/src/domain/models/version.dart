class Version {
  final int major;
  final int minor;
  final int patch;

  const Version({
    required this.major,
    required this.minor,
    required this.patch,
  });

  factory Version.parse(String version) => Version(
        major: int.parse(version.split('.')[0]),
        minor: int.parse(version.split('.')[1]),
        patch: int.parse(version.split('.')[2]),
      );

  bool isNewerThan(Version other) =>
      major > other.major ||
      (major == other.major && minor > other.minor) ||
      (major == other.major && minor == other.minor && patch > other.patch);

  @override
  String toString() => '$major.$minor.$patch';
}

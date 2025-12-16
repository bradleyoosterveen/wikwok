def parse_version(version_str: str) -> tuple[int, int, int]:
    """
    Args:
        version_str: The version string, e.g., '1.2.3' or '1.2.3+4'.
    """
    version_core: str = version_str.split('+')[0]
    version_parts: list[str] = version_core.split('.')

    if len(version_parts) != 3:
        raise ValueError(f"Version must be in format 'major.minor.patch', got '{version_str}'")

    try:
        major = int(version_parts[0])
        minor = int(version_parts[1])
        patch = int(version_parts[2])
    except Exception as e:
        raise ValueError(f"Version parts must be integers: {e}")

    return major, minor, patch

def format_version(major: int, minor: int, patch: int, build_number: int | None = None) -> str:
    """
    Args:
        major: Major version number.
        minor: Minor version number.
        patch: Patch version number.
        build_number: Optional build number.
    """
    version_str: str = f"{major}.{minor}.{patch}"
    return version_str

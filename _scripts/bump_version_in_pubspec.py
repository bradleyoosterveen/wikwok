import sys
import yaml
from enum import Enum
import argparse
import _utils

class Part(Enum):
    MAJOR = 1
    MINOR = 2
    PATCH = 3

def update_version(path: str, part: Part) -> None:
    try:
        with open(path, 'r') as file:
            pubspec = yaml.safe_load(file)
    except Exception as e:
        raise ValueError(f"File not found: {e}")

    try:
        current_version: str = pubspec['version']
    except Exception as e:
        raise ValueError(f"Could not find key in pubspec file: {e}")

    major: int
    minor: int
    patch: int
    major, minor, patch = _utils.parse_version(current_version)

    if part == Part.MAJOR:
        major += 1
        minor = 0
        patch = 0
    elif part == Part.MINOR:
        minor += 1
        patch = 0
    elif part == Part.PATCH:
        patch += 1

    new_version: str = f"{major}.{minor}.{patch}"

    try:
        build_number: int = int(current_version.split('+')[1])
    except Exception as e:
        raise ValueError(f"Buildnumber must be an interger: {e}")

    pubspec['version'] = f"{new_version}+{build_number + 1}"

    try:
        with open(path, 'w') as file:
            yaml.dump(pubspec, file, sort_keys=False)
    except Exception as e:
        raise ValueError(f"Could not write to file: {e}")

if __name__ == "__main__":
    parser: argparse.ArgumentParser = argparse.ArgumentParser()
    parser.add_argument('--file', type=str, required=True)
    group: argparse._MutuallyExclusiveGroup = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--major', action='store_true')
    group.add_argument('--minor', action='store_true')
    group.add_argument('--patch', action='store_true')

    args = parser.parse_args()

    if args.major:
        part = Part.MAJOR
    elif args.minor:
        part = Part.MINOR
    elif args.patch:
        part = Part.PATCH
    else:
        print("No version part specified.")
        sys.exit(1)

    try:
        update_version(args.file, part)
    except ValueError as e:
        print(e)
        sys.exit(1)

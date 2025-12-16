import yaml
import argparse
import _utils

if __name__ == "__main__":
    parser: argparse.ArgumentParser = argparse.ArgumentParser()
    parser.add_argument('--file', type=str, required=True)

    args = parser.parse_args()

    path: str = args.file

    try:
        with open(path, 'r') as file:
            pubspec = yaml.safe_load(file)
    except Exception as e:
        raise ValueError(f"File not found: {e}")

    try:
        current_version: str = pubspec['version']
    except Exception as e:
        raise ValueError(f"Could not find key in pubspec file: {e}")
    
    version: tuple[int, int, int] = _utils.parse_version(current_version)

    print(_utils.format_version(*version))
import json
import argparse
import sys

def get_version(file: str) -> str:
    try:
        with open(file, 'r') as f:
            data = json.load(f)
    except Exception as e:
        raise ValueError(f"Could not open file: {e}")
    
    try:
        version = data['flutter']
    except Exception as e:
        raise ValueError(f"Unable to find version: {e}")
    
    return version

if __name__ == "__main__":
    parser: argparse.ArgumentParser = argparse.ArgumentParser()
    parser.add_argument('--file', type=str, required=True)

    args = parser.parse_args()

    try:
        print(get_version(args.file))
    except ValueError as e:
        print(e)
        sys.exit(1)

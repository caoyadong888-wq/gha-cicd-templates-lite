"""Print the sample health payload as JSON."""

import json

from healthcheck.app import health


def main() -> None:
    print(json.dumps(health()))


if __name__ == "__main__":
    main()

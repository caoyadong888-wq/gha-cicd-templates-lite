#!/usr/bin/env bash
# Run the Python example the same way as .github-templates/python-ci.yml:
# install requirements, ruff check, pytest. Uses the python:3.12 image.
set -eu

ROOT="$(cd "$(dirname "$0")" && pwd)"
APP="${ROOT}/examples/python-app"

# Bridge DNS is enough on a normal Docker install. If it cannot resolve
# the package index, retry on the host network.
net=()
if ! docker run --rm python:3.12 python -c 'import socket; socket.getaddrinfo("pypi.org", 443)' >/dev/null 2>&1; then
  net=(--network host)
fi

docker run --rm "${net[@]}" \
  -e PYTHONDONTWRITEBYTECODE=1 \
  -e PIP_DISABLE_PIP_VERSION_CHECK=1 \
  -e PIP_ROOT_USER_ACTION=ignore \
  -v "${APP}:/app:ro" \
  -w /app \
  python:3.12 \
  bash -lc 'python -m pip install -q --upgrade pip && python -m pip install -q -r requirements.txt -r requirements-dev.txt && ruff check --no-cache . && pytest'

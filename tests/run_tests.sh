#!/usr/bin/env bash
# Preview checks: actionlint, yamllint, and the Python demo.
# Prints PASS or FAIL for each check. Writes tests/RESULTS.md.
# Removes containers and volumes named gha-tpl-lite-* on exit.
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "${ROOT}"

TMP="$(mktemp -d)"
CHECKS="${TMP}/checks.txt"
DETAIL="${TMP}/detail.txt"
VERSIONS="${TMP}/versions.txt"
FAILS=0
DONE=0

: > "${CHECKS}"
: > "${DETAIL}"
: > "${VERSIONS}"

log() {
  printf '%s\n' "$1" | tee -a "${CHECKS}"
}

detail() {
  printf '%s\n' "$1" >> "${DETAIL}"
}

mark() {
  local name="$1"
  local code="$2"
  if [ "${code}" -eq 0 ]; then
    log "PASS: ${name}"
  else
    log "FAIL: ${name}"
    FAILS=$((FAILS + 1))
  fi
}

cleanup_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    return 0
  fi
  docker ps -aq --filter "name=gha-tpl-lite-" | while IFS= read -r id; do
    [ -n "${id}" ] || continue
    docker rm -f "${id}" >/dev/null 2>&1 || true
  done
  docker volume ls -q --filter "name=gha-tpl-lite-" | while IFS= read -r vol; do
    [ -n "${vol}" ] || continue
    docker volume rm "${vol}" >/dev/null 2>&1 || true
  done
}

finish() {
  [ "${DONE}" -eq 0 ] || return 0
  DONE=1
  local date_utc
  date_utc="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  mkdir -p "${ROOT}/tests"
  python3 - "${date_utc}" "${VERSIONS}" "${CHECKS}" "${DETAIL}" "${ROOT}/tests/RESULTS.md" << 'PY' || true
import socket, sys
from pathlib import Path
date, versions, checks, detail, dest = sys.argv[1:]
text_parts = [Path(versions).read_text(), Path(checks).read_text(), Path(detail).read_text()]
hosts = {socket.gethostname(), socket.getfqdn()}
def anonymize(text):
    for host in hosts:
        if host and host != "demo-host":
            text = text.replace(host, "demo-host")
    return text
body = """# Test results

Date: {date}

## Tool versions

```
{versions}
```

## Checks

```
{checks}
```

## Command output

```
{detail}
```
""".format(
    date=date,
    versions=anonymize(text_parts[0]).rstrip(),
    checks=anonymize(text_parts[1]).rstrip(),
    detail=anonymize(text_parts[2]).rstrip(),
)
Path(dest).write_text(body, encoding="utf-8")
PY
  cleanup_docker
  rm -rf "${TMP}"
  if [ "${FAILS}" -ne 0 ]; then
    exit 1
  fi
}
trap finish EXIT

run_check() {
  local name="$1"
  shift
  detail ""
  detail "\$ ${name}"
  "$@" > "${TMP}/one.out" 2>&1
  local code=$?
  printf 'exit code: %s\n' "${code}" >> "${TMP}/one.out"
  cat "${TMP}/one.out" >> "${DETAIL}"
  mark "${name}" "${code}"
  return 0
}

check_actionlint() {
  echo "\$ actionlint -version"
  docker run --rm "${DOCKER_NET[@]}" rhysd/actionlint:latest -version
  echo
  echo "\$ actionlint .github-templates/*.yml"
  local args=()
  local file
  while IFS= read -r file; do
    args+=(".github-templates/${file}")
  done < <(find .github-templates -maxdepth 1 -name '*.yml' -printf '%f\n' | sort)
  docker run --rm "${DOCKER_NET[@]}" --name gha-tpl-lite-actionlint \
    -v "${ROOT}:/work:ro" \
    -w /work \
    rhysd/actionlint:latest \
    "${args[@]}"
}

check_yamllint() {
  docker run --rm "${DOCKER_NET[@]}" --name gha-tpl-lite-yamllint \
    -e PIP_DISABLE_PIP_VERSION_CHECK=1 \
    -e PIP_ROOT_USER_ACTION=ignore \
    -e PYTHONDONTWRITEBYTECODE=1 \
    -v "${ROOT}:/work:ro" \
    -w /work \
    python:3.12 \
    bash -lc 'python -m pip install -q "yamllint==1.35.1" && echo "yamllint $(yamllint --version)" && python --version && yamllint -c .yamllint.yml .'
}

check_demo() {
  ./demo.sh
}

check_phrases() {
  local missing=0
  local phrase
  local phrases=(
    "Deliverables / 交付物清单"
    "Estimated setup time / 预计部署时间"
    "make demo"
    "中文说明"
    "Full version / 完整版"
    "https://caoyadong.gumroad.com/l/zbggp"
    "https://caoyadong.gumroad.com/l/yvmcqj"
    "\$9"
  )
  for phrase in "${phrases[@]}"; do
    if ! grep -F -q "${phrase}" README.md; then
      printf 'missing README phrase: %s\n' "${phrase}"
      missing=1
    else
      printf 'found README phrase: %s\n' "${phrase}"
    fi
  done
  local files=(
    LICENSE
    demo.sh
    Makefile
    scripts/install-workflows.sh
    .github-templates/python-ci.yml
    .github-templates/docker-build-push.yml
    examples/python-app/tests/test_app.py
    screenshots/actionlint.png
    screenshots/example-tests.png
  )
  local file
  for file in "${files[@]}"; do
    if [ ! -f "${file}" ]; then
      printf 'missing file: %s\n' "${file}"
      missing=1
    fi
  done
  if [ -d .github-templates ]; then
    local extra
    extra="$(find .github-templates -maxdepth 1 -name '*.yml' ! -name 'python-ci.yml' ! -name 'docker-build-push.yml' -printf '%f\n')"
    if [ -n "${extra}" ]; then
      printf 'unexpected workflow in preview:\n%s\n' "${extra}"
      missing=1
    fi
  fi
  if ! grep -q 'Permission is hereby granted' LICENSE; then
    echo "LICENSE is not MIT"
    missing=1
  fi
  return "${missing}"
}

check_screenshots() {
  python3 - << 'PY'
from PIL import Image
from pathlib import Path
for name in ("screenshots/actionlint.png", "screenshots/example-tests.png"):
    im = Image.open(name)
    if im.format != "PNG":
        raise SystemExit(f"{name} is {im.format}")
    if im.size[0] < 1000 or im.size[1] < 600:
        raise SystemExit(f"{name} is small: {im.size}")
    print(f"{name} {im.format} {im.size}")
parent = Path("../screenshots")
if parent.is_dir():
    import filecmp
    for name in ("actionlint.png", "example-tests.png"):
        left = Path("screenshots") / name
        right = parent / name
        if right.is_file() and not filecmp.cmp(left, right, shallow=False):
            raise SystemExit(f"{name} differs from the full pack screenshot")
        if right.is_file():
            print(f"{name} matches ../screenshots/{name}")
PY
}

check_secrets() {
  local code=0
  local file
  while IFS= read -r file; do
    if grep -nE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "${file}"; then
      printf 'email-like string in %s\n' "${file}"
      code=1
    fi
    if grep -nE '\b(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[0-1])\.[0-9]{1,3}\.[0-9]{1,3})\b' "${file}"; then
      printf 'private IP in %s\n' "${file}"
      code=1
    fi
    if grep -nE 'BEGIN (OPENSSH |RSA |EC |DSA )?PRIVATE KEY' "${file}"; then
      printf 'private key block in %s\n' "${file}"
      code=1
    fi
  done < <(find . -type f \
    -not -path './.git/*' \
    -not -path './screenshots/*' \
    -not -name '*.png' \
    -not -name 'RESULTS.md')
  if [ "${code}" -eq 0 ]; then
    echo "no emails, private-network IPs, or private key blocks"
  fi
  return "${code}"
}

cleanup_docker

DOCKER_NET=()
if ! docker run --rm python:3.12 python -c 'import socket; socket.getaddrinfo("pypi.org", 443)' >/dev/null 2>&1; then
  DOCKER_NET=(--network host)
fi

if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
  log "FAIL: docker is not available"
  FAILS=$((FAILS + 1))
  exit 1
fi

{
  echo "actionlint:"
  docker run --rm "${DOCKER_NET[@]}" rhysd/actionlint:latest -version
  echo "python image:"
  docker run --rm "${DOCKER_NET[@]}" python:3.12 python --version
  echo "pinned in examples/python-app/requirements-dev.txt:"
  cat examples/python-app/requirements-dev.txt
  echo "yamllint: 1.35.1 installed in the yamllint check (python:3.12)"
  echo "pillow:"
  python3 -c 'import PIL; print(PIL.__version__)'
} > "${VERSIONS}" 2>&1

run_check "actionlint (.github-templates)" check_actionlint
run_check "yamllint" check_yamllint
run_check "python:3.12 demo (ruff + pytest)" check_demo
run_check "readme and required files" check_phrases
run_check "screenshots" check_screenshots
run_check "secret scan" check_secrets

log "checks failed: ${FAILS}"
if [ "${FAILS}" -eq 0 ]; then
  log "PASS: all checks"
fi

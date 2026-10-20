#!/usr/bin/env bash
# Copy .github-templates into .github/workflows.
# Rewrites the reusable-workflow uses path so GitHub can call it.
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${ROOT}/.github-templates"
DEST="${ROOT}/.github/workflows"

if [ ! -d "${SRC}" ]; then
  printf 'Missing %s\n' "${SRC}" >&2
  exit 1
fi

mkdir -p "${DEST}"
count=0
for src in "${SRC}"/*.yml; do
  [ -f "${src}" ] || continue
  base="$(basename "${src}")"
  sed 's#\./\.github-templates/reusable-python-ci\.yml#./.github/workflows/reusable-python-ci.yml#g' \
    "${src}" > "${DEST}/${base}"
  count=$((count + 1))
  printf 'installed %s\n' "${base}"
done

printf 'Installed %s workflow(s) into .github/workflows\n' "${count}"

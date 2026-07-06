#!/usr/bin/env bash

set -ex

if [[ -z "${GH_TOKEN}" ]] && [[ -z "${GITHUB_TOKEN}" ]] && [[ -z "${GH_ENTERPRISE_TOKEN}" ]] && [[ -z "${GITHUB_ENTERPRISE_TOKEN}" ]]; then
  echo "Will not release because no GITHUB_TOKEN defined"
  exit 1
fi

if [[ -z "${TAG_NAME}" ]]; then
  echo "Will not release because no TAG_NAME defined"
  exit 1
fi

if [[ -z "${GIT_REPOSITORY}" ]]; then
  echo "Will not release because no GIT_REPOSITORY defined"
  exit 1
fi

if [[ -z "${ASSET_PATH}" ]]; then
  echo "Will not release because no ASSET_PATH defined"
  exit 1
fi

if [[ -z "${ASSET_NAME}" ]]; then
  ASSET_NAME="$(basename "${ASSET_PATH}")"
fi

if [[ $( gh release view "${TAG_NAME}" --repo "${GIT_REPOSITORY}" 2>&1 ) =~ "release not found" ]]; then
  gh release create "${TAG_NAME}" --repo "${GIT_REPOSITORY}" --title "Release ${TAG_NAME}"
fi

gh release upload --repo "${GIT_REPOSITORY}" "${TAG_NAME}" --clobber "${ASSET_PATH}#${ASSET_NAME}"

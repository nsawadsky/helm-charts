#!/usr/bin/env bash
#
# Ping Identity DevOps - CI scripts
#
# Push docker build changes to github
#
test "${VERBOSE}" = "true" && set -x

if test -z "${CI_COMMIT_REF_NAME}"; then
    CI_PROJECT_DIR="$(
        cd "$(dirname "${0}")/.." || exit 97
        pwd
    )"
    test -z "${CI_PROJECT_DIR}" && echo "Invalid call to dirname ${0}" && exit 97
fi
CI_SCRIPTS_DIR="${CI_PROJECT_DIR:-.}/ci_scripts"
# shellcheck source=./ci_tools.lib.sh
. "${CI_SCRIPTS_DIR}/ci_tools.lib.sh"

rm -rf ~/tmp/build
mkdir -p ~/tmp/build && cd ~/tmp/build || exit 9

git clone "https://${GITLAB_USER}:${GITLAB_TOKEN}@${INTERNAL_GITLAB_URL}/devops-program/helm-charts"
cd helm-charts || exit 97

git remote add gh_location "https://${GITHUB_OWNER}:${GITHUB_TOKEN}@github.com/${GITHUB_TARGET_REPO}.git"

if test -n "$CI_COMMIT_TAG"; then
    git push --force gh_location "$CI_COMMIT_TAG"
fi

git push --force gh_location master

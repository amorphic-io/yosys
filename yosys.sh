#!/usr/bin/env bash
set -eu

# Copy-pasted from the Bazel Bash runfiles library v3.
set -uo pipefail; set +e; f=bazel_tools/tools/bash/runfiles/runfiles.bash
# shellcheck disable=SC1090
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
    source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
    source "$0.runfiles/$f" 2>/dev/null || \
    source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
    source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
    { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e


seed_file_path=$(rlocation yosys/techlibs/techmap.v)
techlibs_path=$(dirname $(realpath --no-symlinks $seed_file_path))
yosys_bin=$(rlocation yosys/yosys-bin)
abc_bin=$(rlocation abc/abc_bin)

export YOSYS_DATDIR="${YOSYS_DATDIR:-$techlibs_path}/"
export ABC="${ABC:-$abc_bin}"

exec "$yosys_bin" "$@"

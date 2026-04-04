#!/usr/bin/env bash
set -eu -o pipefail
source ./config.sh

"${VENV_DIR}/bin/python3" ./router_setup.py "$@"

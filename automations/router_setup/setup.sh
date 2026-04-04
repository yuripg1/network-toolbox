#!/usr/bin/env bash
set -eu -o pipefail
source ./config.sh

python3 -m venv ${VENV_DIR}
${VENV_DIR}/bin/pip3 install -r ./requirements.txt

VENV_DIR="./.venv"
python3 -m venv "${VENV_DIR}"
"${VENV_DIR}/bin/pip3" install -r ./requirements.txt

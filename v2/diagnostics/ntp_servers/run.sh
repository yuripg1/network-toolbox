VENV_DIR="./.venv"
python3 -m venv "${VENV_DIR}"
source "${VENV_DIR}/bin/activate"
pip3 install -r ./requirements.txt
echo "######################## Scapy requires root privileges to send packets. Proceed with caution. #########################"
sudo "${VENV_DIR}/bin/python3" ntp_servers.py "$@"

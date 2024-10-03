## NTP test script

### Setup

```
$ sudo apt update
$ sudo apt install -y python3-dev python3-pip python3-venv
$ python3 -m venv network-toolbox-venv
$ source ./network-toolbox-venv/bin/activate
$ pip3 install dnspython scapy
```

### Run

```
$ sudo ./network-toolbox-venv/bin/python3 ./ntp_test.py
```

### Teardown

```
$ deactivate
```

### Resources

* [ntp_test.py](./ntp_test.py)
* [ntp_test_output_vivo.csv](./ntp_test_output_vivo.csv)
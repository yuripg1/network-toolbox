## Router setup script

### Setup

```
$ sudo apt update
$ sudo apt install -y python3-dev python3-pip python3-venv
$ python3 -m venv router-setup-venv
$ source ./router-setup-venv/bin/activate
$ pip3 install paramiko
```

### Run

```
$ python3 ./router_setup.py
```

### Teardown

```
$ deactivate
```

### Resources

* [router_setup.py](./router_setup.py)

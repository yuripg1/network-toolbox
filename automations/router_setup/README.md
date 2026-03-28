# Router setup

## Summary

This automation implements an interpreter that, given a file containing instructions to configure a router, processes it, connects to the router via SSH and configures it. It supports variable addresses, variable authentication credentials, multiple connections/disconnections and file uploads via SCP.

## Syntax

### Basics

* All the interpreted instruction lines begin with **#ROUTER_SETUP:**
* All lines that begin with **#** (excepting **#ROUTER_SETUP:**, of course) are considered comments and ignored by the interpreter
* All empty lines are ignored
* Some instructions are accompanied by arguments in JSON format
* In the sections of the interpreted file where the automation is active, all non-empty lines are considered as commands to be executed

### Instructions

| Instruction      | Description |
|:----------------:|:------------|
| START:           | Activates the automation |
| END:             | Deactivates the automation |
| CONNECT:         | Connects to the router via SSH |
| DISCONNECT:      | Closes the SSH connection to the router |
| RUN_COMMANDS:    | Sends one or more commands to the router via SSH |
| UPLOAD_FILES:    | Uploads one or more files to a directory in the router |
| CONFIRM:         | Shows a custom message and waits for the user to press ENTER before continuing. Useful when you want to instruct the person running the automation to do things like plug a cable in |
| WAIT:            | Sleeps for a defined time of seconds. Useful when you need to wait for background changes, like the establishment of a tunnel, before proceeding with the rest of the automation |
| SET_ENVIRONMENT: | Sets the environment variables. Mainly used to define what authentication credentials to use when connecting via SSH |

### Examples

```
#ROUTER_SETUP:START:

#ROUTER_SETUP:END:

#ROUTER_SETUP:CONNECT:

#ROUTER_SETUP:END:

#ROUTER_SETUP:RUN_COMMANDS:{"commands":["commit","save"]}

#ROUTER_SETUP:UPLOAD_FILES:{"local_files":["../procedures/keys_and_certificates_creation/certificate_authority.crt","../procedures/keys_and_certificates_creation/management_https.crt","../procedures/keys_and_certificates_creation/management_https.key","../procedures/keys_and_certificates_creation/openvpn_server.crt","../procedures/keys_and_certificates_creation/openvpn_server.key","../procedures/keys_and_certificates_creation/openvpn_server_dh.pem","./firewall.sh"],"remote_directory":"/home/username920169077"}

#ROUTER_SETUP:CONFIRM:{"message":"Connect to eth0"}

#ROUTER_SETUP:WAIT:{"time_in_seconds":15}

#ROUTER_SETUP:SET_ENVIRONMENT:{"hostname":"192.168.1.1","port":22,"username":"ubnt","password":"ubnt"}
```

A fully functioning example can be seen in this **[commands.txt](../../ubiquiti_edgeos/commands.txt)** file

---

## How to run

### Setup

```shell
$ sudo apt update
$ sudo apt install -y python3-dev python3-pip python3-venv
$ chmod +x ./setup.sh
$ ./setup.sh
$ chmod +x ./run.sh
```

### Run

```shell
$ ./run.sh --instructions-file ../../ubiquiti_edgeos/commands.txt
```

### Manual

```
usage: run.sh [-h] --instructions-file INSTRUCTIONS_FILE [--dry-run]

Automate router configuration via SSH

options:
  -h, --help            show this help message and exit
  --instructions-file INSTRUCTIONS_FILE
                        Path to the instructions file to be processed
  --dry-run             Dry run of the instructions without connecting to the router
```

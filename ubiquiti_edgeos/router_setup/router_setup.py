import paramiko
import time

session_info = {
    "hostname": "",
    "username": "",
    "password": "",
    "port": 0,
    "client": None,
    "shell": None,
}

def connect():
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    print(f"Connecting to {session_info['username']}@{session_info['hostname']}...")
    client.connect(
        hostname=session_info["hostname"],
        port=session_info["port"],
        username=session_info["username"],
        password=session_info["password"],
        look_for_keys=False,
        allow_agent=False
    )
    shell = client.invoke_shell()
    time.sleep(15)
    session_info["client"] = client
    session_info["shell"] = shell
    print("Connected.")

def disconnect():
    if session_info["client"]:
        session_info["client"].close()
        session_info["client"] = None
        session_info["shell"] = None
        print("Disconnected.")

def send_command(cmd):
    shell = session_info["shell"]
    if not shell:
        raise Exception("Not connected.")
    print(f"Running command: {cmd}")
    shell.send(cmd + '\n')
    output = ""
    while True:
        time.sleep(0.25)
        output += shell.recv(65535).decode()
        stripped_output = output.rstrip()
        if stripped_output[len(stripped_output) - 1] in ("#", "$"):
            break
    print(output)

def prompt(message):
    input(message + " | Press Enter to continue...")

def process_actions(commands):
    automation_active = False
    uncommited_changes = 0
    for line in commands.strip().splitlines():
        line = line.strip()
        if automation_active == True:
            if line.startswith("#PROMPT:"):
                prompt(line.partition(":")[2].strip())
            elif line.startswith("#HOSTNAME:"):
                new_hostname = line.partition(":")[2].strip()
                session_info["hostname"] = new_hostname
                print(f"Hostname set to {new_hostname}")
            elif line.startswith("#PORT:"):
                new_port = int(line.partition(":")[2].strip())
                session_info["port"] = new_port
                print(f"Port set to {str(new_port)}")
            elif line.startswith("#USERNAME:"):
                new_username = line.partition(":")[2].strip()
                session_info["username"] = new_username
                print(f"Username set to {new_username}")
            elif line.startswith("#PASSWORD:"):
                new_password = line.partition(":")[2].strip()
                session_info["password"] = new_password
                print("Password set")
            elif line.startswith("#CONNECT:"):
                connect()
            elif line.startswith("#CONFIGURE:"):
                send_command("configure")
            elif line.startswith("#EXIT:"):
                send_command("exit")
            elif line.startswith("#DISCONNECT:"):
                disconnect()
            elif line.startswith("#WAIT:"):
                seconds_to_wait = int(line.partition(":")[2].strip())
                print(f"Waiting for {str(seconds_to_wait)} seconds")
                time.sleep(seconds_to_wait)
            elif line.startswith("#ENDAUTOMATION:"):
                automation_active = False
            elif line.startswith("#"):
                pass
            elif len(line) == 0:
                if uncommited_changes > 0:
                    send_command("commit")
                    uncommited_changes = 0
            else:
                send_command(line)
                uncommited_changes += 1
        else:
            if line.startswith("#STARTAUTOMATION:"):
                automation_active = True

with open("../commands.txt", "r") as commands_file:
    commands = commands_file.read()

if __name__ == "__main__":
    process_actions(commands)

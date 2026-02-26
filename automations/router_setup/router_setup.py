import argparse
import dataclasses
import json
import paramiko
import pathlib
import scp
import time
import typing

INSTRUCTION_PREFIX = "#ROUTER_SETUP:"
COMMENT_PREFIX = "#"
PROMPT_READY_MARKERS = ("$", "#", ">")
PROMPT_WAIT_TIME_STEP = 0.1
PROMPT_OUTPUT_CHUNK_SIZE = 4096
OUTPUTS_FILE_PATH = "./output.log"
OUTPUTS_REDACTED_REPLACEMENT = "[*]"

InstructionType = typing.Literal[
    "START:",
    "END:",
    "CONNECT:",
    "DISCONNECT:",
    "RUN_COMMANDS:",
    "UPLOAD_FILES:",
    "CONFIRM:",
    "WAIT:",
    "SET_ENVIRONMENT:",
]


@dataclasses.dataclass
class InstructionArguments:
    commands: list[str] | None = None
    local_files: list[str] | None = None
    remote_directory: str | None = None
    message: str | None = None
    time_in_seconds: float | None = None
    hostname: str | None = None
    port: int | None = None
    username: str | None = None
    password: str | None = None


@dataclasses.dataclass
class Instruction:
    type: InstructionType
    arguments: InstructionArguments


@dataclasses.dataclass
class SSHInfo:
    is_connected: bool
    outputs_file_path: str
    outputs_redacted_replacement: str
    outputs_redacted_values: list[str] = dataclasses.field(default_factory=list)
    connection_index: int = 0
    connection_outputs: list[str] = dataclasses.field(default_factory=list)
    client: paramiko.SSHClient | None = None
    shell: paramiko.Channel | None = None


@dataclasses.dataclass
class Environment:
    hostname: str = ""
    port: int = 0
    username: str = ""
    password: str = ""


@dataclasses.dataclass
class SessionInfo:
    instructions_file_path: pathlib.Path
    is_active: bool
    instruction_prefix: str
    comment_prefix: str
    prompt_ready_markers: tuple[str]
    prompt_wait_time_step: float
    prompt_output_chunk_size: int
    environment: Environment
    ssh_info: SSHInfo


def wait_for_ready_prompt(session_info: SessionInfo) -> str:
    output = ""
    while True:
        time.sleep(session_info.prompt_wait_time_step)
        if session_info.ssh_info.shell.recv_ready():
            output += session_info.ssh_info.shell.recv(session_info.prompt_output_chunk_size).decode(errors="ignore")
            if output.rstrip().endswith(session_info.prompt_ready_markers):
                return output


def get_ssh_client(environment: Environment) -> paramiko.SSHClient:
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_client.connect(
        hostname=environment.hostname,
        port=environment.port,
        username=environment.username,
        password=environment.password,
        look_for_keys=False,
        allow_agent=False,
    )
    return ssh_client


def connect(session_info: SessionInfo) -> None:
    session_info.ssh_info.connection_index = len(session_info.ssh_info.connection_outputs)
    session_info.ssh_info.connection_outputs.append("")
    session_info.ssh_info.client = get_ssh_client(session_info.environment)
    session_info.ssh_info.shell = session_info.ssh_info.client.invoke_shell()
    session_info.ssh_info.connection_outputs[session_info.ssh_info.connection_index] += wait_for_ready_prompt(
        session_info
    )


def disconnect(session_info: SessionInfo) -> None:
    session_info.ssh_info.client.close()
    session_info.ssh_info.client = None
    session_info.ssh_info.shell = None


def run_commands(instruction_arguments: InstructionArguments, session_info: SessionInfo) -> list[str]:
    outputs: list[str] = []
    for command in instruction_arguments.commands:
        session_info.ssh_info.shell.send(command + "\n")
        session_info.ssh_info.connection_outputs[session_info.ssh_info.connection_index] += wait_for_ready_prompt(
            session_info
        )
    return outputs


def upload_files(instruction_arguments: InstructionArguments, session_info: SessionInfo) -> None:
    local_files_absolute_paths: list[str] = []
    for local_file in instruction_arguments.local_files:
        perspective_file_path = session_info.instructions_file_path.resolve()
        local_file_absolute_path = (perspective_file_path.parent / local_file).resolve()
        local_files_absolute_paths.append(str(local_file_absolute_path))
    ssh_client = get_ssh_client(session_info.environment)
    scp_client = scp.SCPClient(ssh_client.get_transport())
    scp_client.put(local_files_absolute_paths, instruction_arguments.remote_directory)
    scp_client.close()
    ssh_client.close()


def set_environment(instruction_arguments: InstructionArguments, session_info: SessionInfo) -> None:
    if instruction_arguments.hostname is not None:
        session_info.environment.hostname = instruction_arguments.hostname
    if instruction_arguments.port is not None:
        session_info.environment.port = instruction_arguments.port
    if instruction_arguments.username is not None:
        session_info.environment.username = instruction_arguments.username
    if instruction_arguments.password is not None:
        session_info.environment.password = instruction_arguments.password
        session_info.ssh_info.outputs_redacted_values.append(session_info.environment.password)


def get_instruction_arguments(instruction_line: str, prefix: str) -> InstructionArguments:
    instruction_aguments: InstructionArguments = InstructionArguments()
    instruction_arguments_partition = instruction_line.partition(prefix)[2]
    if len(instruction_arguments_partition) == 0:
        return instruction_aguments
    instruction_arguments_object = json.loads(instruction_arguments_partition)
    if "commands" in instruction_arguments_object is not None:
        instruction_aguments.commands = []
        for command in instruction_arguments_object["commands"]:
            instruction_aguments.commands.append(command)
    if "local_files" in instruction_arguments_object is not None:
        instruction_aguments.local_files = []
        for local_file in instruction_arguments_object["local_files"]:
            instruction_aguments.local_files.append(local_file)
    if "remote_directory" in instruction_arguments_object is not None:
        instruction_aguments.remote_directory = instruction_arguments_object["remote_directory"]
    if "message" in instruction_arguments_object is not None:
        instruction_aguments.message = instruction_arguments_object["message"]
    if "time_in_seconds" in instruction_arguments_object is not None:
        instruction_aguments.time_in_seconds = float(instruction_arguments_object["time_in_seconds"])
    if "hostname" in instruction_arguments_object is not None:
        instruction_aguments.hostname = instruction_arguments_object["hostname"]
    if "port" in instruction_arguments_object is not None:
        instruction_aguments.port = int(instruction_arguments_object["port"])
    if "username" in instruction_arguments_object is not None:
        instruction_aguments.username = instruction_arguments_object["username"]
    if "password" in instruction_arguments_object is not None:
        instruction_aguments.password = instruction_arguments_object["password"]
    return instruction_aguments


def get_instruction_type(instruction_line: str, prefix: str) -> InstructionType | None:
    instruction_type_partition = instruction_line.partition(prefix)[2]
    if instruction_type_partition.startswith("START"):
        return "START:"
    if instruction_type_partition.startswith("END"):
        return "END:"
    if instruction_type_partition.startswith("CONNECT"):
        return "CONNECT:"
    if instruction_type_partition.startswith("DISCONNECT"):
        return "DISCONNECT:"
    if instruction_type_partition.startswith("RUN_COMMANDS:"):
        return "RUN_COMMANDS:"
    if instruction_type_partition.startswith("UPLOAD_FILES:"):
        return "UPLOAD_FILES:"
    if instruction_type_partition.startswith("CONFIRM:"):
        return "CONFIRM:"
    if instruction_type_partition.startswith("WAIT:"):
        return "WAIT:"
    if instruction_type_partition.startswith("SET_ENVIRONMENT:"):
        return "SET_ENVIRONMENT:"
    return None


def decode_instruction_line(instruction_line: str, session_info: SessionInfo) -> Instruction | None:
    trimmed_instruction_line = instruction_line.strip()
    if len(trimmed_instruction_line) == 0:
        return None
    elif trimmed_instruction_line.startswith(session_info.instruction_prefix):
        instruction_type = get_instruction_type(trimmed_instruction_line, session_info.instruction_prefix)
        if instruction_type is None:
            return None
        instruction_arguments = get_instruction_arguments(
            trimmed_instruction_line, session_info.instruction_prefix + instruction_type
        )
        return Instruction(
            type=instruction_type,
            arguments=instruction_arguments,
        )
    elif trimmed_instruction_line.startswith(session_info.comment_prefix):
        return None
    elif session_info.is_active == True:
        return Instruction(
            type="RUN_COMMANDS:",
            arguments=InstructionArguments(commands=[trimmed_instruction_line]),
        )
    return None


def process_single_instruction_line(session_info: SessionInfo, instruction_line: str) -> None:
    instruction_data = decode_instruction_line(instruction_line, session_info)
    if instruction_data is None:
        return
    match instruction_data.type:
        case "START:":
            if session_info.is_active == True:
                print("Warning: Could not start | Reason: Automation already started")
                return
            session_info.is_active = True
        case "END:":
            if session_info.is_active == False:
                print("Warning: Could not end | Reason: Automation already ended or never started")
                return
            session_info.is_active = False
        case "CONNECT:":
            if session_info.is_active == False:
                print("Warning: Could not connect | Reason: Automation not started")
                return
            if session_info.ssh_info.is_connected == True:
                print("Warning: Could not connect | Reason: Automation already connected")
                return
            print(f"Connecting to {session_info.environment.username}@{session_info.environment.hostname}")
            connect(session_info)
            print("Connected")
            session_info.ssh_info.is_connected = True
        case "DISCONNECT:":
            if session_info.is_active == False:
                print("Warning: Could not disconnect | Reason: Automation not started")
                return
            if session_info.ssh_info.is_connected == False:
                print("Warning: Could not disconnect | Reason: Automation not connected")
                return
            disconnect(session_info)
            print("Disconnected")
            session_info.ssh_info.is_connected = False
            session_info.ssh_info.connection_index += 1
        case "RUN_COMMANDS:":
            if session_info.is_active == False:
                print("Warning: Could not run commands | Reason: Automation not started")
                return
            if session_info.ssh_info.is_connected == False:
                print("Warning: Could not run commands | Reason: Automation not connected")
                return
            print(f"Running commands: {"; ".join(instruction_data.arguments.commands)}")
            run_commands(instruction_data.arguments, session_info)
        case "UPLOAD_FILES:":
            print(
                f"Uploading files: {"; ".join(instruction_data.arguments.local_files)} > {instruction_data.arguments.remote_directory}"
            )
            upload_files(instruction_data.arguments, session_info)
            print("Files uploaded successfully")
        case "CONFIRM:":
            input(instruction_data.arguments.message + " | Press ENTER to continue...")
        case "WAIT:":
            print(f"Waiting for {instruction_data.arguments.time_in_seconds} seconds...")
            time.sleep(instruction_data.arguments.time_in_seconds)
        case "SET_ENVIRONMENT:":
            set_environment(instruction_data.arguments, session_info)


def process_instruction_lines(session_info: SessionInfo) -> None:
    with session_info.instructions_file_path.open("r") as file:
        instruction_lines = file.readlines()
        for instruction_line in instruction_lines:
            process_single_instruction_line(session_info, instruction_line)


def redact_sensitive_information(connection_output: str, ssh_info: SSHInfo) -> str:
    redacted_output = connection_output
    ssh_info.outputs_redacted_values.sort(key=len, reverse=True)
    for redact_value in ssh_info.outputs_redacted_values:
        if len(redact_value) > 0:
            redacted_output = redacted_output.replace(redact_value, ssh_info.outputs_redacted_replacement)
    return redacted_output


def save_outputs(ssh_info: SSHInfo) -> None:
    with open(ssh_info.outputs_file_path, mode="a") as outputs_file:
        for connection_output in ssh_info.connection_outputs:
            outputs_file.write("-\n\n" + redact_sensitive_information(connection_output.strip(), ssh_info) + "\n\n")
        if len(ssh_info.connection_outputs) > 0:
            outputs_file.write("-\n")


def parse_arguments() -> argparse.Namespace:
    argument_parser = argparse.ArgumentParser(description="Automate router configuration via SSH")
    argument_parser.add_argument(
        "--instructions_file", type=pathlib.Path, help="Path to the instructions file to be processed", required=True
    )
    return argument_parser.parse_args()


def main() -> None:
    arguments = parse_arguments()
    session_info: SessionInfo = SessionInfo(
        instructions_file_path=arguments.instructions_file,
        is_active=False,
        instruction_prefix=INSTRUCTION_PREFIX,
        comment_prefix=COMMENT_PREFIX,
        prompt_ready_markers=PROMPT_READY_MARKERS,
        prompt_wait_time_step=PROMPT_WAIT_TIME_STEP,
        prompt_output_chunk_size=PROMPT_OUTPUT_CHUNK_SIZE,
        environment=Environment(),
        ssh_info=SSHInfo(
            is_connected=False,
            outputs_file_path=OUTPUTS_FILE_PATH,
            outputs_redacted_replacement=OUTPUTS_REDACTED_REPLACEMENT,
        ),
    )
    process_instruction_lines(session_info)
    save_outputs(session_info.ssh_info)


if __name__ == "__main__":
    main()

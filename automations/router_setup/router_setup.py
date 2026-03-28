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
SSH_CONNECT_TIMEOUT = 15
SSH_CONNECT_WAIT_BEFORE_RETRY = 2
OUTPUT_FILE_PATH = "./output.txt"
OUTPUT_WIDTH = 120
OUTPUT_CHUNK_SIZE = 4096
OUTPUT_WAIT_TIME_STEP = 0.2
OUTPUT_IMPORTANT_STRINGS = ["error", "warning"]
PROMPT_READY_MARKERS = ("$", "#", ">")

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
    connect_timeout: float
    connect_wait_before_retry: float
    output_file_path: str
    output_width: int
    output_chunk_size: int
    output_wait_time_step: float
    output_important_strings: list[str]
    prompt_ready_markers: tuple[str]
    connection_index: int = 0
    connection_outputs: list[str] = dataclasses.field(default_factory=list)
    redacted_texts: list[str] = dataclasses.field(default_factory=list)
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
    dry_run: bool
    is_active: bool
    instruction_prefix: str
    comment_prefix: str
    environment: Environment
    ssh_info: SSHInfo


def wait_for_ready_prompt(ssh_info: SSHInfo) -> str:
    return_on_next_check: bool = False
    output: str = ""
    while True:
        time.sleep(ssh_info.output_wait_time_step)
        changed_output: bool = False
        if ssh_info.shell.recv_ready():
            output += ssh_info.shell.recv(ssh_info.output_chunk_size).decode(errors="ignore")
            changed_output = True
            return_on_next_check = False
        if changed_output or return_on_next_check:
            if output.rstrip().endswith(ssh_info.prompt_ready_markers):
                if return_on_next_check:
                    return output
                return_on_next_check = True


def get_ssh_client(session_info: SessionInfo) -> paramiko.SSHClient | None:
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        ssh_client.connect(
            hostname=session_info.environment.hostname,
            port=session_info.environment.port,
            username=session_info.environment.username,
            password=session_info.environment.password,
            look_for_keys=False,
            allow_agent=False,
            timeout=session_info.ssh_info.connect_timeout,
        )
    except (TimeoutError, OSError):
        return None
    return ssh_client


def connect(session_info: SessionInfo) -> None:
    session_info.ssh_info.connection_index = len(session_info.ssh_info.connection_outputs)
    session_info.ssh_info.connection_outputs.append("")
    session_info.ssh_info.client = get_ssh_client(session_info)
    if session_info.ssh_info.client is not None:
        session_info.ssh_info.shell = session_info.ssh_info.client.invoke_shell(
            width=session_info.ssh_info.output_width
        )
        session_info.ssh_info.connection_outputs[session_info.ssh_info.connection_index] += wait_for_ready_prompt(
            session_info.ssh_info
        )


def disconnect(ssh_info: SSHInfo) -> None:
    ssh_info.client.close()
    ssh_info.client = None
    ssh_info.shell = None


def run_commands(instruction_arguments: InstructionArguments, ssh_info: SSHInfo) -> list[str]:
    outputs: list[str] = []
    for command in instruction_arguments.commands:
        ssh_info.shell.send(command + "\n")
        output = wait_for_ready_prompt(ssh_info)
        outputs.append(output)
        ssh_info.connection_outputs[ssh_info.connection_index] += output
    return outputs


def prompt_if_important(outputs: list[str], output_important_strings: list[str]) -> None:
    prompt: bool = False
    normalized_output_important_strings: list[str] = []
    important_strings_found: list[str] = []
    for output_important_string in output_important_strings:
        normalized_output_important_strings.append(output_important_string.lower())
    for output in outputs:
        normalized_output = output.lower()
        for normalized_output_important_string in normalized_output_important_strings:
            if normalized_output_important_string in normalized_output:
                important_strings_found.append(normalized_output_important_string)
                prompt = True
    if prompt:
        input(f"Output contains \"{"\", \"".join(important_strings_found)}\" | Press ENTER to continue...")


def upload_files(instruction_arguments: InstructionArguments, session_info: SessionInfo) -> None:
    local_files_absolute_paths: list[str] = []
    for local_file in instruction_arguments.local_files:
        perspective_file_path = session_info.instructions_file_path.resolve()
        local_file_absolute_path = (perspective_file_path.parent / local_file).resolve()
        local_files_absolute_paths.append(str(local_file_absolute_path))
    ssh_client = get_ssh_client(session_info)
    if ssh_client is not None:
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
        session_info.ssh_info.redacted_texts.append(session_info.environment.password)
        session_info.ssh_info.redacted_texts.sort(key=len, reverse=True)


def redact_sensitive_information(unredacted_text: str, ssh_info: SSHInfo) -> str:
    redacted_text = unredacted_text
    for text_to_redact in ssh_info.redacted_texts:
        if len(text_to_redact) > 0:
            redacted_text = redacted_text.replace(text_to_redact, "*" * len(text_to_redact))
    return redacted_text


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
    elif session_info.is_active:
        return Instruction(
            type="RUN_COMMANDS:",
            arguments=InstructionArguments(commands=[trimmed_instruction_line]),
        )
    return None


def process_single_instruction_line(instruction_line: str, session_info: SessionInfo) -> None:
    instruction_data = decode_instruction_line(instruction_line, session_info)
    if instruction_data is None:
        return
    match instruction_data.type:
        case "START:":
            if session_info.is_active:
                print("Warning: Could not start | Reason: Automation already started")
                return
            session_info.is_active = True
        case "END:":
            if not session_info.is_active:
                print("Warning: Could not end | Reason: Automation already ended or never started")
                return
            session_info.is_active = False
        case "CONNECT:":
            if not session_info.is_active:
                print("Warning: Could not connect | Reason: Automation not started")
                return
            if session_info.ssh_info.is_connected:
                print("Warning: Could not connect | Reason: Automation already connected")
                return
            while True:
                print(f"Connecting to {session_info.environment.username}@{session_info.environment.hostname}")
                if session_info.dry_run:
                    break
                connect(session_info)
                if session_info.ssh_info.client is not None:
                    break
                print("Could not connect")
                time.sleep(session_info.ssh_info.connect_wait_before_retry)
            print("Connected")
            session_info.ssh_info.is_connected = True
        case "DISCONNECT:":
            if not session_info.is_active:
                print("Warning: Could not disconnect | Reason: Automation not started")
                return
            if not session_info.ssh_info.is_connected:
                print("Warning: Could not disconnect | Reason: Automation not connected")
                return
            if not session_info.dry_run:
                disconnect(session_info.ssh_info)
            print("Disconnected")
            session_info.ssh_info.is_connected = False
            session_info.ssh_info.connection_index += 1
        case "RUN_COMMANDS:":
            if not session_info.is_active:
                print("Warning: Could not run commands | Reason: Automation not started")
                return
            if not session_info.ssh_info.is_connected:
                print("Warning: Could not run commands | Reason: Automation not connected")
                return
            redacted_commands: list[str] = []
            for unredacted_command in instruction_data.arguments.commands:
                redacted_commands.append(redact_sensitive_information(unredacted_command, session_info.ssh_info))
            print(f"Running commands: {"; ".join(redacted_commands)}")
            if not session_info.dry_run:
                command_outputs = run_commands(instruction_data.arguments, session_info.ssh_info)
                print(f"\n{"\n\n".join(command_outputs)}\n")
                prompt_if_important(command_outputs, session_info.ssh_info.output_important_strings)
        case "UPLOAD_FILES:":
            print(
                f"Uploading files: {"; ".join(instruction_data.arguments.local_files)} > {instruction_data.arguments.remote_directory}"
            )
            if not session_info.dry_run:
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
    try:
        with session_info.instructions_file_path.open("r") as file:
            instruction_lines = file.readlines()
            for instruction_line in instruction_lines:
                process_single_instruction_line(instruction_line, session_info)
    except FileNotFoundError:
        print("Error: File not found")


def save_outputs(ssh_info: SSHInfo) -> None:
    with open(ssh_info.output_file_path, mode="a") as outputs_file:
        for connection_output in ssh_info.connection_outputs:
            outputs_file.write("-\n\n" + redact_sensitive_information(connection_output.strip(), ssh_info) + "\n\n")
        if len(ssh_info.connection_outputs) > 0:
            outputs_file.write("-\n")


def parse_arguments() -> argparse.Namespace:
    argument_parser = argparse.ArgumentParser(description="Automate router configuration via SSH")
    argument_parser.add_argument(
        "--instructions-file", type=pathlib.Path, help="Path to the instructions file to be processed", required=True
    )
    argument_parser.add_argument(
        "--dry-run", action="store_true", help="Dry run of the instructions without connecting to the router"
    )
    return argument_parser.parse_args()


def main() -> None:
    arguments = parse_arguments()
    session_info: SessionInfo = SessionInfo(
        instructions_file_path=pathlib.Path(arguments.instructions_file),
        dry_run=bool(arguments.dry_run),
        is_active=False,
        instruction_prefix=INSTRUCTION_PREFIX,
        comment_prefix=COMMENT_PREFIX,
        environment=Environment(),
        ssh_info=SSHInfo(
            is_connected=False,
            connect_timeout=SSH_CONNECT_TIMEOUT,
            connect_wait_before_retry=SSH_CONNECT_WAIT_BEFORE_RETRY,
            output_file_path=OUTPUT_FILE_PATH,
            output_width=OUTPUT_WIDTH,
            output_chunk_size=OUTPUT_CHUNK_SIZE,
            output_wait_time_step=OUTPUT_WAIT_TIME_STEP,
            output_important_strings=OUTPUT_IMPORTANT_STRINGS,
            prompt_ready_markers=PROMPT_READY_MARKERS,
        ),
    )
    process_instruction_lines(session_info)
    save_outputs(session_info.ssh_info)


if __name__ == "__main__":
    main()

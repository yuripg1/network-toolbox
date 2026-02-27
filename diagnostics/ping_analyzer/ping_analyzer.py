import argparse
import csv
import dataclasses
import datetime
import glob
import os
import sys

OUTAGE_MAX_SUCCESS_TOLERANCE_IN_SECONDS = 2
MIN_OUTAGE_LOSS_RATE_PERCENTAGE = 10
MIN_OUTAGE_DURATION_IN_SECONDS = 2


@dataclasses.dataclass
class Options:
    input: str


@dataclasses.dataclass
class Event:
    id: int
    timestamp: float
    destination_address: str
    is_success: bool


@dataclasses.dataclass
class Outage:
    loss_rate_percentage: float
    duration_in_seconds: float
    id_of_first_failure: int
    id_of_last_failure: int
    timestamp_of_first_failure: float
    timestamp_of_last_failure: float
    number_of_failures: int


def print_outages_csv(outages: list[Outage]) -> None:
    csv_writer = csv.writer(sys.stdout, delimiter=",", quotechar='"', quoting=csv.QUOTE_ALL)
    csv_writer.writerow(["Loss rate (%)", "Start", "End", "Duration (seconds)"])
    for outage in outages:
        csv_writer.writerow(
            [
                f"{outage.loss_rate_percentage:.3f}",
                datetime.datetime.fromtimestamp(outage.timestamp_of_first_failure).isoformat(),
                datetime.datetime.fromtimestamp(outage.timestamp_of_last_failure).isoformat(),
                f"{outage.duration_in_seconds:.3f}",
            ]
        )


def process_current_outage(
    current_outage: Outage,
    outages: list[Outage],
    min_outage_loss_rate_percentage: float,
    min_outage_duration_in_seconds: float,
) -> None:
    current_outage.loss_rate_percentage = (
        current_outage.number_of_failures
        / ((current_outage.id_of_last_failure - current_outage.id_of_first_failure) + 1)
    ) * 100
    current_outage.duration_in_seconds = (
        current_outage.timestamp_of_last_failure - current_outage.timestamp_of_first_failure
    )
    if (
        current_outage.loss_rate_percentage >= min_outage_loss_rate_percentage
        and current_outage.duration_in_seconds >= min_outage_duration_in_seconds
    ):
        outages.append(current_outage)


def create_new_outage(event: Event) -> Outage:
    return Outage(
        loss_rate_percentage=0,
        duration_in_seconds=0,
        id_of_first_failure=event.id,
        id_of_last_failure=event.id,
        timestamp_of_first_failure=event.timestamp,
        timestamp_of_last_failure=event.timestamp,
        number_of_failures=1,
    )


def get_outages(
    events: list[Event],
    outage_max_success_tolerance_in_seconds: float,
    min_outage_loss_rate_percentage: float,
    min_outage_duration_in_seconds: float,
) -> list[Outage]:
    outages: list[Outage] = []
    current_outage: Outage | None = None
    for event in events:
        if current_outage is None:
            if event.is_success is True:
                continue
            else:
                current_outage = create_new_outage(event)
        else:
            if event.is_success is True:
                if event.timestamp > (
                    current_outage.timestamp_of_last_failure + outage_max_success_tolerance_in_seconds
                ):
                    process_current_outage(
                        current_outage, outages, min_outage_loss_rate_percentage, min_outage_duration_in_seconds
                    )
                    current_outage = None
            else:
                current_outage.id_of_last_failure = event.id
                current_outage.timestamp_of_last_failure = event.timestamp
                current_outage.number_of_failures += 1
    if current_outage is not None:
        process_current_outage(current_outage, outages, min_outage_loss_rate_percentage, min_outage_duration_in_seconds)
    return outages


def assign_event_ids(events: list[Event]) -> None:
    current_event_id = 1
    for event in events:
        event.id = current_event_id
        current_event_id = current_event_id + 1


def sort_events(events: list[Event]) -> None:
    events.sort(key=lambda event: event.timestamp)


def get_events_from_file(file_path: str) -> list[Event]:
    with open(file_path, "r") as file:
        lines = file.readlines()
    destination_address: str = ""
    events: list[Event] = []
    for line in lines:
        if " bytes from " in line:
            timestamp = float(line.split("] ")[0].strip("["))
            events.append(
                Event(
                    id=0,
                    timestamp=timestamp,
                    destination_address=destination_address,
                    is_success=True,
                )
            )
        elif " no answer yet for icmp_seq=" in line:
            timestamp = float(line.split("] ")[0].strip("["))
            events.append(
                Event(
                    id=0,
                    timestamp=timestamp,
                    destination_address=destination_address,
                    is_success=False,
                )
            )
        elif "PING " in line:
            if len(destination_address) == 0:
                destination_address = str(line.split("(")[1].split(") ")[0])
    return events


def get_events_from_files(files: list[str]) -> list[Event]:
    events: list[Event] = []
    for file_path in files:
        events.extend(get_events_from_file(file_path))
    sort_events(events)
    assign_event_ids(events)
    return events


def get_files_from_input(input: str) -> list[str]:
    files: list[str] = []
    if os.path.isdir(input):
        for entry in os.listdir(input):
            entry_path = os.path.join(input, entry)
            if os.path.isfile(entry_path):
                files.append(entry_path)
    elif os.path.isfile(input):
        files.append(input)
    else:
        matched_entries = glob.glob(input)
        for entry in matched_entries:
            if os.path.isfile(entry):
                files.append(entry)
    files.sort()
    return files


def get_options_from_arguments(arguments: argparse.Namespace) -> Options:
    options = Options(input=arguments.input)
    return options


def parse_arguments() -> argparse.Namespace:
    argument_parser = argparse.ArgumentParser(description="Analyze ping results")
    argument_parser.add_argument("--input", type=str, required=True, help="Path to the input file(s)")
    return argument_parser.parse_args()


def main() -> None:
    arguments = parse_arguments()
    options = get_options_from_arguments(arguments)
    files = get_files_from_input(options.input)
    events = get_events_from_files(files)
    outages = get_outages(
        events,
        OUTAGE_MAX_SUCCESS_TOLERANCE_IN_SECONDS,
        MIN_OUTAGE_LOSS_RATE_PERCENTAGE,
        MIN_OUTAGE_DURATION_IN_SECONDS,
    )
    print_outages_csv(outages)


if __name__ == "__main__":
    main()

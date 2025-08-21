import argparse
import csv
import datetime
import glob
import os
import sys

outage_max_success_tolerance_in_seconds = float(2)
min_outage_loss_rate_percentage = float(10)
min_outage_duration_in_seconds = float(2)


def print_outages_csv(outages):
    csv_writer = csv.writer(
        sys.stdout, delimiter=",", quotechar='"', quoting=csv.QUOTE_ALL
    )
    csv_writer.writerow(["Loss rate (%)", "Start", "End", "Duration (seconds)"])
    for outage in outages:
        csv_writer.writerow(
            [
                outage["loss_rate_percentage"],
                datetime.datetime.fromtimestamp(
                    outage["timestamp_of_first_failure"]
                ).isoformat(),
                datetime.datetime.fromtimestamp(
                    outage["timestamp_of_last_failure"]
                ).isoformat(),
                outage["duration_in_seconds"],
            ]
        )


def create_new_outage(event):
    return {
        "loss_rate_percentage": "",
        "duration_in_seconds": "",
        "id_of_first_failure": event["id"],
        "id_of_last_failure": event["id"],
        "timestamp_of_first_failure": event["timestamp"],
        "timestamp_of_last_failure": event["timestamp"],
        "number_of_failures": 1,
    }


def process_current_outage(
    current_outage,
    outages,
    min_outage_loss_rate_percentage,
    min_outage_duration_in_seconds,
):
    outage_loss_rate_percentage = (
        current_outage["number_of_failures"]
        / (
            (
                current_outage["id_of_last_failure"]
                - current_outage["id_of_first_failure"]
            )
            + 1
        )
    ) * 100
    outage_duration_in_seconds = (
        current_outage["timestamp_of_last_failure"]
        - current_outage["timestamp_of_first_failure"]
    )
    current_outage["loss_rate_percentage"] = f"{outage_loss_rate_percentage:.3f}"
    current_outage["duration_in_seconds"] = f"{outage_duration_in_seconds:.3f}"
    if (
        outage_loss_rate_percentage >= min_outage_loss_rate_percentage
        and outage_duration_in_seconds >= min_outage_duration_in_seconds
    ):
        outages.append(current_outage)


def get_outages(
    events,
    outage_max_success_tolerance_in_seconds,
    min_outage_loss_rate_percentage,
    min_outage_duration_in_seconds,
):
    outages = []
    current_outage = None
    for event in events:
        if current_outage is None and event["is_success"] is True:
            continue
        elif event["is_success"] is True:
            if event["timestamp"] > (
                current_outage["timestamp_of_last_failure"]
                + outage_max_success_tolerance_in_seconds
            ):
                process_current_outage(
                    current_outage,
                    outages,
                    min_outage_loss_rate_percentage,
                    min_outage_duration_in_seconds,
                )
                current_outage = None
        elif current_outage is None:
            current_outage = create_new_outage(event)
        else:
            current_outage["id_of_last_failure"] = event["id"]
            current_outage["timestamp_of_last_failure"] = event["timestamp"]
            current_outage["number_of_failures"] = (
                current_outage["number_of_failures"] + 1
            )
    if current_outage is not None:
        process_current_outage(
            current_outage,
            outages,
            min_outage_loss_rate_percentage,
            min_outage_duration_in_seconds,
        )
    return outages


def assign_event_ids(events):
    current_event_id = 1
    for event in events:
        event["id"] = current_event_id
        current_event_id = current_event_id + 1


def sort_events(events):
    events.sort(key=lambda x: x["timestamp"])


def get_events_from_file(file_path):
    with open(file_path, "r") as file:
        lines = file.readlines()
    destination_address = None
    events = []
    for line in lines:
        if " bytes from " in line:
            timestamp = float(line.split("] ")[0].strip("["))
            events.append(
                {
                    "id": 0,
                    "timestamp": timestamp,
                    "destination_address": destination_address,
                    "is_success": True,
                }
            )
        elif " no answer yet for icmp_seq=" in line:
            timestamp = float(line.split("] ")[0].strip("["))
            events.append(
                {
                    "id": 0,
                    "timestamp": timestamp,
                    "destination_address": destination_address,
                    "is_success": False,
                }
            )
        elif "PING " in line:
            if destination_address is None:
                destination_address = line.split("(")[1].split(") ")[0]
    return events


def get_events_from_files(files):
    events = []
    for file_path in files:
        events.extend(get_events_from_file(file_path))
    sort_events(events)
    assign_event_ids(events)
    return events


def get_files_from_input(input):
    files = []
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


def parse_arguments():
    argument_parser = argparse.ArgumentParser(description="Analyze ping results")
    argument_parser.add_argument(
        "--input", type=str, required=True, help="Path to the input file(s)"
    )
    arguments = argument_parser.parse_args()
    return arguments


def get_options_from_arguments(arguments):
    options = {}
    options["input"] = arguments.input
    return options


def main():
    arguments = parse_arguments()
    options = get_options_from_arguments(arguments)
    files = get_files_from_input(options["input"])
    events = get_events_from_files(files)
    outages = get_outages(
        events,
        outage_max_success_tolerance_in_seconds,
        min_outage_loss_rate_percentage,
        min_outage_duration_in_seconds,
    )
    print_outages_csv(outages)


if __name__ == "__main__":
    main()

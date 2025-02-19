# Ping output MUST print out timestamp information (use the "-D" argument)
# Ping output MUST print out unanswered requests (use the "-O" argument)
# Example of expected ping command:
# ping -c 21601 -D -i 1 -M do -n -O -s 1372 8.8.8.8 > ./ping_01.txt
# Set the "data_directory_path" variable to point to the directory containing the output of the ping command(s)

import csv
import datetime
import os
import pytz
import sys

data_directory_path = './ping_outpus_dir'
local_timezone = 'America/Sao_Paulo'
outage_max_success_tolerance_in_seconds = float(2)
min_outage_loss_rate_percentage = float(10)
min_outage_duration_in_seconds = float(2)

def print_outages_csv_row(csv_writer, outage):
    csv_writer.writerow([outage['loss_rate_percentage'], outage['start_datetime'], outage['end_datetime'], outage['duration_in_seconds']])

def print_outages_csv_header(csv_writer):
    csv_writer.writerow(['Loss rate (%)', 'Start', 'End', 'Duration (seconds)'])

def print_outages_csv(outages):
    csv_writer = csv.writer(sys.stdout, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)
    print_outages_csv_header(csv_writer)
    for outage in outages:
        print_outages_csv_row(csv_writer, outage)

def print_outages(outages):
    for outage in outages:
        print(outage)

def convert_timestamp(timestamp, local_timezone):
    tz = pytz.timezone(local_timezone)
    dt = datetime.datetime.fromtimestamp(float(timestamp), tz)
    return dt.strftime('%d/%m/%Y %H:%M:%S')

def create_new_outage(event):
    return {
        'loss_rate_percentage': '',
        'start_datetime': '',
        'end_datetime': '',
        'duration_in_seconds': '',
        'id_of_first_failure': event['id'],
        'id_of_last_failure': event['id'],
        'timestamp_of_first_failure': event['timestamp'],
        'timestamp_of_last_failure': event['timestamp'],
        'number_of_failures': 1,
    }

def process_current_outage(current_outage, outages):
    outage_loss_rate_percentage = (current_outage['number_of_failures'] / ((current_outage['id_of_last_failure'] - current_outage['id_of_first_failure']) + 1)) * 100
    outage_duration_in_seconds = current_outage['timestamp_of_last_failure'] - current_outage['timestamp_of_first_failure']
    current_outage['loss_rate_percentage'] = f'{outage_loss_rate_percentage:.3f}'
    current_outage['start_datetime'] = convert_timestamp(current_outage['timestamp_of_first_failure'], local_timezone)
    current_outage['end_datetime'] = convert_timestamp(current_outage['timestamp_of_last_failure'], local_timezone)
    current_outage['duration_in_seconds'] = f'{outage_duration_in_seconds:.3f}'
    if outage_loss_rate_percentage >= min_outage_loss_rate_percentage and outage_duration_in_seconds >= min_outage_duration_in_seconds:
        outages.append(current_outage)

def get_outages(events, local_timezone, outage_max_success_tolerance_in_seconds, min_outage_loss_rate_percentage, min_outage_duration_in_seconds):
    outages = []
    current_outage = None
    for event in events:
        if current_outage is None and event['is_success'] is True:
            continue
        elif event['is_success'] is True:
            if event['timestamp'] > (current_outage['timestamp_of_last_failure'] + outage_max_success_tolerance_in_seconds):
                process_current_outage(current_outage, outages)
                current_outage = None
        elif current_outage is None:
            current_outage = create_new_outage(event)
        else:
            current_outage['id_of_last_failure'] = event['id']
            current_outage['timestamp_of_last_failure'] = event['timestamp']
            current_outage['number_of_failures'] = current_outage['number_of_failures'] + 1
    if current_outage is not None:
        process_current_outage(current_outage, outages)
    return outages

def set_event_ids(events):
    current_event_id = 1
    for event in events:
        event['id'] = current_event_id
        current_event_id = current_event_id + 1

def sort_events(events):
    events.sort(key=lambda x: x['timestamp'])

def get_events_from_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    destination_address = None
    events = []
    for line in lines:
        if ' bytes from ' in line:
            timestamp = float(line.split('] ')[0].strip('['))
            events.append({
                'id': 0,
                'timestamp': timestamp,
                'destination_address': destination_address,
                'is_success': True,
            })
        elif ' no answer yet for icmp_seq=' in line:
            timestamp = float(line.split('] ')[0].strip('['))
            events.append({
                'id': 0,
                'timestamp': timestamp,
                'destination_address': destination_address,
                'is_success': False,
            })
        elif 'PING ' in line:
            if destination_address is None:
                destination_address = line.split('(')[1].split(') ')[0]
    return events

def get_events_from_data_directory(data_directory_path, local_timezone, outage_max_success_tolerance_in_seconds, min_outage_loss_rate_percentage, min_outage_duration_in_seconds):
    files = [os.path.join(data_directory_path, f) for f in sorted(os.listdir(data_directory_path)) if f.endswith('.txt')]
    events = []
    for file_path in files:
        events = events + get_events_from_file(file_path)
    sort_events(events)
    set_event_ids(events)
    outages = get_outages(events, local_timezone, outage_max_success_tolerance_in_seconds, min_outage_loss_rate_percentage, min_outage_duration_in_seconds)
    # print_outages(outages)
    print_outages_csv(outages)

outages = get_events_from_data_directory(data_directory_path, local_timezone, outage_max_success_tolerance_in_seconds, min_outage_loss_rate_percentage, min_outage_duration_in_seconds)

# Python script to convert seizure period information in txt files
# to a format that can be loaded into matlab script (generate_full_mat_files.m)
# that embeds the seizure period information into mat files
#
# Example output in CSV output files:
# start (seconds since start),length (duration in seconds)
# 28402,105
# 31025,56
# ....
#
# # The seizure periods have been copy/pasted into the txt files from Excel files
#
import re
import os
from os import path
from datetime import datetime, timedelta, time as dtime


# convert datetime hh:mm:ss into seconds
def secs(t):
    return t.hour * 3600 + t.minute * 60 + t.second


# path to this script
script_dir = path.dirname(path.realpath(__file__))

# seizure information txt files are located in patient_info
patients_dir = path.join(script_dir, 'patient_info')

SECS_IN_DAY = 24 * 3600

for fname in os.listdir(patients_dir):  # convert all files in patient_info dir
    # skip all other files than .txt
    if not fname.endswith('.txt'):
        continue

    # load all lines and split each line on whitespace
    with open(path.join(patients_dir, fname), 'r') as f:
        lines = [l.strip().split() for l in f.readlines() if l.strip()]

    # start date and time is on the first line (date is ignored as we have day offset on all subsequent seizure period lines)
    start_date_time = datetime.strptime(lines[0][0], '%d%m%Y-%H%M%S')
    # convert to seconds
    start_secs = secs(start_date_time)

    # get patient id
    pid = re.sub('[^0-9]', '', fname)

    # parse each seizure period line and append to output
    output = []
    for line in lines[1:]:
        period = [secs(datetime.strptime(hms, '%H%M%S')) for hms in line[1:]]
        p_ofs = [SECS_IN_DAY * int(line[0]) + pt - start_secs for pt in period]
        x = period[1]
        output.append('%s,%s' % (p_ofs[0], p_ofs[1] - p_ofs[0]))

    # Dump output to CSV file
    if output:
        print(pid)
        with open(path.join(patients_dir, 'patient-ofs-%s.csv' % (pid, )),
                  'w') as f:
            output.insert(0, 'start,length')
            f.write('\n'.join(output))

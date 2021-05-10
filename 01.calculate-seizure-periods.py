import re
import os
from os import path
from datetime import datetime, timedelta, time as dtime


def secs(t):
    return t.hour * 3600 + t.minute * 60 + t.second


script_dir = path.dirname(path.realpath(__file__))
patients_dir = path.join(script_dir, 'patients')

SECS_IN_DAY = 24*3600
for fname in os.listdir(patients_dir):
    if not fname.endswith('.txt'):
        continue

    with open(path.join(patients_dir, fname), 'r') as f:
        lines = [l.strip().split() for l in f.readlines() if l.strip()]

    start_date_time = datetime.strptime(lines[0][0], '%d%m%Y-%H%M%S')
    start_secs = secs(start_date_time)

    pid = re.sub('[^0-9]', '', fname)
    if pid != '2':
        continue

    output = []
    for line in lines[1:]:
        period = [secs(datetime.strptime(hms, '%H%M%S')) for hms in line[1:]]
        p_ofs = [
            SECS_IN_DAY*int(line[0]) + pt - start_secs for pt in period
        ]
        x = period[1]
        output.append('%s,%s' % (p_ofs[0], p_ofs[1]-p_ofs[0]))

    if output:
        print(pid)
        with open(path.join(patients_dir, 'patient-ofs-%s.csv' % (pid,)), 'w') as f:
            output.insert(0,'start,length')
            f.write('\n'.join(output))

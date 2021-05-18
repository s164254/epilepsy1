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
# It was neccessary to remove dot/comma/semicolon seperations, as the same form of seperation would not be consistently used.
import re
import os
from os import path
from datetime import datetime, timedelta, time as dtime #Importing functions/classes from the module datetime.


# convert datetime hh:mm:ss into seconds
def secs(t): #defining function secs, with t as input argument.
    return t.hour * 3600 + t.minute * 60 + t.second #Calculating time in seconds since beginning of day.


# path to this script
script_dir = path.dirname(path.realpath(__file__)) 

# seizure information txt files are located in patient_info
patients_dir = path.join(script_dir, 'patient_info') #Use above path to find folder.

SECS_IN_DAY = 24 * 3600 #variable

for fname in os.listdir(patients_dir):  # convert all files in patient_info folder (txt. files). listdir is a function that lists files in directory, and we loop over all these.
    # skip all other files than .txt, as CSV files are saved in same folder.
    if not fname.endswith('.txt'): #fname is a string as listdir restuns strings and endswith is a function that works on strings. 
        continue #continue means to reset (continue with next value en for loop).

    print(patients_dir,fname)
    # load all lines and split each line on whitespace
    full_filename = path.join(patients_dir,fname)
    with open(path.join(patients_dir,fname), 'r') as f: #Creating correct path for the file, by joining the filename and the path.
        lines = [l.strip().split() for l in f.readlines() if l.strip()] #Creating arrays from information in files.

    # start date and time is on the first line (date is ignored as we have day offset on all subsequent seizure period lines)
    start_date_time = datetime.strptime(lines[0][0], '%d%m%Y-%H%M%S') #strptime from the class datetime converts information in line containing date information, to actual date and time. 
    # convert to seconds
    start_secs = secs(start_date_time) #convert hour, minute, second to seconds ignoring date part.

    # get patient id
    pid = re.sub('[^0-9]', '', fname) #replace all non-numbers with an empty string, leaving us with just the patient number.

    # parse each seizure period line and append to output
    output = [] #creating an empty list.
    for line in lines[1:]: #looping through all lines containing seizure start and end.
        period = [secs(datetime.strptime(hms, '%H%M%S')) for hms in line[1:]] #converting start and end times of seizures to hour, minute, second
        p_ofs = [SECS_IN_DAY * int(line[0]) + pt - start_secs for pt in period] #Converting the above to seconds since start of day.
        output.append('%s,%s' % (p_ofs[0], p_ofs[1] - p_ofs[0])) #converting seconds since start of end seizure to seizure length in seconds.

    # Dump output to CSV file
    if output: #if statement ensures we only get information when seizure episode actually occurs.
        print(pid)
        with open(path.join(patients_dir, 'patient-ofs-%s.csv' % (pid, )),
                  'w') as f: #Specifying in which folder the output file must be placed.
            output.insert(0, 'start,length') #defining the first line as the string 'start,length' as MATLAB CSV reader needs variable name in the CSV file.
            f.write('\n'.join(output)) #Creating newline for each element in list.G

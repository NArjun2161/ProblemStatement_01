import re
from collections import defaultdict, Counter

# Configuration
LOG_FILE = '/path/to/your/webserver.log'
REPORT_FILE = '/path/to/report.txt'

# Regular expression to match the log pattern (Apache common log format)
log_pattern = re.compile(
    r'(?P<ip>\S+) \S+ \S+ \[(?P<datetime>[^\]]+)\] "(?P<request>[^"]+)" '
    r'(?P<status>\d{3}) (?P<size>\S+) "(?P<referrer>[^"]*)" "(?P<user_agent>[^"]*)"'
)

# Data structures to store log data
requests_counter = Counter()
status_counter = Counter()
ip_counter = Counter()

# Read and process the log file
with open(LOG_FILE, 'r') as log_file:
    for line in log_file:
        match = log_pattern.match(line)
        if match:
            data = match.groupdict()
            requests_counter[data['request']] += 1
            status_counter[data['status']] += 1
            ip_counter[data['ip']] += 1

# Generate the report
with open(REPORT_FILE, 'w') as report_file:
    report_file.write('Web Server Log Analysis Report\n')
    report_file.write('==============================\n\n')

    # Most requested pages
    report_file.write('Most Requested Pages:\n')
    for request, count in requests_counter.most_common(10):
        report_file.write(f'{request}: {count} requests\n')
    report_file.write('\n')

    # Number of 404 errors
    report_file.write('Number of 404 Errors:\n')
    report_file.write(f'{status_counter["404"]} 404 errors\n\n')

    # IP addresses with the most requests
    report_file.write('IP Addresses with Most Requests:\n')
    for ip, count in ip_counter.most_common(10):
        report_file.write(f'{ip}: {count} requests\n')

print(f'Report generated: {REPORT_FILE}')


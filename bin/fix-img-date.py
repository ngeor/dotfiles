import sys
import os.path
import re
import os

# powershell tip:
# ls IMG* | % { python .\fix-img-date.py $_ }

def change_date(filename, date):
	cmdline = "exiftool -AllDates=" + date + " \"" + filename + "\""
	print(cmdline)
	os.system(cmdline)


def process_img(filename):
	match = re.search('IMG_([0-9]{8}_[0-9]{6})', filename, re.IGNORECASE)
	if not match:
		return None

	date = match.group(1)
	return date


def process_iso(filename):
	match = re.search('([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{6})', filename)
	if not match:
		return None

	date = match.group(1) + match.group(2) + match.group(3) + "_" + match.group(4)
	return date


def process_file(filename):
	if not os.path.isfile(filename):
		print("not a file: " + filename)
		return

	if filename.endswith('.py'):
		return

	print(filename)
	date = process_img(filename)
	if not date:
		date = process_iso(filename)
	if date:
		change_date(filename, date)


for x in sys.argv:
	process_file(x)

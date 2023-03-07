# Part 1. Example Gathering and Clean-Up

# Step 1: Generate output files for all Macaulay2 packages
# Step 2: For each package combine all of the output files into a single output file 
# Step 3: Clean up each combinded output file by: i) deleting all lines not corresponding to an input
# (Warning: This might be a pain if the input is broken into multiple lines. ii) delete the input lines
# symbol.

# /usr/local/Cellar/macaulay2/1.19.1_3

# share/doc/Macaulay2/PACKAGENAME/example-output

# Part 2. Run Examples

# Idea: Create a M2 package that reads each line 

# file_name = "___Virtual__Resolutions.out"

from typing import List, Dict, Literal

def signed_delimiter_count(line: str, delimeter: str) -> int:
	return line.count(delimeter[0]) - line.count(delimeter[1])

def count_delimiters(line: str, delimiter_pairs: List[str]) -> List[int]:
	return [signed_delimiter_count(line,delimeter) for delimeter in delimiter_pairs]

def sum_two_lists(lsit1: List[int], list2: List[int]) -> List[int]:
	return [sum(x) for x in zip(lsit1,list2)]

def update_running_delimeter_count(line: str, delimiter_piars: List[str], running_delimeter_count: List[int]) -> List[int]:
	return sum_two_lists(count_delimiters(line,delimiter_pairs),running_delimeter_count)

def get_nonempty_lines_from_file(file_name: str) -> List[str]:
	file = open(file_name,'r')
	return [line for line in file.readlines() if line.strip()]

def process_example_out_file(file_name: str, delimiter_pairs: List[str]) -> None:
	previous_line = ""
	running_delimeter_count = [0]*len(delimiter_pairs)
	example_number = 0
	lines = get_nonempty_lines_from_file(file_name)
	for line in lines:
		if line[0] == "i" and (line.split(':',1))[1] != ' \n':
			print(f"E{example_number} = {(line.split(':',1))[1]}")
			previous_line = "i"
			running_delimeter_count = update_running_delimeter_count(line,delimiter_pairs,running_delimeter_count)
			example_number += 1
		elif line[0] == "o":
			previous_line = "o"
		else:
			if previous_line == "i" and running_delimeter_count != [0,0,0]:
				print(f"{line}")
				running_delimeter_count = sum_two_lists(count_delimiters(line,delimiter_pairs),running_delimeter_count)


file_name = "example-output/_resolve__Via__Fat__Point.out"
delimiter_pairs = ['()', '[]', "{}"]

process_example_out_file(file_name,delimiter_pairs)

# for line in lines:
# 	if line.strip():
# 		if line[0] == "i":
# 			if (line.split(':',1))[1] != ' \n':
# 				print(f"E{example_number} = {(line.split(':',1))[1]}")
# 				previous_line = "i"
# 				running_delimeter_count = update_running_delimeter_count(line,delimiter_pairs,running_delimeter_count)
# 				example_number += 1
# 		elif line[0] == "o":
# 			previous_line = "o"
# 		else:
# 			if previous_line == "i" and running_delimeter_count != [0,0,0]:
# 				print(f"{line}")
# 				running_delimeter_count = sum_two_lists(count_delimiters(line,delimiter_pairs),running_delimeter_count)



from typing import List, Dict, Literal

def signed_delimiter_count(line: str, delimeter: str) -> int:
	return line.count(delimeter[0]) - line.count(delimeter[1])

def count_delimiters(line: str, delimiter_pairs: List[str]) -> List[int]:
	return [signed_delimiter_count(line,delimeter) for delimeter in delimiter_pairs]

def sum_two_lists(lsit1: List[int], list2: List[int]) -> List[int]:
	return [sum(x) for x in zip(lsit1,list2)]

def update_running_delimeter_count(line: str, delimiter_piars: List[str], running_delimeter_count: List[int]) -> List[int]:
	return sum_two_lists(count_delimiters(line,delimiter_pairs),running_delimeter_count)

def get_nonempty_lines_from_file(input_file_name: str) -> List[str]:
	file = open(input_file_name,'r')
	return [line for line in file.readlines() if line.strip()]

def write_line_to_file(line: str, output_file_name: str) -> None:
	with open(output_file_name, 'a') as output_file:
		output_file.write(f"{line}\n")

def process_example_out_file(input_file_name: str, output_file_name: str, delimiter_pairs: List[str]) -> None:
	previous_line = ""
	running_delimeter_count = [0]*len(delimiter_pairs)
	example_number = 0
	lines = get_nonempty_lines_from_file(input_file_name)
	for line in lines:
		if line[0] == "i" and (line.split(':',1))[1] != ' \n':
			new_line = f"E{example_number} = {(line.split(':',1))[1]}"
			write_line_to_file(new_line,output_file_name)
			# print(f"E{example_number} = {(line.split(':',1))[1]}")
			previous_line = "i"
			running_delimeter_count = update_running_delimeter_count(line,delimiter_pairs,running_delimeter_count)
			example_number += 1
		elif line[0] == "o":
			previous_line = "o"
		else:
			if previous_line == "i" and running_delimeter_count != [0,0,0]:
				write_line_to_file(line,output_file_name)
				# print(f"{line}")
				running_delimeter_count = update_running_delimeter_count(line,delimiter_pairs,running_delimeter_count)


output_file_name = 'test_output.txt'
input_file_name = "example-output/_resolve__Via__Fat__Point.out"
delimiter_pairs = ['()', '[]', "{}"]

process_example_out_file(input_file_name,output_file_name,delimiter_pairs)




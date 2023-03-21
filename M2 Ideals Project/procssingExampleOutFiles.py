from typing import List, Dict, Literal
import os

def signed_delimiter_count(line: str, delimeter: str) -> int:
	return line.count(delimeter[0]) - line.count(delimeter[1])

def count_delimiters(line: str, delimiter_pairs: List[str]) -> List[int]:
	return [signed_delimiter_count(line, delimeter) for delimeter in delimiter_pairs]

def sum_two_lists(lsit1: List[int], list2: List[int]) -> List[int]:
	return [sum(x) for x in zip(lsit1, list2)]

def update_running_delimeter_count(line: str, delimiter_piars: List[str], running_delimeter_count: List[int]) -> List[int]:
	return sum_two_lists(count_delimiters(line, delimiter_pairs), running_delimeter_count)

def get_nonempty_lines_from_list(lines: List[str]) -> List[str]:
	return [line for line in lines if line.strip()]

def get_nonempty_lines_from_file(input_file_name: str) -> List[str]:
	file = open(input_file_name,'r')
	return [line for line in file.readlines() if line.strip()]

def is_input_line(line: str) -> bool:
	return line[0] == 'i'

def is_main_ouput_line(line: str) -> bool:
	return line[0] == 'o'

def is_combinded_lines(line: str) -> bool:
	return (is_input_line(line) and line.count(';') > 1)

def add_input_syntax(line: str) -> bool:
	if is_input_line(line):
		return f"{line}\n"
	else:
		return f"i: {line.lstrip()}\n"

def break_combinded_lines(lines: List[str]) -> List[str]:
	new_lines = []
	for line in lines:
		if is_combinded_lines(line):
			broken_line = line.split(';')
			for part_of_line in get_nonempty_lines_from_list(broken_line):
				new_lines.append(add_input_syntax(part_of_line))
		else:
			new_lines.append(line)
	return get_nonempty_lines_from_list(new_lines)

def clean_up_example_out_file(input_file_name: str) -> List[str]:
	file = open(input_file_name,'r')
	lines = file.readlines()
	return break_combinded_lines(lines)

def write_line_to_file(line: str, output_file_name: str) -> None:
	with open(output_file_name, 'a') as output_file:
		output_file.write(f"{line}\n")

def write_list_of_example_ids_to_file(example_ids: List[str], output_file_name: str) -> None:
	with open(output_file_name, 'a') as output_file:
		example_ids_quotes = ['\"' + ex_id + '\"' for ex_id in example_ids]
		seperator = ", "
		list_as_string = f"exampleIDS = {{{seperator.join(example_ids_quotes)}}}\n"
		output_file.write(list_as_string)

def process_example_out_file(input_file_name: str, output_file_name: str, delimiter_pairs: List[str], file_number: int = 0) -> List[str]:
	previous_line = ""
	running_delimeter_count = [0]*len(delimiter_pairs)
	example_number = 0
	lines = clean_up_example_out_file(input_file_name)
	for line in lines:
		if is_input_line(line) and (line.split(':',1))[1] != ' \n':
			new_line = f"F{file_number}E{example_number} = {(line.split(':',1))[1]}"
			write_line_to_file(new_line, output_file_name)
			previous_line = "i"
			running_delimeter_count = update_running_delimeter_count(line, delimiter_pairs, running_delimeter_count)
			example_number += 1
		elif is_main_ouput_line(line):
			previous_line = "o"
		elif previous_line == "i" and running_delimeter_count != [0]*len(delimiter_pairs):
			write_line_to_file(line, output_file_name)
			running_delimeter_count = update_running_delimeter_count(line, delimiter_pairs, running_delimeter_count)
	return [f"F{file_number}E{number}" for number in range(example_number)]
 
def process_package_example_out(package_directory: str, output_file_name: str, delimiter_pairs: List[str]) -> None:
	file_number = 0
	write_line_to_file(f"needsPackage \"{package_directory}\"\n", output_file_name)
	overview_dictionary = {}
	package_example_ids = []
	for file_name in os.scandir(package_directory):
		if file_name.is_file():
			file_example_ids = process_example_out_file(file_name.path, output_file_name, delimiter_pairs, file_number)
			overview_dictionary[file_name.name] = {'file_number': file_number, 'example_ids': file_example_ids}
			file_number += 1
			package_example_ids.extend(file_example_ids)
	write_list_of_example_ids_to_file(package_example_ids,output_file_name)
	print(overview_dictionary)

# package_directory = 'VirtualResolutions'
# output_file_name = 'VirRes-test.txt'
# input_file_name = 'VirtualResolutions/_multigraded__Regularity.out'
delimiter_pairs = ['()', '[]', "{}"]

# package_directory = 'NormalToricVarieties'
# output_file_name = 'NTV-test.txt'
# # process_example_out_file(input_file_name,output_file_name, delimiter_pairs)
# process_package_example_out(package_directory, output_file_name, delimiter_pairs)

# print([file.name for file in os.scandir("package_directory" )])

def process_all_packages(package_directory: str, output_folder: str, output_file_name: str, delimiter_pairs: List[str]) -> None:
	package_number = 0
	overview_dictionary = {}
	os.makedirs(output_folder, exist_ok = True)
	for package_folder in os.scandir(package_directory):
		# print(package_folder.name)
		package_example_folder = os.path.join(package_folder.path, 'example-output')
		print(package_folder.path)
		print(package_example_folder)
		if os.path.exists(package_example_folder):
			package_output_file_name = os.path.join(output_folder, package_folder.name + '.' + 'txt')
			print(package_output_file_name)
			# process_package_example_out(package_example_folder, package_output_file_name, delimiter_pairs)
			write_line_to_file(f"{package_folder.name}: This is a test",package_output_file_name)
			overview_dictionary[package_folder.name] = package_number
			package_number += 1
	output_overview_name = os.path.join(output_folder, output_file_name + '.' + 'txt')
	write_line_to_file(overview_dictionary,output_overview_name)

package_directory = 'package_directory'
output_folder = 'output'
output_file_name = '00overview'
process_all_packages(package_directory,output_folder,output_file_name,delimiter_pairs)

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
	return (line[0] == 'i' and line[1].isdigit())

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
	file_example_ids = [f"F{file_number}E{number}" for number in range(example_number)]
	write_list_of_example_ids_to_file(file_example_ids,output_file_name[:-4] + '-exID.txt')
	return file_example_ids

def is_out_file(file_name_string) -> bool:
	return file_name_string.endswith('.out')

def process_package_example_out(package_name: str, package_directory: str, output_file_name: str, delimiter_pairs: List[str]) -> None:
	file_number = 0
	write_line_to_file(f"needsPackage \"{package_name}\"\n", output_file_name)
	overview_dictionary = {}
	package_example_ids = []
	for file_name in os.scandir(package_directory):
		print(file_name.name)
		if file_name.is_file() and is_out_file(file_name.name):
			file_example_ids = process_example_out_file(file_name.path, output_file_name, delimiter_pairs, file_number)
			overview_dictionary[file_name.name] = {'file_number': file_number, 'example_ids': file_example_ids}
			file_number += 1
			package_example_ids.extend(file_example_ids)
	write_list_of_example_ids_to_file(package_example_ids,output_file_name)

def process_package_example(package_name: str, package_directory: str, output_directory: str, delimiter_pairs: List[str]) -> None:
	file_number = 0
	os.makedirs(output_directory, exist_ok = True)
	out_files = []
	for file_name in os.scandir(package_directory):
		print(file_name.name)
		if file_name.is_file() and is_out_file(file_name.name):
			package_example_path = os.path.join(output_directory, file_name.name[:-3] + ".txt")
			write_line_to_file(f"needsPackage \"{package_name}\"\n", package_example_path)
			overview_dictionary = {}
			package_example_ids = []
			file_example_ids = process_example_out_file(file_name.path, package_example_path, delimiter_pairs, file_number)
			overview_dictionary[file_name.name] = {'file_number': file_number, 'example_ids': file_example_ids}
			file_number += 1
			package_example_ids.extend(file_example_ids)
			out_files.append(file_name.name[:-4])
	return out_files
			# write_list_of_example_ids_to_file(package_example_ids,package_example_path)

def dictionary_to_M2_hash(dictionary: Dict) -> List:
	dictionary_M2_list = [f"{pair[0]} => {pair[1]}" for pair in dictionary.items()]
	seperator = ', '
	dictionary_M2_string = f"new hashTable {{{seperator.join(dictionary_M2_list)}}}\n"
	return(dictionary_M2_string)

def list_as_M2_string(input_list: List) -> str:
	list_quotes = ['\"' + item + '\"' for item in input_list]
	seperator = ", "
	list_as_string = f"{{{seperator.join(list_quotes)}}}\n"
	return list_as_string

def write_overview_dictionary_to_file(overview_dictionary: Dict, output_file_name: str) -> None:
	hash_enteries_as_list = [f"{key} => {{{value[0]}, {list_as_M2_string(value[1])}}}" for key, value in overview_dictionary.items()]
	seperator = ", "
	hash_as_M2_string = f"hashTable {{{seperator.join(hash_enteries_as_list)}}}\n"
	write_line_to_file(hash_as_M2_string, output_file_name)

def process_all_packages(package_directory: str, output_folder: str, output_file_name: str, delimiter_pairs: List[str]) -> None:
	package_number = 0
	overview_package_number_dictionary = {}
	overview_dictionary = {}
	os.makedirs(output_folder, exist_ok = True)
	sorted_packge_directory = sorted(os.scandir(package_directory), key=lambda x: (x.is_dir(), x.name))
	for package_folder in sorted_packge_directory:
		package_example_folder = os.path.join(package_folder.path, 'example-output')
		# print(f"{package_folder.name}: {package_number}\n")
		if os.path.exists(package_example_folder):
			package_output_directory = os.path.join(output_folder, package_folder.name)
			out_files = process_package_example(package_folder.name, package_example_folder, package_output_directory, delimiter_pairs)
			overview_dictionary[package_folder.name] = [package_number, out_files]
			package_number += 1
	output_overview_dictionary_name = os.path.join(output_folder, output_file_name + '.txt')
	write_overview_dictionary_to_file(overview_dictionary,output_overview_dictionary_name)
	# output_overview_dictionary_name = os.path.join(output_folder, output_file_name + 'txt')
	# write_line_to_file(dictionary_to_M2_hash(overview_package_number_dictionary), output_overview_package_number_name)
	# output_overview_outfile_name = os.path.join(output_folder, output_file_name + '-outfiles.' + 'txt')
	# write_line_to_file(dictionary_to_M2_hash(overview_outfile_dictionary), output_overview_outfile_name)


delimiter_pairs = ['()', '[]', "{}"]

# package_directory = 'VirtualResolutions'
# package_name = 'VirtualResolutions'
# output_directory = 'VirtualResolutions-Examples'
# output_file_name = 'VirRes-test.txt'
# process_package_example(package_name,package_directory,output_directory,delimiter_pairs)

# package_directory = 'NormalToricVarieties'
# output_file_name = 'NTV-test.txt'
# process_package_example_out(package_directory, output_file_name, delimiter_pairs)

# package_directory = 'package_directory'
# output_folder = 'output'
# output_file_name = '0overview'
# process_all_packages(package_directory,output_folder,output_file_name,delimiter_pairs)

package_directory = 'test_package_directory'
output_folder = 'test_output'
output_file_name = 'test_overview'
process_all_packages(package_directory,output_folder,output_file_name,delimiter_pairs)

# package_directory = 'package_directory/GKMVarieties/example-output'
# output_file_name = 'test-test.txt'
# process_package_example_out(package_directory, output_file_name, delimiter_pairs)


# input_file_name = package_directory = 'package_directory/GKMVarieties/example-output/___Moment__Graph_sp_st_st_sp__Moment__Graph.out'
# output_file_name = 'test-test.txt'
# process_example_out_file(input_file_name,output_file_name, delimiter_pairs)

# Issues: 
# FIXED 1. SimpleDoc: _package__Template.out
#
# FIXED 2. GKMVarieties: _is__Well__Defined_lp__K__Class_rp.out The issue here is the input on line i4 "isWellDefined badC --no longer well-defined"
# for some reason despite the documentation this function returns something before the output line. 
# see http://www2.macaulay2.com/Macaulay2/doc/Macaulay2-1.17/share/doc/Macaulay2/GKMVarieties/html/_is__Well__Defined_lp__K__Class_rp.html 
#
# FIXED 3. GKMVarieties: Folder conatins a .DS_store file.
#
# FIXED 4. GeometricDecomposability: The same issue with the Verbose=>true option effects the following files
# ___Verbose.out
# _is__G__V__D.out 
# _is__Lex__Compatibly__G__V__D
# The issue here is the function isGVD(...,Verbose=>) returns something before the output
# line. see https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2/share/doc/Macaulay2/GeometricDecomposability/html/_is__G__V__D.html
#
# FIXED 5. IntegralClosure: _integral__Closure_lp..._cm__Verbosity_eq_gt..._rp _integral__Closure_lp..._cm__Strategy_eq_gt..._rp Verbosity issue again

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
file_name = "example-output/_resolve__Via__Fat__Point.out"
file = open(file_name,'r')
lines = file.readlines()
# print(lines)
def delimeter_count(line: str) -> int:
	paren_number = (line.count("(")-line.count(")"))
	bracket_number = (line.count("[")-line.count("]"))
	brace_number = (line.count("{")-line.count("}"))
	return [paren_number,bracket_number,brace_number]

def sum_two_lists(lsit1, list2):
	return [sum(x) for x in zip(lsit1,list2)]

previous_line = ""
running_delimeter_count = [0,0,0]
for line in lines:
	if line.strip():
		if line[0] == "i":
			print(f"{line}")
			previous_line = "i"
			running_delimeter_count = sum_two_lists(delimeter_count(line),running_delimeter_count)
		elif line[0] == "o":
			previous_line = "o"
		else:
			if previous_line == "i" and running_delimeter_count != [0,0,0]:
				print(f"{line}")
				#print(f"{previous_line},{running_delimeter_count}, {line}")
				running_delimeter_count = sum_two_lists(delimeter_count(line),running_delimeter_count)
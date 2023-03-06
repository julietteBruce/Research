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

file_name = "___Virtual__Resolutions.out"
file = open(file_name,'r')
lines = file.readlines()
print(lines)
previous_line = ""
for line in lines:
	if line.strip():
		if line[0] == "i":
			print(f"{line}")
			previous_line = "i"
		elif line[0] == "o":
			previous_line = "o"
		else:
			if previous_line == "i":
				print(f"{previous_line}, {line}")
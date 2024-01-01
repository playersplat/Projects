# Assignment 0
## Program Description
**Program ./split <delimiter> <file1> <file2> ...**
 This program takes in files and replaces each character in the file with '\n'
 and prints its results on STDOUT_FILENO. The delimiter is only one-character which
 can be anything. The program has two cases for its <file> input:
  - Case 1, if '-' is given as a <file>, it would read in from STDIN_FILENO.
  - Case 2, if <file foo> is given as a <file>, it would read in from foo.
The program will run indefinitely until it goes through all inputs.

## Program Design
(Given from the pdf Assign 0:split vvv)
if '-' is given as a filename then split should use standard input as the next
input. that is split a foo '-' specifies that split first splits foo and then
splits std input. you can assume that - will only be used once in the list of
input files
split should work for an arbitrary number of files
split must work on binary input
split should produce error messeges and return codes
split should not have any memory leaks
split must support any single-character delimiter
split must be reasonably efficient
(Given from the pdf Assign 0:split ^^^)

I started off by writing code without using pseudo-code which was my first mistake.
Designing the program without having pseudo made it difficult for me to determine why certain
portions of the program were not producing the same results as the resources: split
Afterwards, I redesigned my program from the bottom up using psudeo-code and then writing it in C.
It got through more test cases and then I simply made the code more efficient in order to pass cases 8 and 15
The error I got stuck on the most was test case 7 which indefinitely stalled time until I realized you could
use warn() to produce the same results as the resources: split.

#Pseudo-Code
/***
check argc to see if there are more than 3 inputs
error message produce if there are less than 3 inputs

check argv[1] to see if it has multi character functions
error message produced if argv[1] has more than one character

for loop to go through argv[2+...]
  checks if '-' is in the argv
    sets file descriptor to STDIN_FILENO
  else set file descriptor to foo
    checks foo if it is a valid file at the same time
    set a boolean variable to true if it is invalid and continues

  while loop to go buffer through the text using read
    for loop through the buffer to check for delimiter
      if there is a character in the buffer that is equal to delimiter
        change the character in the buffer to \n
  write the buffer onto stdout/stderr

  close the fd before looping back again
if boolean variable is true and errno is not 0
  set errno to 2 as it is the exit code from resources for invalid files

return errno
***/

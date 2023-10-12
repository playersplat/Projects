/******************************
* Brian Bui, bbui3
* 2022 Spring CSE-130
* split.c
* Implementation file for split
* Programming Assignment: assgn0
******************************/
#include <ctype.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <err.h>
#include <stdio.h>
#include <errno.h>

extern int errno;
#define buf 4096

int main(int argc, char **argv) {
    /*
  if '-' is given as a filename then split hsould use standard input as the next
  input. that is split a foo '-' specifies that split first splits foo and then
  splits std input. you can assume that - will only be used once in the list of
  input files
  split should work for an arbitrary number of files
  split must work on binary input
  split should produce error messeages and return codes
  split should not have any memory leaks
  split must support any single-character delimiter
  split must be reasonbly efficient

  check argc to see if there are more than 3 inputs
    error message produce if there are less than 3 inputs

  check argv[1] to see if it has multi character functions
    error message produced if argv[1] has more than one character

  for loop to go through argv[2+...]
      checks if '-' is in the argv
        sets file descriptor to STDIN_FILENO
      else set file descriptor to foo
        checks foo if it is a valid file at the same time
        error code if it is invalid and continues looping through

      while loop to go buffer through the text using read
        for loop through the buffer to check for delimiter
          if there is a character in the buffer that is equal to delimiter
            change the character in the buffer to \n
      write the buffer onto stdout/stderr

      close the fd before looping back again


  */
    char buffer[buf];
    int inv_file = 0;
    if (argc < 3) {
        errx(22, "Not enough arguments\nusage: ./split: <split_char> [<file1> <file2> ...]");
    }

    if (strlen(argv[1]) > 1) {
        errx(22,
            "Cannot handle multi-character splits: %s\nusage: ./split: <split_char> [<file1> "
            "<file2> ...]",
            argv[1]);
    }
    for (int count = 2; count < argc; count++) { //i = 2 as it is after the delimiter argv[1]
        int file_desc;
        if (*argv[count] == '-') {
            file_desc = STDIN_FILENO; //sets file_desc = stdin
        } else {
            file_desc = open(argv[count], O_RDONLY); //sets file_desc to point to file "foo"
            if (file_desc == -1) {
                warn("%s", argv[count]);
                inv_file = 1;
            }
        }
        int bytes = 0;
        while ((bytes = read(file_desc, buffer, buf))
               > 0) { //while loop to buffer through file using read
            int counter = 0;
            while (
                bytes
                > counter) { //loops through buffer and replaces every character compared to delimiter
                if (buffer[counter] == *argv[1]) {
                    buffer[counter] = '\n';
                }
                counter++;
            }
            write(STDOUT_FILENO, buffer, bytes);
        }
        close(file_desc); //closes file_desc and loops again
    }
    if (errno == 9 && inv_file == 1) {
        errno = 2;
    }
    return errno;
}

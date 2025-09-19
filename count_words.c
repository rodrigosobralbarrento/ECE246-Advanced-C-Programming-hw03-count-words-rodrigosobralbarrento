// Modify this file
#include <stdio.h>
#include <string.h>
#include "count_words.h"

/*
Arguments:
    filename: name of the input file
    word: the word to search
    line: temporary space to store what is read from the file
    size: size of line

Return:
    frequency of word in file (subject to below constraints)    
*/
int countWord(char* filename, char* word, char* line, int size)
{
    // Open a file whose name is filename for reading
    FILE * file = fopen(filename, "r");

    // If fopen fails, return -1.
    if (file == NULL)
    {
        return -1;
    }

    // Else, set ret to zero
    int ret = 0;

    // Use fgets to read the file in line-by-line
    while (fgets(line, size, file) != NULL)
    {
        // If the word appears in the line, increment ret
        // It is possible that the same word appears multiple times in the line
        char * p = line;
        while ((p = strstr(p, word)) != NULL)
        {
            ret++;
            p += strlen(word);
        }
    }

    fclose(file);

    return ret;

    // EDGE CASES - READ CAREFULLY
    /* 1. If the word is split across multiple lines, DO NOT count the occurrence.
          For ex: line 1 - abcd, line 2 - efgh, word - cdef => Do not count occurrence of cdef */
    /* 2. If the line is "aaaaa" and the word is "aa", the count is defined as follows:
          The first two letters are consumed when the first match occurs. The next
          match starts at the third character. Thus, the correct answer is 2, not 4.*/
}
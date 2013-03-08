#include <stdio.h>
#include <stdlib.h>
#import "scan.h"
#import "parse.h"

void* ParseAlloc(void* (*allocProc)(size_t));
void* Parse(void*, int, const char*);
void* ParseFree(void*, void(*freeProc)(void*));

int parse_css(FILE *fh) {
    // Set up the scanner
    yyscan_t scanner;
    yylex_init(&scanner);
//    yyset_in(fh, scanner);

    return 1;

}


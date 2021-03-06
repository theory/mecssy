#include <stdio.h>
#include <stdlib.h>
#include "scan.h"
#include "parse.h"

void* ParseAlloc(void* (*allocProc)(size_t));
void* Parse(void*, int, const char*);
void* ParseFree(void*, void(*freeProc)(void*));

int parse_css(FILE *fh) {
    // Set up the scanner
    yyscan_t scanner;
    yylex_init(&scanner);
    yyset_in(fh, scanner);

    // Set up the parser
    void *css_parser = ParseAlloc(malloc);
    int lexCode;

    do {
        lexCode = yylex(scanner);
        printf("Got %i\n", lexCode);
        Parse(css_parser, lexCode, yyget_text(scanner));
    } while (lexCode > 0);

    // Finish the job.
    Parse(css_parser, 0, NULL);

    if (-1 == lexCode) {
        fprintf(stderr, "The scanner encountered an error.\n");
        return 0;
    }

    // Cleanup the scanner and parser
    yylex_destroy(scanner);
    ParseFree(css_parser, free);

    return 1;

}


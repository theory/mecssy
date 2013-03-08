#include <stdio.h>
#include "tap.h"
#include "scan.h"
#include "parse.h"

int main(int argc, char** argv) {
    plan_tests(10);
    pass("Everything compiled, yay!");
    FILE *fp;
    char *filename =  "test/css/basic.css";
    fp = fopen( filename, "rb" );
    if (!fp) {
        fprintf(stderr, "Cannot open %s: ", filename);
        perror(NULL);
        return 1;
    }

    // Set up the scanner
    yyscan_t scanner;
    yylex_init(&scanner);
    yyset_in(fp, scanner);
    pass("Set up to scan %s", filename);

    int lex_code;
    int i = 0;
    int expect[8] = {
        IDENT,  // body
        123,    // {
        IDENT,  // width
        58,     // :
        LENGTH, // 200px
        SEMI,   // ;
        125,    // }
        0
    };
    do {
        lex_code = yylex(scanner);
        ok(lex_code == expect[i], "Token %i should be %i", i, expect[i]);
        i++;
    } while (lex_code > 0);

	return exit_status();
}

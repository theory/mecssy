#include <stdio.h>
#include "tap.h"
#include "lecsster.h"

int main(int argc, char** argv) {
    plan_tests(2);
    pass("Everything compiled, yay!");
    FILE *fp;
    char *filename =  "test/css/basic.css";
    fp = fopen( filename, "rb" );
    if (!fp) {
        fprintf(stderr, "Cannot open %s: ", filename);
        perror(NULL);
        return 1;
    }
    ok( parse_css(fp), "Parse a simple CSS file" );
	return exit_status();
}

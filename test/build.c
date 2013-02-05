#include <stdio.h>
#include "tap.h"

int main(int argc, char** argv) {
    plan_tests(1);
    pass("Should be able to build everything");
	return exit_status();
}

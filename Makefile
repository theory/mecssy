CFLAGS := $(CFLAGS) -std=c99

SOURCE_DIR = src
BUILD_DIR  = build
TAP_DIR    = vendor/libtap
LEMON_DIR  = lemon

# Test stuff. http://stackoverflow.com/a/2706067/79202
TEST_SOURCE_DIR = test
TEST_BUILD_DIR  = $(BUILD_DIR)/$(TEST_SOURCE_DIR)
TEST_SOURCES    = $(wildcard $(TEST_SOURCE_DIR)/*.c)
TESTS           = $(TEST_SOURCES:$(TEST_SOURCE_DIR)/%.c=$(TEST_BUILD_DIR)/%)
test_CFLAGS 	= -g -I$(TAP_DIR)/src

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(TEST_BUILD_DIR):
	mkdir -p $(TEST_BUILD_DIR)

all: $(BUILD_DIR)

lecsster: src/main.o src/parse.o src/scan.o
	$(CC)) $(CFLAGS) -o $(BUILD_DIR)/lecsster src/main.o src/parse.o src/scan.o

src/main.o: src/main.c src/parse.h src/scan.h

src/parse.o: src/parse.h src/parse.c

src/parse.h src/parse.c: src/parse.y $(BUILD_DIR)/lemon
	$(BUILD_DIR)/lemon -T$(LEMON_DIR)/lempar.c src/parse.y

src/scan.o: src/scan.h

src/scan.h: src/scan.l
	@LANG=C
	flex --outfile=src/scan.c --header-file=src/scan.h src/scan.l

# Prevent yacc from trying to build parsers.
# http://stackoverflow.com/a/5395195/79202
%.c: %.y

$(BUILD_DIR)/lemon: $(BUILD_DIR) $(LEMON_DIR)/lemon.c
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/lemon $(LEMON_DIR)/lemon.c

clean:
	rm -rf $(BUILD_DIR) $(TAP_DIR)/src/tap.o

check: $(TEST_BUILD_DIR) $(TESTS)
	prove $(TESTS)

$(TEST_BUILD_DIR)/%: $(TEST_SOURCES) $(TAP_DIR)/src/tap.o
	$(CC) $(CFLAGS) $(test_CFLAGS) -o $@ $(TAP_DIR)/src/tap.o $<

$(TAP_DIR)/src/tap.o: $(TAP_DIR)/src/tap.h

.PHONY: clean prove

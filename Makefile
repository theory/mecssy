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

lecsster: $(SOURCE_DIR)/main.o $(SOURCE_DIR)/parse.o $(SOURCE_DIR)/scan.o
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/lecsster $(SOURCE_DIR)/main.o $(SOURCE_DIR)/parse.o $(SOURCE_DIR)/scan.o

$(SOURCE_DIR)/main.o: $(SOURCE_DIR)/main.c $(SOURCE_DIR)/parse.h  $(SOURCE_DIR)/scan.h

$(SOURCE_DIR)/parse.o: $(SOURCE_DIR)/parse.c

$(SOURCE_DIR)/scan.o: $(SOURCE_DIR)/scan.c $(SOURCE_DIR)/parse.h $(SOURCE_DIR)/parse.o

$(SOURCE_DIR)/parse.h $(SOURCE_DIR)/parse.c: $(SOURCE_DIR)/parse.y $(BUILD_DIR)/lemon
	$(BUILD_DIR)/lemon -T$(LEMON_DIR)/lempar.c $(SOURCE_DIR)/parse.y

$(SOURCE_DIR)/scan.h: $(SOURCE_DIR)/scan.l
	@LANG=C
	flex --outfile=$(SOURCE_DIR)/scan.c --header-file=$(SOURCE_DIR)/scan.h $(SOURCE_DIR)/scan.l

# Prevent yacc from trying to build parsers.
# http://stackoverflow.com/a/5395195/79202
%.c: %.y

$(BUILD_DIR)/lemon: $(BUILD_DIR) $(LEMON_DIR)/lemon.c
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/lemon $(LEMON_DIR)/lemon.c

clean:
	rm -rf $(BUILD_DIR) $(TAP_DIR)/src/tap.o
	rm $(SOURCE_DIR)/*.o
	rm $(SOURCE_DIR)/scan.c
	rm $(SOURCE_DIR)/scan.h
	rm $(SOURCE_DIR)/parse.c
	rm $(SOURCE_DIR)/parse.h
	rm $(SOURCE_DIR)/parse.out

check: $(TEST_BUILD_DIR) $(TESTS)
	prove $(TESTS)

$(TEST_BUILD_DIR)/%: $(TEST_SOURCES) $(TAP_DIR)/src/tap.o
	$(CC) $(CFLAGS) $(test_CFLAGS) -o $@ $(TAP_DIR)/src/tap.o $<

$(TAP_DIR)/src/tap.o: $(TAP_DIR)/src/tap.h

.PHONY: clean prove

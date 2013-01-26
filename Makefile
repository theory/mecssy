CFLAGS := $(CFLAGS) -std=c99

SOURCE_DIR = src
BUILD_DIR  = build

# Test stuff. http://stackoverflow.com/a/2706067/79202
TEST_SOURCE_DIR = test
TEST_BUILD_DIR  = $(BUILD_DIR)/$(TEST_SOURCE_DIR)
TEST_SOURCES    = $(wildcard $(TEST_SOURCE_DIR)/*.c)
TESTS           = $(TEST_SOURCES:$(TEST_SOURCE_DIR)/%.c=$(TEST_BUILD_DIR)/%)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(TEST_BUILD_DIR):
	mkdir -p $(TEST_BUILD_DIR)

lecsster: src/main.o src/parse.o src/scan.o
	$(CC)) $(CFLAGS) -o build/lecsster src/main.o src/parse.o src/scan.o

src/main.o: src/main.c src/parse.h src/scan.h

src/parse.o: src/parse.h src/parse.c

src/parse.h src/parse.c: src/parse.y lemon/lemon
	./lemon/lemon src/parse.y

src/scan.o: src/scan.h

src/scan.h: src/scan.l
	flex --outfile=src/scan.c --header-file=src/scan.h src/scan.l

# Prevent yacc from trying to build parsers.
# http://stackoverflow.com/a/5395195/79202
%.c: %.y

build/lemon: lemon/lemon.c
	$(CC)) $(CFLAGS) -o build/lemon lemon/lemon.c

clean:
	rm -rf build

prove: $(TEST_BUILD_DIR) $(TESTS)
	prove $(TESTS)

$(TEST_BUILD_DIR)/%: $(TEST_SOURCES)
	$(CC) $(CFLAGS) -o $@ $<

vendor/libtap/src/tap.o: vendor/libtap/src/tap.h

builddir:
	mkdir -p build

.PHONY: clean prove

CFLAGS := $(CFLAGS) -std=c99

lecsster: src/main.o src/parse.o src/scan.o
	$(CC) -o lecsster src/main.o src/parse.o src/scan.o

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

lemon/lemon: lemon/lemon.c
	$(CC) -o lemon/lemon lemon/lemon.c

.PHONY: clean
clean:
	rm -f *.o
	rm -f src/scan.c src/scan.h
	rm -f src/parse.c src/parse.h src/parse.out
	rm -f css lemon/lemon

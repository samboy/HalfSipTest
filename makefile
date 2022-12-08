CC=gcc
CFLAGS=-Wall --std=c99 
SRC=siphash.c halfsiphash.c test.c testmain.c
HEADERS=siphash.h halfsiphash.h
BIN=test debug vectors

.PHONY: analyze sanitize lint format clean  


all:                    $(BIN)

everything:             clean format lint analyze sanitize test vectors

test:                   $(SRC)
			$(CC) $(CFLAGS) test.c -o $@ 

debug:                  $(SRC) 
			$(CC) $(CFLAGS) -g debug.c -o $@ -DDEBUG_SIPHASH

vectors:                $(SRC) 
			$(CC) $(CFLAGS) vectors.c -o $@ -DGETVECTORS

analyze:                $(SRC)
			scan-build $(CC) $(CFLAGS) analyze.c -o $@
			rm -f $@

sanitize:               $(SRC)
			$(CC) -fsanitize=address,undefined $(CFLAGS) \
				sanitize.c -o $@
			./$@
			rm -f $@

lint:                   $(SRC) $(HEADERS) 
			cppcheck --std=c99 lint.c
format:
		        clang-format \
				-style="{BasedOnStyle: llvm, IndentWidth: 4}" \
			-i *.c *.h 
clean:
			rm -f *.o $(BIN) analyze sanitize



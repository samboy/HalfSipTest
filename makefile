CC=gcc
CFLAGS=-Wall --std=c99 
SRC=siphash.c halfsiphash.c test.c testmain.c
HEADERS=siphash.h halfsiphash.h
BIN=test debug vectors maraAPI

.PHONY: analyze sanitize lint format clean  


all:                    $(BIN)

everything:             clean format lint analyze sanitize test vectors

test:                   $(SRC)
			$(CC) $(CFLAGS) $(SRC) -o $@ 

debug:                  $(SRC) 
			$(CC) $(CFLAGS) -g $(SRC) -o $@ -DDEBUG_SIPHASH

vectors:                $(SRC) 
			$(CC) $(CFLAGS) $(SRC) -o $@ -DGETVECTORS

maraAPI:		$(SRC) maraAPI.c
			$(CC) $(CFLAGS) maraAPI.c halfsiphash.c \
				-DcROUNDS=1 -DdROUNDS=3 -o $@

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



WARNING = -Wall -Wshadow --pedantic
ERROR   = -Wvla -Werror
GCC     = gcc -std=c11 -g $(WARNING) $(ERROR)

SRCS = main.c count_words.c
OBJS = $(SRCS:%.c=%.o)

# -------- Platform detection (Windows + Linux/macOS) --------
# If OS=Windows_NT but we're inside MSYS/MinGW Bash, prefer POSIX tools.
ifeq ($(OS),Windows_NT)
  UNAME_S := $(shell uname -s 2>NUL)
  ifneq (,$(findstring MINGW,$(UNAME_S)))
    WINDOWS_BASH := 1
  endif
endif

ifeq ($(OS),Windows_NT)
  ifdef WINDOWS_BASH
    EXE   := count_words
    RUN   := ./$(EXE)
    DIFF  := diff
    RM    := rm -f
    VAL   := valgrind
    SHELL := /usr/bin/sh
  else
    EXE   := count_words.exe
    RUN   := .\$(EXE)
    DIFF  := fc
    RM    := del /Q
    VAL   :=
    SHELL := cmd
  endif
else
  EXE   := count_words
  RUN   := ./$(EXE)
  DIFF  := diff
  RM    := rm -f
  VAL   := valgrind
  SHELL := /bin/sh
endif

# -------- Build rules --------
.PHONY: all clean testall test1 test2 test3 test4 test5 test6 test7 test8 test9 leak
all: $(EXE)

count_words: $(EXE)   

$(EXE): $(OBJS)
	$(GCC) $(OBJS) -o $(EXE)

.c.o:
	$(GCC) -c $< -o $@

# -------- Tests --------
testall: test1 test2 test3 test4 test5 test6 test7 test8 test9

test1: $(EXE)
	$(RUN) inputs/test1 aa >> output1
	$(DIFF) output1 expected/expected1

test2: $(EXE)
	$(RUN) inputs/test2 abc >> output2
	$(DIFF) output2 expected/expected2

test3: $(EXE)
	$(RUN) inputs/test3 I >> output3
	$(DIFF) output3 expected/expected3

test4: $(EXE)
	$(RUN) inputs/test4 and >> output4
	$(DIFF) output4 expected/expected4

test5: $(EXE)
	$(RUN) inputs/test5 clock >> output5
	$(DIFF) output5 expected/expected5

test6: $(EXE)
	$(RUN) inputs/test6 pink >> output6
	$(DIFF) output6 expected/expected6

test7: $(EXE)
	$(RUN) inputs/test7 noodle >> output7
	$(DIFF) output7 expected/expected7

test8: $(EXE)
	$(RUN) inputs/test8 lucky >> output8
	$(DIFF) output8 expected/expected8

test9: $(EXE)
	$(RUN) inputs/test9 vial >> output9
	$(DIFF) output9 expected/expected9

# Valgrind is not available on native Windows
leak: $(EXE)
	$(VAL) $(RUN) inputs/test9 vial

# -------- Clean --------# 
# remove all machine generated files
clean:
	-$(RM) $(EXE) *.o *.txt output* 2>NUL || true

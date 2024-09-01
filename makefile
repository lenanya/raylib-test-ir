all: main

main: main.ll
	clang -o main main.ll -L./raylib/lib -l:libraylib.a -lm

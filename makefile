all: main main.exe

main: main.ll
	clang -o main main.ll -L./raylib/lib -l:libraylib.a -lm

main.exe: main.ll
	clang -target i686-w64-mingw32 -c main.ll -o main.obj # -Iraylib/include -Lraylib/lib -lraylib -lwinm -lopengl32 -lgdi32
	i686-w64-mingw32-gcc main.obj -o main.exe -Iraylib/include -Lraylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm

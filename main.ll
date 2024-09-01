target triple = "x86_64-pc-linux-gnu"

@width = global i32 600
@height = global i32 600
@.str = constant [5 x i8] c"test\00"
@title = global i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i32 0, i32 0)

define void @update(i32* %x, i32* %y, i32* %w, i32* %h, i32* %sx, i32* %sy) {
%ox = load i32, i32* %x
%oy = load i32, i32* %y
%ow = load i32, i32* %w
%oh = load i32, i32* %h
%osx = load i32, i32* %sx
%osy = load i32, i32* %sy
%nx = add nsw i32 %ox, %osx
%ny = add nsw i32 %oy, %osy
br label %chkx

chkx:
	%xk1 = icmp slt i32 %nx, 0
	%nxpw = add nsw i32 %nx, %ow
	%scrw = load i32, i32* @width
	%xk2 = icmp sgt i32 %nxpw, %scrw
	%xk = or i1 %xk1, %xk2
	br i1 %xk, label %revx, label %mvx

revx:
	%nsx = mul i32 %osx, -1
	store i32 %nsx, i32* %sx
	br label %mvx
	
mvx:
	%csx = load i32, i32* %sx
	%cx = add i32 %ox, %csx
	store i32 %cx, i32* %x
	br label %chky

chky:
	%yk1 = icmp slt i32 %ny, 0
	%nyph = add nsw i32 %ny, %oh
	%scrh = load i32, i32* @height
	%yk2 = icmp sgt i32 %nyph, %scrh
	%yk = or i1 %yk1, %yk2
	br i1 %yk, label %revy, label %mvy

revy:
	%nsy = mul i32 %osy, -1
	store i32 %nsy, i32* %sy
	br label %mvy
	
mvy:
	%csy = load i32, i32* %sy
	%cy = add i32 %oy, %csy
	store i32 %cy, i32* %y
	ret void
}

define i32 @main() {
%width = load i32, i32* @width
%height = load i32, i32* @height
%title = load i8*, i8** @title
call void @InitWindow(i32 %width, i32 %height, i8* %title)
call void @SetTargetFPS(i32 60)
br label %init

init:
	%x = alloca i32
	%y = alloca i32
	%w = alloca i32
	%h = alloca i32
	%sx = alloca i32
	%sy = alloca i32
	store i32 5, i32* %x
	store i32 5, i32* %y
	store i32 50, i32* %w
	store i32 50, i32* %h
	store i32 2, i32* %sx
	store i32 2, i32* %sy
	br label %loop

loop:
	%exit = call i1 @WindowShouldClose()
	br i1 %exit, label %end, label %run

run:
	call void @BeginDrawing()
	call void @ClearBackground(i32 u0xFF505050)
	%mx = load i32, i32* %x
	%my = load i32, i32* %y
	%mw = load i32, i32* %w
	%mh = load i32, i32* %h
	%msx = load i32, i32* %sx
	%msy = load i32, i32* %sy
	call void @DrawRectangle(i32 %mx, i32 %my, i32 %mw, i32 %mh, i32 u0xFFFF91FF)
	call void @update(i32* %x, i32* %y, i32* %w, i32* %h, i32* %sx, i32* %sy)
	call void @EndDrawing()
	br label %loop

end:
	call void @CloseWindow()
	ret i32 0
}

declare void @InitWindow(i32, i32, i8*)
declare void @CloseWindow()
declare i1 @WindowShouldClose()
declare void @BeginDrawing()
declare void @EndDrawing()
declare void @ClearBackground(i32)
declare void @SetTargetFPS(i32)
declare float @GetFrameTime()
declare void @DrawRectangle(i32, i32, i32, i32, i32)

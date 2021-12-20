; desc:	实验11题答案
; author:	johnsonHe
; date: 2021/12/17

assume cs:codesg
datasg segment
	db "Beginner's All-purpose Symbolic Instruction Code.", 0
	db 50 dup(10)
datasg ends

codesg segment
	mov ax, 4c00h
	int 21h
	start:
		mov ax, datasg
		mov ds, ax
		mov si, 0
		mov di, 50
		call letterc

		letterc:
			push ax
			push ds
			push si
			push di

			cmpchar:
				mov al, ds:[si]
				cmp al, 0
				je last ;到达最后个0结尾字符结束

				cmp al, 65
				jb next
				cmp al, 90
				ja next

				add al, 11011111b 

			next:
				mov [di], al
				inc di
				inc si
				jmp cmpchar

			last:
				pop di
				pop si
				pop ds
				pop ax
				ret

codesg ends
	end start

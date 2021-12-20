assume cs:codesg


codesg segment
	mov ax, 4c00h
	int 21h
	start:
		mov ax, cx 
		mov ds, ax
		mov si, capital
		mov ax, 0
		mov es, ax 
		mov di, 200h
		mov cx, offset capitalend - offset capital
		cld
		rep movsb

		mov ax, 0
		mov es, ax
		mov word ptr es:[7ch*4], 200h
		mov word ptr es:[7ch*4+2], 0

		capital:
			push bp
			mov bp, sp
			add [bp+2], bx
			pop bp
			iret

		capitalend:
			nop



codesg ends
end start
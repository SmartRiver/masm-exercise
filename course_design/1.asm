; desc: 课程设计1
; author:johnsonhe0306@gmail.com
; date: 2021/12/14

assume cs:code,ss:sgstack
data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1900','1991','1992'
	db '1993','1994','1995'


	dd 16,22,382,1356,4390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000


	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
data ends


dtable segment
  db 50 dup(0) 
dtable ends

sgstack segment
	db 30 dup(0)
sgstack ends

code segment
	start:
		; 获取每一行的3个数据
		mov ax, data
		mov ds, ax

		mov ax, sgstack
		mov ss, ax
		mov sp, 16

		mov si, 0
		mov di, 0
		mov cx, 21
		mov bx, 0 ; 记录显示器每行打印字符串的起始偏移位置
	
		s: ; 21行循环
			mov ax, dtable
			mov es, ax

			; 写入年份
			mov ax, ds:[si]
			mov es:[0], ax
			mov ax, ds:[si+2]
			mov es:[2], ax

			; 写入职员人数
			mov ax, ds:[84+84+di]
			mov bp, 20
			mov dx, 0h
			call dtoc

			; 写入总收入
			mov ax, ds:[84+si]	; 低16位
			mov dx, ds:[84+si+2]	; 高16位
			mov bp, 8 
			call dtoc

			; 计算人均薪资
			push cx
			mov cx, ds:[84+84+di]
			call divdw
			pop cx
			mov bp, 30
			call dtoc

			;递增公司数据偏移量
			add si, 4 ; 年份、收入占4个字节，需要偏移4个字节
			add di, 2 ; 职员人数dw占2个字节，需要偏移2个字节

			;将table显示
			call show_str
			add bx, 0A0h

			loop s

		mov ax, 4c00h
		int 21h

	; 转换字符串为ascii码 , 年收入，总人数
	dtoc:
		push ax
		push bx
		push cx
		push dx
		push ds
		push es
		push si
		push di
		push bp

		mov si, 0

		change:
			mov cx, 10 
			call divdw
			mov bx, cx
			add bx, 30H
			push bx ; 将余数压栈
			inc si
			mov cx, ax
			add cx, dx
			jcxz last
			jmp short change

		; 将栈里的余数依次出栈
		last:
			mov cx, si
			mov si, 0
			s1:
					pop es:[bp+si]
					inc si
					loop s1

		exit: 
			pop bp
			pop di
			pop si
			pop es
			pop ds
			pop dx
			pop cx
			pop bx
			pop ax
			ret
	
	; 展示字符串
	show_str:   
		push ax
		push bx
		push cx
		push dx
		push ds
		push es
		push si
		push di
		push bp


		mov dh, 2
		mov dl, 3
		mov cl, 2
		mov ax, dtable 
		mov ds, ax
		mov si, 0

		;计算开始的字符串显示内存位置
		mov al,0A0h 
		mul dh
		add bx, ax

		mov al, 2
		mul dl
		add bx, ax
		
		mov ax, 0B800h 
		mov es, ax

		mov al, cl
		mov di, 0
		mov ch, 0
	
		mov cx, 50
		mov si, 0
		show: 
			mov ah, ds:[si]
			mov es:[bx+di], ah
			mov es:[bx+di+1], al
			add di, 2
			inc si
			loop show

		ok:     
			pop bp
			pop di
			pop si
			pop es
			pop ds
			pop dx
			pop cx
			pop bx
			pop ax
			ret

	divdw:
		push bx
		push ax
		mov ax,dx
		mov dx,0
		div cx
		mov bx,ax
		pop ax
		div cx
		mov cx,dx
		mov dx,bx

		pop bx
		ret

code ends
end start

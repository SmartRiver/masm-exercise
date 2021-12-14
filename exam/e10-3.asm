assume cs:code
data segment
    db 10 dup(0)
data ends

code segment
    start:      
        ; 转换字符串为ascii码
        mov ax, 12666
        mov bx, data
        mov ds, bx
        call dtoc


        ; 将字符串显示在显示器中
        mov dh, 8
        mov dl, 3
        mov cl, 2
        mov ax, data
        mov ds, ax
        mov si, 0
        call show_str

        mov ax, 4c00h
        int 21h
    ; 转换字符串为ascii码 
    dtoc:
        push ax
        push bx
        push cx

        mov si, 0
        mov bx, 10

        change:
            mov dx, 0
            div bx
            mov cx, ax
            jcxz last
            add dx, 30H
            push dx ; 将余数压栈
            inc si
            jmp short change

        ; 将栈里的余数依次出栈
        last:
            add dx, 30H
            push dx
            inc si

            mov cx, si
            mov si, 0
            s:
                pop ds:[si]
                inc si
                loop s
    
        exit:   
            pop cx
            pop bx
            pop ax
            ret
                

    ; 展示字符串
    show_str:   push ax
                push bx
                push dx
                push si
                mov bx, 0

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
                
        show: mov cl, ds:[si]
                jcxz ok
                mov es:[bx+di], cl
                mov es:[bx+di+1], al
                add di, 2
                inc si
                jmp short show

        ok:     pop si
                pop dx
                pop bx
                pop ax
                ret

code ends
end start
format PE Console 4.0

entry start
include 'win32a.inc'
include 'win_macros.inc'

section '.text' code readable executable
start:

	ustaw_kursor 0,0
	wyswietl txt
	ustaw_kursor 0,15
	mov ecx,4
	mov edi,0
ety1:
	push ecx

ety2:
	pob_znak
		

	cmp al,1bh	;Esc
	je wend

	cmp al,8		;Backspace
	jne ety3

backspaceclick:
	cmp edi, 0
	je notindex
	dec edi
	notindex:
	pop ecx
	cmp ecx,4
	je  ety1
	inc ecx
	push ecx
	wysw_znak 8
	wysw_znak ' '
	wysw_znak 8
	jmp ety2
backspaceindex:
push ecx
mov edi, 4
jmp backspaceclick
ety3:
	cmp al,'0'
	jb  ety2
	cmp al,'9'
	jbe ety4
	cmp al,'A'
	jb  ety2
	cmp al,'F'
	jbe ety4
	cmp al,'a'
	jb  ety2
	cmp al,'f'
	ja  ety2 
	


ety4:
    wysw_znak al
	pop ecx
	mov [tab+edi], al
	inc edi
	DEC ECX
	JNZ ety1
    mov edi, 0

enterclick:
	pob_znak


	cmp al,8		;Backspace
	je backspaceindex
	cmp al,13	;enter
	jne enterclick	      
    
ustaw_kursor 1,0
wyswietl bintxt
ustaw_kursor 1,8
    
    
    
wbin:	   ;binarny zapis


   
    mov al, [tab+edi]
	cmp al,'9'
	jbe numeric
	cmp al,'F'
	jbe big
	cmp al,'f'
	jbe  small 
numeric:

	mov bl,[tab+edi]
	sub bl, 30h	   ;odjecie ASCII
	jmp wwbin
big:			     ;A-F
       mov bl,[tab+edi]
       sub bl, 37h	  ;odjecie ASCII   
       jmp wwbin   

small:			     ;a-f
	mov bl,[tab+edi]
	sub bl, 57h	   ;odjecie ASCII
wwbin:			   ;wyswietlanie 0 i 1
	mov cx,4	   
	shl bl, 4
    lty1:
	push cx
	rcl bl,1
	jc lty2
	mov dl,'0'
	jmp lty3
    lty2:
	mov dl,'1'
    lty3:
	wysw_znak dl
	mov dh,0	    ;do zmiennej bin wpisywana postac binarna
	sub dl, 30h
	shl [bin], 1
	add [bin], dx
	pop cx
	loop lty1
     wysw_znak ' ' 

    inc di	
    cmp di, 4
    jb wbin

woct:	ustaw_kursor 2,0
	wyswietl octtxt
	ustaw_kursor 2,8
	mov ax,[bin]	  ;pierwsza trojka od lewej - jeden znak
	shr ax,15
	add ax,30h			   
	wysw_znak al

	mov ax,[bin]	  ;druga trojka
	shl ax,1
	shr ax,13
	add ax,30h			   
	wysw_znak al

	mov ax,[bin]	  ;trzecia trojka  
	shl ax,4
	shr ax,13
	add ax,30h			   
	wysw_znak al

	mov ax,[bin]	   ;czwarta trojka
	shl ax,7
	shr ax,13
	add ax,30h			   
	wysw_znak al

	mov ax,[bin]	   ;piata trojka
	shl ax,10
	shr ax,13
	add ax,30h			
	wysw_znak al

	mov ax,[bin]	   ;szosta trojka
	and ax,7
	add ax,30h
	wysw_znak al
			
    
wdec:	
	ustaw_kursor 3,0
	wyswietl dectxt
	ustaw_kursor 3,8
	
	mov cx, 5
	mov ax, [bin]
	decc:
	mov dx, 0	 ;wyzeruj reszte
	push cx
	mov  cx, 10	 ;dzielnik=10
	div cx		 ;podziel ax/cx ->ax r. dx
	pop cx
	add dx, 30h	 ;ASCII
	push dx 	 ;reszta na stos
	loop decc 
	
	mov cx, 5	 ;sciaganie ze stosu i wyswietlanie
	wysw_dec:
	pop ax
	wysw_znak al
	loop wysw_dec
	
	
	



     
whex:	       ;wyswietl hex
    ustaw_kursor 4,0
    wyswietl hextxt
    ustaw_kursor 4,8
    mov di, 0
    mov cl, 4
petla1:
    mov al, [tab+edi]
    cmp al, 97
    jb bezzmian
    sub al, 32	  ;zmiana a -> A
  bezzmian: 
    wysw_znak al
    inc di
    loop petla1

    pob_znak
    jmp start
	 wend:
	end_prog 


section '.data' data readable writeable
	txt db 'Linia polecen: ',NULL
	bintxt db '[BIN] = ',NULL
	octtxt db '[OCT] = ',NULL
	dectxt db '[DEC] = ',NULL
	hextxt db '[HEX] = ',NULL
	bin dw 0
	tab db 4 dup(0)


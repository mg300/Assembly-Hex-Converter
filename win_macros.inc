;win_macros.inc

;macros:
; pob_znak			 - pobierz 1 znak ASCII bez echa (po wykonaniu makra znak znajduje siê w rejestrze AL)
; pob_znak_ECHO 		 - pobierz 1 znak ASCII z echem (po wykonaniu makra znak znajduje siê w rejestrze AL)
; ustaw_kursor wiersz, kolumna	 - ustaw kursor na pozycji 'wiersz','kolumna'
; wyswietl txt			 - wyœwietl zmienn¹ tekstow¹ o nazwie podanej jako argument
; wysw_znak znak_ASCII		 - wyœwietla 1 znak ASCII ze zmiennej podanej jako argument
; end_prog			 - koñczy program




;//  C++
;  COORD coordScreen = { 0, 0 };  // upper left corner
;  DWORD cCharsWritten;
;  DWORD dwConSize;
;  HANDLE hCon = GetStdHandle(STD_OUTPUT_HANDLE);
;  CONSOLE_SCREEN_BUFFER_INFO  csbi;
   
;  GetConsoleScreenBufferInfo(hCon, &csbi);
;  dwConSize = csbi.dwSize.X * csbi.dwSize.Y;
;  // fill with spaces
;  FillConsoleOutputCharacter(hCon, TEXT(' '), dwConSize, coordScreen, &cCharsWritten);
;  GetConsoleScreenBufferInfo(hCon, &csbi);
;  FillConsoleOutputAttribute(hCon, csbi.wAttributes, dwConSize, coordScreen, &cCharsWritten);
;  // cursor to upper left corner
;  SetConsoleCursorPosition(hCon, coordScreen);

;-----------------------------------------------------------------------------------------------------
;	pob_znak
;-----------------------------------------------------------------------------------------------------
; dos:
;	mov ah,7
;	int 21h
;
; out:	AL - kod ASCII
;
; windows:
macro pob_znak
{
	pushad
	cinvoke getch
	mov [temp_eax], eax
	popad
	mov eax,[temp_eax]
}

;-----------------------------------------------------------------------------------------------------
;	pob_znak_ECHO
;-----------------------------------------------------------------------------------------------------
; dos:
;	mov ah,1
;	int 21h
;
; out:	AL - kod ASCII
;
; windows:
macro pob_znak_ECHO
{
	pushad
	cinvoke getch
	mov [temp_eax], eax
	cinvoke putchar, eax
	popad
	mov eax,[temp_eax]
}

;-----------------------------------------------------------------------------------------------------
;	ustaw_kursor
;-----------------------------------------------------------------------------------------------------
; dos:
;	mov ah,2
;	mov bh,0
;	mov dl,[kolumna]
;	mov dh,[wiersz]
;	int 10h
; windows:
macro ustaw_kursor wiersz, kolumna
{
	pushad
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov [hCon],eax
	mov ax,wiersz
	shl eax,16
	mov ax,kolumna
	invoke SetConsoleCursorPosition,[hCon],eax
	popad
}


;-----------------------------------------------------------------------------------------------------
;	wyswietl
;-----------------------------------------------------------------------------------------------------
; dos:
;	mov ah,9
;	mov dx, offset TXT
;	int 21h
;
; windows:
macro wyswietl txt
{
       pushad
       cinvoke printf, txt
;	cinvoke puts, txt
       popad
}


;-----------------------------------------------------------------------------------------------------
;	wysw_znak_ASCII
;-----------------------------------------------------------------------------------------------------
; dos:
;	mov ah,2
;	mov dl,'ASCII'
;	int 21h
;
; windows:
macro wysw_znak znak_ASCII
{
	pushad
	mov al, znak_ASCII
	cbw
	cwde
	cinvoke putchar, eax
	popad
}



;-----------------------------------------------------------------------------------------------------
;	end_prog
;-----------------------------------------------------------------------------------------------------
; dos:
;	mov ah,4Ch
;	int 21h
;
; windows:
macro end_prog
{
       invoke ExitProcess
}



section '.data' data readable writeable
	cCharsWritten	      dd				 ?;
	ConSize 	      dd				 ?;
	hCon		      dd				 ?;
	temp_eax	      dd				 ?


section '.idata' import data readable writeable
     library msvcrt,'MSVCRT.DLL',\
	     kernel32,'KERNEL32.DLL'

     import msvcrt,\
     getch,'_getch',\
     putchar,'putchar',\
     puts,'puts',\
     printf,'printf',\
     scanf,'scanf'

     import kernel32,\
     SetConsoleCursorPosition,'SetConsoleCursorPosition',\
     GetStdHandle,'GetStdHandle',\
     GetConsoleScreenBufferInfo,'GetConsoleScreenBufferInfo',\
     FillConsoleOutputCharacter,'FillConsoleOutputCharacterA',\
     FillConsoleOutputAttribute,'FillConsoleOutputAttribute',\
     ExitProcess,'ExitProcess'


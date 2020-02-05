; Obowiązujące kierunki
; 0 - w dół
; 1 - w lewo
; 2 - w góre
; 3 - w prawo

	org 32768
	jp start	; Skok do procedury inicjującej

; Bufor cykliczny z wężem
frg	defs 2*22*32	; Bufor cykliczny w którym umieszczane są fragmenty węża postaci (x, y)
frgstart	defb 0		; Początek buforu cyklicznego
frgend	defb 0		; Koniec buforu cyklinicznegu

curdir	defb 0	; Aktualny kierunek węża
newdir	defb 0	; Kierunek gdzie chce się ruszyć gracz

curlen	defb 0	; Aktualna długość węża
totallen	defb 0	; Całkowita długość węża

score	defs 0	; Wynik wyświetlany na ekranie

; Mapa z blokami z którymi można się zderzać
; 1-blok jest	2-bloku nie ma
blocks	defb 255, 255, 255, 255
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 255, 255, 255, 255

; Pozycja poruszającego się jedzenia
creatx	defb 0
creaty	defb 0

; Kierunek poruszającego się jedzenia
creatvx	defb 0
creatvy	defb 0

; Pozycja nieruchomego jedzenia
mealx	defb 0
mealy	defb 0

curlevel	defb 0	; Aktualny poziom

block	defb 255,255,255,255,255,255,255,255	; Grafika bloku
	
	
; Instrukcje wywoływane przy ładowaniu gry
start:	;ld hl, block	
	;ld (23675), hl	
	
	ld a, 2
	call 5633
	;ld a, 144
	;rst 16
	call loadlvl
	call dispblocks
here	jp here
	ret
	
loadlvl	ld hl, (curlevel)
	ld b, (hl)
	ld de, lvllen
	ld hl, levels
	ld a, 0
addlvl	cp b
	jr z, copyblocks
	inc a
	add hl, de
	jp addlvl

copyblocks	ld de, blockso
	add hl, de
	ld de, blocks
	ld bc, 88
	ldir
	ret
	
dispblocks:	ld hl, block	; Ustawienie znaku 144 na blok
	ld (23675), hl
	
	ld hl, blocks
	
	ld b, 88
bytejp	ld e, b
	ld b, 8
bitjp	rlc (hl)
	jr nc, setsp
setbl	ld a, 144
	jp dispbl
setsp	ld a, 'x'
dispbl	rst 16
	djnz bitjp
	ld b, e
	inc hl
	djnz bytejp
	ret

; Grafiki dla prostego fragmentu węża
str_h	defb 0,255,187,255,238,255,255,0
str_v	defb 255,0,68,0,17,0,0,255

; Grafiki dla skręcającego fragmentu węża
turn_dl	defb 0,3,14,23,63,61,95,118
turn_ul	defb 110,250,188,252,232,112,192,0
turn_ur	defb 94,123,63,46,31,13,3,0
turn_dr	defb 0,3,14,23,63,61,95,118

; Grafiki dla jedzącego węża
eat_d	defb 126,126,126,126,90,126,36,0
eat_l	defb 0,63,111,63,63,111,63,0
eat_u	defb 0,36,126,90,126,126,126,126
eat_r	defb 0,252,246,252,252,246,252,0

; Grafiki głowy węża
head_d	defb 126,126,126,126,90,126,60,24
head_l	defb 0,63,111,255,255,111,63,0
head_u	defb 24,60,126,90,126,126,126,126
head_r	defb 0,252,246,255,255,246,252,0

; Grafiki dla ogona węża
tail_d	defb 24,60,60,110,126,122,126,110
tail_l	defb 0,248,254,119,255,222,248,0
tail_u	defb 118,126,94,126,118,60,60,24
tail_r	defb 0,31,123,255,238,127,31,0

; Grafika dla schodów
stairs_u	defb 3,3,15,11,49,59,251,255
stairs_d	defb 192,192,240,208,220,140,223,255


levels
	; Poziom1
	
	; Grafiki dla myszy
creat0	defb 24,60,126,219,255,36,90,165	; dół
	defb 0,0,120,255,120,0,0,0	; lewo
	defb 8,28,28,28,28,8,8,8	; góra
	defb 0,0,0,30,255,30,0,0	; prawo
	
	; Grafika dla jabłka
meal0	defb 3,3,15,11,49,59,251,255

	; Grafika dla bloku
block0	defb 255,255,255,255,255,255,255,255
	
	; Mapa z blokami
blocks0	defb 255, 255, 255, 255
	defb 255, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 128, 0, 0, 1
	defb 255, 255, 255, 255
	
	; Współrzędne wejścia x, y
inpos0	defb 10, 10	

	; Kierunek w którym ma się poruszać wąż po pojawieniu się
indir0	defb 0
	
	; Współrzędne wyjścia x, y
outpos0	defb 20, 20	
	
	; Wynik potrzebny do otwarcia wyjścia
scoren0	defb 10
end0


; Obliczenie adresów elementów mapy względem jej początku
creato	equ creat0-levels
mealo	equ meal0-levels
blockso	equ blocks0-levels
inpos	equ inpos0-levels
outpos 	equ outpos0-levels
scoreno	equ scoren0-levels
lvllen	equ end0-levels






	
	
       

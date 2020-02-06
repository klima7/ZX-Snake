; PIERWSZA WYKONYWANA PROCEDURA
START:	ld a, 2		; Wybranie drugieko kanału do otwarcia
	call 5633		; Wywołanie procedury otwierającej kanał
	call LOADLEVEL		; Załadowanie pierwszego poziomu gry
	call DISPBLOCKS
	
	ld b, 11
	ld c, 10
	call PUSHSEG
	
	call DISPSNAKE
_here:	jp _here
	ret
	
; PROCEDURA ŁADUJĄCA POZIOM, KTÓREGO NUMER ZNAJDUJE SIĘ W CURLEVELNR		
LOADLEVEL:	ld hl, curlevelnr	; Wczytanie do rejestru b numeru poziomu, który chcemy załadować
	ld b, (hl)
	ld de, levellen	; Wczytanie do rejestru de długości poziomu w bajtach
	ld hl, levels		; Wczytanie do rejestru hl adresu tablicy poziomów
	ld a, 0		
_addlvl:	cp b		; Dodanie do rejestru hl długości poziomu tyle razy, który poziom chcemy załadować
	jr z, _lvlcopy
	inc a
	add hl, de
	jp _addlvl
_lvlcopy:	ld de, currentlvl	; Gdy znamy adres poziomu który chcemy załadować, to go kopiujemy w miejsce aktualnego poziomu
	ld bc, levellen
	ldir
	ret
	
; PROCEDURA WYŚWIETLAJĄCA WSZYSTKIE ŚCIANY 
DISPBLOCKS:	ld hl, blocks
	ld b, 88
_bytejp:	ld c, b
	ld b, 8
_bitjp:	rlc (hl)
	jr nc, _setsp
_setbl	ld de, block		; Ustawienie znaku 144 na grafikę bloku
	ld (23675), de		
	jp _dispbl
_setsp:	ld de, freespace	; Ustawienie znaku 144 na grafikę wolnej przestrzeni
	ld (23675), de		; Ustawienie aktualnie drukowanej grafiki na pustą przestrzeń
_dispbl:	ld a, 144		; Ustawienie znaku 144 jako drukowanego
	rst 16		; Wydrukowanie znaku
	djnz _bitjp		; Pętla iterująca po bitach
	ld b, c
	inc hl
	djnz _bytejp		; Pętla iterująca po bajtach
	ret
	
; PROCEDURA PRZECHODZĄCA DO MIEJSCA NA EKRANIE WYZNACZONEGO PRZEZ REJESTRY X=B Y=C
GOTOXY:	ld a, 22		; Wysłanie sekwencji ucieczki oznaczającej zmiane pozycji
	rst 16
	ld a, c		; Wysłanie współrzędnej Y
	rst 16
	ld a, b		; Wysłanie współrzędnej X
	rst 16
	ret
	
; PROCEDURA WYŚWIETLAJĄCA WĘŻA
DISPSNAKE:	call DISPHEAD
	call DISPBODY
	call DISPTAIL
	ret

	
; PROCEDURA WYŚWIETLAJĄCA GŁOWĘ WĘŻA
DISPHEAD:	ld a, (snake)		; Porównanie współrzędnych x pierwszego i drugiego segmentu
	ld hl, snake+2
	cp (hl)
	jr nz, _xdiffer
	ld a, (snake+1)	; Porównanie współrzędnych y pierwszego i drugiego segmentu
	ld hl, snake+3
	cp (hl)
	jr nz, _ydiffer
_xdiffer:	jr nc, _hxgreater	; Czy w lewo, czy w prawo
	ld hl, head_l		; W lewo
	jp _disphead
_hxgreater:	ld hl, head_r		; W prawo
	jp _disphead
_ydiffer:	jr nc, _hygreater	; Czy w górę, czy w dół
	ld hl, head_u		; W góre
	jp _disphead
_hygreater:	ld hl, head_d		; W dół
	jp _disphead
_disphead:	ld (23675), hl		
	ld hl, snake		; Przejście w odpowiednie współrzędne
	ld b, (hl)
	inc hl
	ld c, (hl)
	call GOTOXY
	ld a, 144		; Wyświetlenie grafiki głowy
	rst 16
	ret
	
; PROCEDURA WYŚWIETLAJĄCA OGON WĘŻA
DISPTAIL:
	ld hl, snakelen	; Odnalezienie fragmentu odpowiadającego za ogon
	ld d, 0
	ld e, (hl)
	dec de
	ld hl, snake
	adc hl, de
	adc hl, de
	
	dec hl		; Sprawdzenie czy róźni się od poprzedniego fragmentu na x czy y
	dec hl
	ld a, (hl)
	inc hl
	inc hl
	cp (hl)
	jr nz, _tailxdiff
	jp _tailydiff

	
_tailxdiff:	jr nc, _tailxgreat	; Fragmenty różnią się na x(ogon do góry albo do dołu)
	ld de, tail_l
	jp _disptail
_tailxgreat:	ld de, tail_r		
	jp _disptail
_tailydiff:	jr nc, _tailygreat	; Fragmenty różnią się na y(ogon w lewo albo w prawo)
	ld de, tail_d
	jp _disptail
_tailygreat:	ld de, tail_u
	jp _disptail
	
_disptail:	ld (23675), de		; Załadowanie adresu grafiki do zmiennej systemowej UDG
	ld b, (hl)		; Przejście w odpowiednie współrzędne
	inc hl
	ld c, (hl)
	call GOTOXY
	ld a, 144		; Wyświetlenie grafiki ogona
	rst 16
	ret
	
; PROCEDURA WYŚWIETLAJĄCA CIAŁO WĘŻA
DISPBODY:	ld hl, snakelen	; Zapisanie do rejestru b ile fragmentów trzeba wyświetlić
	ld b, (hl)
	dec b
	dec b
	ld hl, snake+2		; Zapisanie do rejestru hl adresu pierwszego rozwarzanego fragmentu
_bodyloop:	ld a, b		; Zakończenie procedury jeśli wszystkie fragmenty zostały wyświetlone
	cp 0
	ret z
	ld c, 0		; Zerowanie rejestru c przez zapisywaniem do niego flag n i z
	ld a, (hl)		; Porównanie współrzędnych x aktualnego i wcześniejszego fragmentu
	dec hl 
	dec hl
	cp (hl)
	rl c
	sla c
	cp (hl)
	jr nz, _bodyjp1
	inc c
_bodyjp1:	inc hl
	inc hl
	inc hl		; Porównanie współrzędnych y aktualnego i wcześniejszego fragmentu
	ld a, (hl)
	dec hl 
	dec hl
	cp (hl)
	rl c
	sla c
	cp (hl)
	jr nz, _bodyjp2
	inc c
_bodyjp2:	inc hl
	ld a, (hl)		; Porównanie współrzędnych x aktualnego i następnego fragmentu
	inc hl 
	inc hl
	cp (hl)
	rl c
	sla c
	cp (hl)
	jr nz, _bodyjp3
	inc c
_bodyjp3:	dec hl
	dec hl
	inc hl		; Porównanie współrzędnych y aktualnego i następnego fragmentu
	ld a, (hl)
	inc hl 
	inc hl
	cp (hl)
	rl c
	sla c
	cp (hl)
	jr nz, _bodyjp4
	inc c
_bodyjp4:	dec hl
	dec hl
	dec hl
	
	ld a, c		; Zapisanie do a rejestru c w celu porównań
	
	cp %01000110		; Pionowy fragment
	jp z, _str_v_jp	
	cp %01100100
	jp z, _str_v_jp
	cp %10010001		; Poziomy fragment
	jp z, _str_h_jp	
	cp %00011001
	jp z, _str_h_jp
	cp %01001001		; Zakręt ur
	jp z, _turn_ur_jp
	cp %10010100		
	jp z, _turn_ur_jp
	cp %00010100		; Zakręt ul
	jp z, _turn_ul_jp
	cp %01000001		
	jp z, _turn_ul_jp
	cp %01100001		; Zakręt dl
	jp z, _turn_dl_jp
	cp %00010110	
	jp z, _turn_dl_jp
	cp %10010110		; Zakręt dr
	jp z, _turn_dr_jp
	cp %01101001	
	jp z, _turn_dr_jp
	
_turn_dl_jp:	ld de, turn_dl		; Załadowanie do de adresu odpowiedniej grafiki
	jp _dispbody
_turn_ul_jp:	ld de, turn_ul
	jp _dispbody
_turn_ur_jp:	ld de, turn_ur
	jp _dispbody
_turn_dr_jp:	ld de, turn_dr
	jp _dispbody
_str_h_jp:	ld de, str_h
	jp _dispbody
_str_v_jp:	ld de, str_v
	jp _dispbody
	
_dispbody:	ld (23675), de		; Zapisanie adresu grafiki do zmiennej systemowej UDG
	ld e, b		; Tymczasowe przeniesienie licznika iteracji do e, bo potrzebujemy b
	ld b, (hl)		; Zapisanie do b i c współrzędnych rysowania
	inc hl
	ld c, (hl)
	dec hl
	call GOTOXY		; Przejście do współrzędnych x, y
	ld a, 144		; Wydrukowanie grafiki
	rst 16
	ld b, e		; Przeniesienie licznika iteracji na prawidłowe miejsce
	inc hl		; Zwiększenie wskaźńika by wskazywał na następny fragment
	inc hl
	dec b		; Zmniejszenie licznika iteracji
	jp _bodyloop		; Pętla, aby instrukcje powtórzyły się dla każdego fragmentu
	

; PROCEGURA DODAJĄCA NOWY SEGMENT DO WĘŻA O WSPÓŁRZĘDNYCH X=B Y=C
PUSHSEG:	push bc		; Obłożenie na stos, bo potrzebujemy bc do instrukcji lddr

	ld a, (snakelen)	; Obliczenie długości kopiowanych danych
	sla a
	ld b, 0
	ld c, a

	ld hl, snakelen	; Obliczenie adresu źródłowego
	ld d, 0
	ld e, (hl)
	ld hl, snake
	adc hl, de
	adc hl, de
	dec hl
	
	ld d, h		; Obliczenie adresu docelowego
	ld e, l
	inc de
	inc de
	
	lddr		; Kopiowanie
	
	pop bc		; Obzyskanie odłorzonych wcześniej współrzędnych x, y
	
	ld hl, snake		; Wpisanie współrzędnych x, y w pierwszy segment
	ld (hl), b
	inc hl
	ld (hl), c
	
	ld hl, snakelen	; Zwiększenie długości węża o jeden
	inc (hl)
	ret
	
	
	
	
	
	
	
	
	
	
	
	
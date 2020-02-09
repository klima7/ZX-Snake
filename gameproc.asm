
; PROCEDURA ROZPOCZYNAJACA GRE DANEGO POZIOMU
STARTLEVEL:	call LEVELSCREEN
	call INITSNAKE

	call RANDMEAL
	call RANDCREATDIR
	call RANDCREATPOS
	call RANDEXIT

	call DISPBLOCKS
	call DISPSCORE
	call DISPMEAL
	call DISPCREAT
	
_mainloop:	call UPDATEDIR
	call MOVE	
	call CHECKRESULT
	call UPDATECREAT
	call CHECKEATMEAL
	call CHECKEATCREAT
	call DISPSNAKE
	call BEEP1
	
	ld a, (pause_time)	; Zatrzymanie na chwile gry
	ld b, a
_pause:	halt
	djnz _pause
	
	jp _mainloop
	ret	
	
BEEP1:	push hl
	push de
	ld hl,497
	ld de,10
	call 949
	pop de
	pop hl
	ret
	
BEEP2:	push hl
	push de
	ld hl,700
	ld de,10
	call 949
	pop de
	pop hl
	ret
	
; TWORZY POCZĄTKOWE SEGMENTY WĘŻA I INICJUJE DŁUGOŚĆ
INITSNAKE:	ld a, (snakelen)	; growlen += len - 2
	dec a
	dec a
	ld b, a
	ld a, (growlen)
	add a, b
	ld (growlen), a	
	
	ld a, (inposx)		; Załadowanie do bc współrzędnych wejścia
	ld b, a	
	ld a, (inposy)
	ld c, a
	
	call PUSHSEG		; Dodanie segmentu ogona
	
	ld a, (indir)		; Załadowanie do a kierunku wejścia
	
	cp 0
	jr z, _ismoved
	cp 1
	jr z, _ismovel
	cp 2
	jr z, _ismoveu
	cp 3
	jr z, _ismover
	
_ismovel:	dec b
	jp _afterdir
_ismover:	inc b
	jp _afterdir
_ismoveu:	dec c
	jp _afterdir
_ismoved:	inc c
	jp _afterdir
	
_afterdir:	call PUSHSEG		; Dodanie segmentu głowy
		
	ld a, (indir)		; Ustalenie kierunku poruszania
	ld (curdir), a		
	ld hl, 23560
	ld (hl), 0
	
	ld a, 2		; snakelen = 2
	ld (snakelen), a
	
	ret
	
LEVELSCREEN:	call 3503		; Czyszczenie ekranu
	
	ld b, 12		; Przejście na odpowiednie współzędne
	ld c, 10
	call GOTOXY
	
	ld de, level_str	; Wyświetlenie napisu "level"
	ld bc, 6
	call 8252
	
	ld a, (curlevelnr)	; Wyświetlenie numeru poziomu
	inc a
	ld c, a
	ld b, 0
	call 6683
	
	ld d, 0
	
_lcsnakeloop:	call BEEP2
	ld b, d		; Przejście na odpowiednie współzędne
	ld c, 12
	call GOTOXY
	
	ld hl, str_h		; Ustawienie grafiki na ciało węża	
	ld (23675), hl
	
	ld a, 144		; Wyświetlenie ciała węża
	rst 16
	
	ld hl, head_r		; Ustawienie grafiki na głowę	
	ld (23675), hl
	
	ld a, 144		; Wyświetlenie głowy
	rst 16
	
	ld b, 3		; Pauza
_lcpause:	halt
	djnz _lcpause
	
	inc d		; Obsługa pętli
	ld a, d
	cp 30
	jr c, _lcsnakeloop
	
	ret
	
	
; PROCEDURA ŁADUJĄCA KOLEJNY POZIOM
NEXTLEVEL:	ld hl, curlevelnr	; Zwiększenie aktualnego poziomu o 1
	inc (hl)
	
	ld a, (hl)		; Jeżeli to był ostatni poziom to ustaw poziom na 0
	cp levels_count
	jp nz, _nlload
	ld (hl), 0
	ld hl, pause_time
	dec (hl)
	
	
	
_nlload:	call LOADLEVEL
	jp STARTLEVEL
	
; PROCEDURA SPRAWDZAJĄCA CZY GRACZ MA WYSTARCZAJĄCY WYNIK DO OTWARCIA WYJŚCIA
CHECKRESULT:	ld a, (score)		; Porównanie starszych bajtów wyników
	ld hl, reqscore
	cp (hl)
	ret c		
	jp nz, _atexit
	
	ld a, (score+1)	; Porównanie młodszych bajtów wyników
	ld hl, reqscore+1
	cp (hl)
	ret c		
	
_atexit:	call DISPEXIT		; Wyświetlenie wyjścia i sprawdzenie czy nie ma tam gracza
	call CHECKEXIT
	ret
	
; PROCEDURA WYŚWIETLA WYJŚCIE Z POZIOMU 
DISPEXIT:	ld a, (outposx)	; Wczytanie współrzędnych wyjścia
	ld b, a
	ld a, (outposy)
	ld c, a
	
	call GOTOXY		; Przejście na odpowiednią pozycje
	
	ld hl, stairs_u	; Ustawienie grafiki wyjścia
	ld (23675), hl
	
	ld a, 144		; Narysowanie wyjścia
	rst 16
	ret
	
; PROCEDURA LOSUJĄCA WSPÓŁRZĘDNE WYJŚCIA
RANDEXIT:	call RANDFREEPOS
	ld hl, outposx
	ld (hl), b
	ld hl, outposy
	ld (hl), c
	ret
	
; PROCEDURA SPRAWDZAJĄCA, CZY GRACZ NIE WSZEDŁ DO WYJŚCIA
CHECKEXIT:	ld a, (snake)		; Porównanie współrzędnej x
	ld hl, outposx
	cp (hl)
	ret nz
	
	ld a, (snake+1)	; Porównanie współrzędnej y
	ld hl, outposy
	cp (hl)
	ret nz
	
	; Następny poziom
	call NEXTLEVEL
	ret
	
; PROCEDURA SPRAWDZAJĄCA CZY NA WSPÓŁRZĘDNYCH X=A Y=B ZNAJDUJE SIĘ WYJŚCIE
CHECKATEXIT:	ld a, (outposx)	; Porównanie współrzędnych x
	cp b
	jp nz, _cefalse
	
	ld a, (outposy)	; Porównanie współrzędnych y
	cp c
	jp nz, _cefalse
	
	scf		; Ustawienie flagi carry gdy wsółrzędne się zgadzają
	ret
	
_cefalse:	scf
	ccf
	ret
	
; PROCEDURA LOSUJE KIERUNEK PORUSZAJĄCEGO SIĘ STWORZENIA
RANDCREATDIR:	call RANDOM
	and %00000011
	ld (creatdir), a
	ret
	
; PROCEDURA LOSUJE WSPÓŁRZĘDNE PORUSZAJĄCEGO SIĘ STWORZENIA
RANDCREATPOS:	call RANDFREEPOS
	ld hl, creatx
	ld (hl), b
	ld hl, creaty
	ld (hl), c
	call DISPCREAT
	ret
	
; PROCEDURA WYŚWIETLA PORUSZAJĄCE SIĘ STWORZENIE
DISPCREAT:	ld a, (creatdir)	; Załadowanie kierunku do a w celu porównań

	cp 0		; Wybranie odpowiedniej grafiki w zaleźności od kierunku
	jp z, _setdird
	cp 1
	jp z, _setdirl
	cp 2
	jp z, _setdiru
	cp 3
	jp z, _setdirr
	ret
	
_setdird:	ld hl, creatd		; Ładowanie do hl adresu odpowiedniej grafiki
	jp _disp
_setdirl:	ld hl, creatl
	jp _disp
_setdiru:	ld hl, creatu
	jp _disp
_setdirr:	ld hl, creatr
	jp _disp

_disp:	ld (23675), hl		; Załadowanie wybranego UDG
	
	ld a, (creatx)		; Przejście na odpowiednie współrzędne
	ld b, a
	ld a, (creaty)
	ld c, a	
	call GOTOXY

	ld a, 144		; Wyświetlenie grafiki
	rst 16
	
	ret
	
UPDATECREAT:	ld a, (creatx)		; Wczytanie do BC współrzędnych stworzenia
	ld b, a
	ld a, (creaty)
	ld c, a
	
	call GOTOXY		; Przejście do tych współrzędnych
	
	ld hl, freespace	; Załadowanie do UDG grafiki pustej przestrzeni
	ld (23675), hl		
	
	ld a, 144		; Wyświetlenie grafiki pustej przestrzeni
	rst 16
	
	push bc		; Zachowanie starej pozycji bo może się przydać
	
	ld a, (creatdir)	; Wczytanie kierunku do a w celu porównań
	
	cp 0		
	jr z, _movecreatd
	cp 1
	jr z, _movecreatl
	cp 2
	jr z, _movecreatu
	cp 3
	jr z, _movecreatr
	
_movecreatl:	dec b		; W lewo
	ld a, b
	cp 255
	jr nz, _creatmayhit 
	jp _creathit

_movecreatr:	inc b		; W Prawo
	ld a, b
	cp 32
	jr nz, _creatmayhit
	jp _creathit
	
_movecreatu:	dec c		; W góre
	ld a, c
	cp 255
	jr nz, _creatmayhit
	jp _creathit
	
_movecreatd:	inc c		; W dół
	ld a, c
	cp 22
	jr nz, _creatmayhit
	jp _creathit
	
_creatmayhit:	call CHECKSTH		; Sprawdzenie czy stworzenie w coś nie uderzyło
	jr c, _creathit
	jp _creatnothit
	
_creatnothit:	pop de
	jp _creatdraw
	
_creathit:	call RANDCREATDIR
	pop bc
	jp _creatdraw		; Gdy stworzenie w coś uderzyło


_creatdraw:	ld a, b		; Gdy stworzenie w nic nie uderzyło
	ld (creatx), a		; Zapisz nowe współrzędne stworzenia
	ld a, c
	ld (creaty), a
	call DISPCREAT
	ret
	
	
	
; FUNKCJA ZWIĘKSZA WYNIK O ZAWARTOŚĆ REJESTRU B
INCSCORE:	ld a, (score)
	ld h, a
	ld a, (score+1)
	ld l, a
	
	ld d, 0
	ld e, b
	
	add hl, de
	
	ld a, h
	ld (score), a
	ld a, l
	ld (score+1), a
	
	
	call DISPSCORE
	ret
	
; FUNKCJA USTALA DLA JEDZENIA LOSOWE WSPÓŁRZĘDNE
RANDMEAL:	call RANDFREEPOS
	ld hl, mealx
	ld (hl), b
	ld hl, mealy
	ld (hl), c
	call DISPMEAL
	ret
	
; FUNKCJA WYŚWIETLA JEDZENIE DLA WĘŻA
DISPMEAL:	ld hl, meal		; Ustawienie aktualnej grafiki na jedzenie
	ld (23675), hl	
	
	ld a, (mealx)		; Wczytanie do bc współrzędnych jedzenia
	ld b, a
	ld a, (mealy)
	ld c, a
	
	call GOTOXY		; Przejście na współrzędne jedzenia
	
	ld a, 144		; Wydrukowanie jedzenia
	rst 16
	ret
	
; FUNKCJA LOSUJE POZYCJE NA EKRANIE I ZAPISUJE WSPÓŁRZĘDNE DO BC: B=X Y=C
RANDOMPOS:	call RANDOM		; Wylosowanie współrzędnej x
	and %00011111
	ld b, a
	
	call RANDOM		; Wylosowanie pierwszego składnika współrzędnej y
	and %00000111
	ld d, a
	
	call RANDOM		; Wylosowanie drugiego składnika współrzędnej y
	and %00000111
	add a, d	
	ld d, a
	
	call RANDOM		; Wylosowanie trzeciego składnika współrzędnej y
	and %00000111
	add a, d	
	
	ld c, a
	ret
	
; FUNKCJA LOSUJE POZYCJE NA KTÓREJ NIC SIĘ NIE ZNAJDUJE I ZWRACA WYNIK W BC
RANDFREEPOS:	call RANDOMPOS
	call CHECKSTH
	jr c, RANDFREEPOS
	ret

; PROCEDURA ZAPISUJE W A LICZBĘ PSEUDOLOSOWĄ PRZEZ ODCZYTANIE KOLEJNEGO BAJTA Z ROM(JEDYNA PROCEDURA NIE NAPISANA PRZEZE MNIE)	
RANDOM: 	ld hl,(_seed)       ; Wskaźnik w pamięć rom
	ld a,h
	and 31              ; Zabespieczenie przed wyjściem z pamięci rom
	ld h,a
	ld a,(hl)           ; Pobranie liczby pseudo-losowej
	inc hl              ; Zwiększenie wskaźnika
	ld (_seed),hl
	ret
_seed:   	defw 0
	
; FUNKCJA SPRAWDZA CZY NA POZYCJI X=B Y=C ZNAJDUJE SIĘ COKOLWIEK
CHECKSTH:	call CHECKWALL		; Sprawdzenie czy na pozycji nie ma ściany
	ret c
	
	call CHECKMEAL		; Sprawdzenie czy na pozycji nie ma jedzenia
	ret c
	
	call CHECKCREAT	; Sprawdzenie czy na pozycji nie ma stworzenia
	ret c
	
	call CHECKATEXIT	; Sprawdzenie czy na pozycji nie ma wyjścia
	ret c
	
	call CHECKSNAKE	; Sprawdzenie czy na pozycji nie ma węża
	ret
	
; SPRAWDZENIE CZY W MIEJSCU X=B Y=C ZNAJDUJE SIE ELEMENT Z KTORYM WĄŻ MOŻE SIĘ ZDERZYĆ
CHECKSNAKEHIT:	ld a, (snake)		; Pobranie współrzędnych głowy do bc
	ld b, a
	ld a, (snake+1)
	ld c, a

	call CHECKWALL		; Sprawdzenie czy wąż nie zdeżył się ze ścianą
	jp c, GAMEOVER
	
	call CHECKSNAKE	; Sprawdzenie czy wąż nie zdeżył się ze ścianą
	jp c, GAMEOVER
	
	ret
	
; PROCEDURA SPRAWDZAJACA CZY WĄŻ NIE ZJADŁ JEDZENIA
CHECKEATMEAL:	ld a, (snake)		; Porównanie współrzędnych x
	ld hl, mealx
	cp (hl)
	jr nz, _cmret
	
	ld a, (snake+1)	; Porównanie współrzędnych y
	ld hl, mealy
	cp (hl)
	jr nz, _cmret
	
	call RANDMEAL		; Instrukcje wykonywane gdy wąż zjadł jedzenie
	ld b, meal_score
	call INCSCORE
	call BEEP2
	
	ld hl, growlen		; Zwiększenie długości węża o 1
	inc (hl)
	
_cmret:	ret

; PROCEDURA SPRAWDZAJACA CZY WĄŻ NIE ZJADŁ STWORZENIA
CHECKEATCREAT:	ld a, (snake)		; Pobranie współrzędnych głowy
	ld b, a
	ld a, (snake+1)
	ld c, a
	
	call CHECKCREAT	; Sprawdzenie czy na tych współrzędnych jest stworzenie
	ret nc		; Jeśli nie to wróć
	
	ld b, creat_score	; Zwiększenie wyniku
	call INCSCORE
	call RANDCREATDIR	; Wylosowanie nowego położenia i kierunku stworzenia
	call RANDCREATPOS
	call BEEP2
	ret
	
; PROCEDURA SPRAWDZAJĄCA W MIEJSCU X=B Y=C ZNAJDUJE SIĘ ŚCIANA, ZWRACA WYNIK W POSTACI FLAGI CARRY
CHECKWALL:	ld hl, blocks
	push bc

	ld de, 4		; Przejście do odpowiedniego wiersza
	ld a, c
_cwrowloop:	cp 0
	jr z, _cwcalcbyte
	adc hl, de
	dec a
	jp _cwrowloop
	
_cwcalcbyte:	ld a, b		; Przejście do odpowiedniego bajta
_cwbyteloop:	cp 8
	jr c, _cwcalcbit
	inc hl
	sub 8
	jp _cwbyteloop

_cwcalcbit:	ld c, (hl)		; Przejście do odpowiedniego bita
_cwbitloop	cp 0
	jr z, _cwbitcalced
	sla c
	dec a
	jp _cwbitloop
	
_cwbitcalced:	sla c
	pop bc
	ret
	
; PROCEDURA SPRAWDZAJĄCA W MIEJSCU X=B Y=C ZNAJDUJE SIĘ ELEMENT WĘŻA, ZWRACA WYNIK W POSTACI FLAGI CARRY
CHECKSNAKE:	push bc		; Zachowanie rejestru bc

	ld d, b		; Przemieszczenie współzędnych by ich nie stracić
	ld e, c
	
	ld hl, snake		; Ustawienie wskaźńika na początek obszaru z fragmentami węża
	inc hl
	inc hl
	
	ld a, (snakelen)	; Pobranie liczby segmentów do sprawdzenia
	dec a
	ld b, a
	
_cssegloop:	ld a, (hl)		; Porównanie współrzędnych x
	cp d
	jp nz, _csinc2
	
	inc hl		; Porównanie współrzędnych y
	ld a, (hl)
	cp e
	jp nz, _csinc1
	
	pop bc		; Znaleziono fragment - ustawienie flagi carry
	scf		
	ret
	
_csinc2:	inc hl
_csinc1:	inc hl
	djnz _cssegloop	; Sprawdzanie kolejnego fragmentu węża

	pop bc		; Nie znaleziono fragmentu węża - wyzeruj flagę carry
	scf		
	ccf
	ret
	
; FUNKCJA SPRAWDZA CZY JEDZENIE ZNAJDUJE SIE NA WSPÓŁRZEDNYCH X=B Y=C I SYGNALIZUJE WYNIK FLAGĄ ZERO
CHECKMEAL:	ld a, (mealx)		; Porównanie współrzędnych x
	cp b
	jp nz, _chmealfalse
	
	ld a, (mealy)		; Porównanie współrzędnych y
	cp c
	jp nz, _chmealfalse
	
	scf		; Ustawienie flagi carry gdy wsółrzędne się zgadzają
	ret
	
_chmealfalse:	scf
	ccf
	ret
	
	

; FUNKCJA SPRAWDZA CZY SWTORZENIE ZNAJDUJE SIE NA WSPÓŁRZEDNYCH X=B Y=C I SYGNALIZUJE WYNIK FLAGĄ ZERO
CHECKCREAT:	ld a, (creatx)		; Porównanie współrzędnych x
	cp b
	jp nz, _chcreatfalse
	
	ld a, (creaty)		; Porównanie współrzędnych y
	cp c
	jp nz, _chcreatfalse
	
	scf		; Ustawienie flagi carry gdy wsółrzędne się zgadzają
	ret
	
_chcreatfalse:	scf
	ccf
	ret

; PROCEDURA USTAWIA WSZYSTKIE ZMIENNEJ PO PRZEGRANEJ
RESETGAME:	ld hl, snakelen	; snakelen=0
	ld (hl), 2
	
	ld hl, growlen		; growlen=0	
	ld (hl), 0
	
	ld hl, score		; score=0
	ld (hl), 0
	inc hl
	ld (hl), 0
	
	ld hl, reqscore	; reqscore=0
	ld (hl), 0
	inc hl
	ld (hl), 0
	
	ld hl, curlevelnr	; curlevelnr=0
	ld (hl), 4
	
	ret

; PROCEDURA WYŚWIETLAJĄCA EKRAN PRZED ROZPOCZĘCIEM GRY	
MENU:	call 3503		; Czyszczenie ekranu

	ld a, 2		; Wybranie drugieko kanału do otwarcia
	call 5633		; Wywołanie procedury otwierającej kanał

	ld hl, 23560		; Zresetowanie ostatnio wciskanego przycisku
	ld (hl), 0

	ld a, 1		; Ustaw kanał na 1
	call 5633
	
	ld de, press_str	; Wyświetl "press any key"
	ld bc, 27
	call 8252
	
	ld a, 2		; Ustaw kanał na 2
	call 5633

	ld b, 11		; Przejdz na współrzędne napisu "Game over"
	ld c, 9
	call GOTOXY
	
	ld de, snake_str	; Wyświetl "ZX snake"
	ld bc, 10
	call 8252
	
	ld b, 6		; Przejdz na współrzędne napisu "Author"
	ld c, 0
	call GOTOXY
	ld de, author_str	; Wyświetl "Author"
	ld bc, 21
	call 8252
	
	ld b, 0		; Przejdz na współrzędne węża
	ld c, 8
	call GOTOXY
	
	ld de, str_h		; Ustaw grafikę na ciało węża
	ld (23675), de
	
	ld b, 24		; Rysuj ciało węża
_snakemenu1:	ld a, 144
	rst 16
	djnz _snakemenu1
	
	ld de, head_r		; Ustaw grafikę na głowę węża
	ld (23675), de
	
	ld a, 144		; Rysuj głowę węża
	rst 16
	
	ld b, 8		; Przejdz na współrzędne drugiego węża
	ld c, 10
	call GOTOXY
	
	ld de, head_l		; Ustaw grafikę na głowę węża
	ld (23675), de
	
	ld a, 144		; Rysuj głowę węża
	rst 16
	
	ld de, str_h		; Ustaw grafikę na ciało węża
	ld (23675), de
	
	ld b, 23		; Rysuj ciało węża
_snakemenu2:	ld a, 144
	rst 16
	djnz _snakemenu2
	
	ld h, 11
	ld l, 1
	
_textanimloop:	ld a, l
	cp 1
	jr z, _textright	; Czy przesówać tekst w lewo czy prawo?
	
	dec h		; Przesówanie tekstu w lewo
	ld a, h
	cp 0
	jp nz, _disptext
	ld l, 1
	call BEEP1
	jp _disptext
	
_textright:	inc h		; Przesówanie tekstu w prawo
	ld a, h
	cp 26
	jp nz, _disptext
	ld l, 0
	call BEEP1
	jp _disptext

_disptext:	ld b, h		; Przejdz do współrzędnych gdzie trzeba wyświetlić napis
	ld c, 13
	call GOTOXY

	ld de, s_str
	ld bc, 6
	call 8252

	ld b, 5
_animpause:	halt
	djnz _animpause
	
	ld a, (23560)		; Sprawdz czy nie wciśnięto przycisku
	cp 0
	jp nz, _quitmenu
	
	jp _textanimloop
	
_quitmenu:	call 3503		; Czyszczenie ekranu
	call RESETGAME
	call LOADLEVEL		; Załadowanie pierwszego poziomu gry
	call STARTLEVEL	; Uruchomienie pierwszego poziomu
	ret
		
; PROCEDURA ZATRZYMUJE PROGRAM DO WCIŚNIĘCIA DOWOLNEGO PRZYCISKU
PRESSANYKEY:	ld hl, 23560		
	ld (hl), 0
_checkpres:	ld a, (23560)
	cp 0
	ret nz
	jp _checkpres
	
; Procedura wyświetlająca widok koniec gry
GAMEOVER:	call 3503		; Czyszczenie ekranu

	ld b, 11		; Przejdz na współrzędne napisu "Game over"
	ld c, 10
	call GOTOXY
	
	ld de, gameover_str	; Wyświetl "Game over"
	ld bc, 9
	call 8252
	
	ld b, 11		; Przejdz na współrzędne napisu "Score"
	ld c, 12
	call GOTOXY
	
	ld de, score_str	; Wyświetl napis score
	ld bc, 6
	call 8252
	
	ld a, (score)		; Wyświetl wynik
	ld b, a
	ld a, (score+1)
	ld c, a
	call 6683
	
	ld b, 20
_mpause:	halt
	djnz _mpause
	
	ld hl,397
	ld de,500
	call 949
	
	ld hl,497
	ld de,500
	call 949
	
	ld hl,597
	ld de,500
	call 949
	
	call PRESSANYKEY
	jp MENU
	ret
	
DISPSCORE:	ld a, 1		; Wybierz pierwszy kanał
	call 5633
	
	ld b, 0		; Przejście na odpowiednią pozycję
	ld c, 1
	call GOTOXY
	
	ld de, score_str;	; Wyświetl napis "Score: "
	ld bc, 6
	call 8252
	
	ld a, (score)
	ld b, a
	ld a, (score+1)
	ld c, a
	call 6683
	
	ld b, 10		; Przejście na odpowiednią pozycję
	ld c, 1
	call GOTOXY
	
	ld de, tounlock_str;	; Wyświetl napis "To unlock:"
	ld bc, 7
	call 8252
	
	ld a, (reqscore)
	ld b, a
	ld a, (reqscore+1)
	ld c, a
	call 6683
	
	ld b, 24		; Przejście na odpowiednią pozycję
	ld c, 1
	call GOTOXY
	
	ld de, speed_str;	; Wyświetl napis "Score: "
	ld bc, 6
	call 8252
	
	ld a, (pause_time)
	ld b, a
	ld a, 11
	sub b
	
	ld c, a
	ld b, 0
	call 6683
	
	ld a, 2		; Ustaw spowrotem kanał 2
	call 5633
	
	ret
	
; FUNKCJA SPRAWDZA WCIŚNIĘTY PRZYCISK I EWENTUALNIE ZMIENIA KIERUNEK WĘŻA
UPDATEDIR:	ld hl, curdir
	ld b, (hl)
	ld a, (23560)
	cp 'w'
	jr z, _updateu
	cp 's'
	jr z, _updated
	cp 'a'
	jr z, _updatel
	cp 'd'
	jr z, _updater
	ret
	
_updateu:	ld a, 0		; Blokada przez zawracaniem zakrętem o 180
	cp b
	ret z
	ld (hl), 2		; Zmiana kierunku
	ret
	
_updated:	ld a, 2
	cp b
	ret z
	ld (hl), 0
	ret
	
_updatel:	ld a, 3
	cp b
	ret z
	ld (hl), 1
	ret
	
_updater:	ld a, 1
	cp b
	ret z
	ld (hl), 3
	ret
	

; PROCEDURA PRZEMIESZCZAJĄCA WĘŻA W KIERUNKU JEGO AKTUALNEGO RUCHU	
MOVE:	ld hl, snake
	ld b, (hl)
	inc hl
	ld c, (hl)

	ld hl, curdir
	ld a, (hl)
	
	cp 0
	jr z, _moved
	cp 1
	jr z, _movel
	cp 2
	jr z, _moveu
	cp 3
	jr z, _mover
	
_movel:	dec b
	ld a, b
	cp 255
	jr nz, _addseg 
	jp GAMEOVER

_mover:	inc b
	ld a, b
	cp 32
	jr nz, _addseg
	jp GAMEOVER
	
_moveu:	dec c
	ld a, c
	cp 255
	jr nz, _addseg
	jp GAMEOVER
	
_moved:	inc c
	ld a, c
	cp 22
	jr nz, _addseg
	jp GAMEOVER
	
_addseg:	call PUSHSEG		; Dodanie segmentu z przodu węża

	ld hl, growlen		; Sprawdzenie czy wąż rośnie i czy trzeba usówać ostatni segment
	ld a, (hl)
	cp 0
	jp z, _popseg
	
	dec (hl)		; Nie usówamy ostatniego segmentu
	jp _checkhit
	
_popseg:	call POPSEG		; Usówamy ostatni segment
	
_checkhit:	call CHECKSNAKEHIT	; Sprawdzenie czy wąż się z niczym nie zderzył
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
	
	ld a, (score)		; Pobranie wyniku do hl
	ld h, a
	ld a, (score+1)
	ld l, a
	
	ld d, 0		; Wczytanie score_increase do de
	ld e, score_increase
	
	add hl, de		; Dodanie
	
	ld a, h		; Zapisanie wyniku do reqscore
	ld (reqscore), a
	ld a, l
	ld (reqscore+1), a
	
	ret
	
; PROCEDURA WYŚWIETLAJĄCA WSZYSTKIE ŚCIANY 
DISPBLOCKS:	ld b, 0		; Przejście na początek ekranu
	ld c, 0
	call GOTOXY

	ld hl, blocks
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
	
	dec hl		; Sprawdzenie czy róźni się od poprzedniego fragmentu na x
	dec hl
	ld a, (hl)
	inc hl
	inc hl
	cp (hl)
	jr nz, _tailxdiff
	
	dec hl		; Sprawdzenie czy róźni się od poprzedniego fragmentu na x
	ld a, (hl)
	inc hl
	inc hl
	cp (hl)
	jr nz, _tailydiff
	
	
_tailxdiff:	jr nc, _tailxgreat	; Fragmenty różnią się na x(ogon do góry albo do dołu)
	ld de, tail_l
	jp _disptail
_tailxgreat:	ld de, tail_r		
	jp _disptail
_tailydiff:	jr nc, _tailygreat	; Fragmenty różnią się na y(ogon w lewo albo w prawo)
	ld de, tail_u
	dec hl
	jp _disptail
_tailygreat:	ld de, tail_d
	dec hl
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
	
	pop bc		; Odzyskanie odłorzonych wcześniej współrzędnych x, y
	
	ld hl, snake		; Wpisanie współrzędnych x, y w pierwszy segment
	ld (hl), b
	inc hl
	ld (hl), c
	
	ld hl, snakelen	; Zwiększenie długości węża o jeden
	inc (hl)
	ret

; PROCEDURA USÓWAJĄCA Z WĘŻA OSTATNI SEGMENT	
POPSEG:	ld hl, snakelen	; Odnalezienie fragmentu odpowiadającego za ogon
	ld d, 0
	ld e, (hl)
	dec de
	ld hl, snake
	adc hl, de
	adc hl, de
	
	ld b, (hl)
	inc hl
	ld c, (hl)
	call GOTOXY
	
	ld hl, freespace
	ld (23675), hl
	ld a, 144
	rst 16

	ld hl, snakelen
	dec (hl)
	ret
	
	
	
	
	
	
	
	
	
	
	
	
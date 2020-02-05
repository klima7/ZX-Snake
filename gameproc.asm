start:		; Instrukcje wywoływane przy ładowaniu gry
	ld a, 2	; Otworzenie górnego kanału
	call 5633

	call loadlvl
	call dispblocks
here	jp here
	ret
	
loadlvl	ld hl, curlevelnr	; Obliczenie adresu bazowego poziomu
	ld b, (hl)
	ld de, levellen
	ld hl, levels
	ld a, 0
addlvl	cp b
	jr z, lvlcopy
	inc a
	add hl, de
	jp addlvl

lvlcopy	ld de, currentlvl
	ld bc, levellen
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
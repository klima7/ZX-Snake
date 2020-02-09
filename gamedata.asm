			; Obowiązujące kierunki 0-dół 1-lewo 2-góra 3-prawo

snake	defb 20, 20, 21, 20, 10, 12, 9, 12, 8, 12, 8, 13	; Wektor z elementami węża postaci (x, y), (x, y)...
	defs 2*22*32-12	
snakelen	defb 6		; Aktualna długość węża
growlen	defb 0		; Długość o jaką ma urosnąć wąż

curdir	defb 3		; Aktualny kierunek węża
score	defb 0, 0		; Wynik wyświetlany na ekranie
reqscore	defb 0, 0
curlevelnr	defb 0		; Aktualny poziom
pause_time 	defb 10

creatx	defb 0		; Pozycja poruszającego się jedzenia
creaty	defb 0
creatdir	defb 0		; Kierunek poruszającego się jedzenia

mealx	defb 0		; Pozycja nieruchomego jedzenia
mealy	defb 0

skullx	defb 0
skully	defb 0

outposx	defb 0		; Współrzędne wyjścia z aktualnego poziomu
outposy	defb 0

currentlvl
creatd	defs 8		; Grafika dla poruszającego się w jedzenia w aktualnym poziomie
creatl	defs 8		
creatu	defs 8		
creatr	defs 8		
meal	defs 8		; Grafika dla jedzenia aktualnego poziomu
block	defs 8		; Grafika dla ściany aktualnego poziomu
freespace	defs 8		; Grafika dla wolnej przestrzeni aktualnego poziomu
blocks	defs 88		; Mapa z blokami aktualnego poziomu

inposx	defb 0		; Współrzędne wejścia na aktualny poziom
inposy	defb 0
indir	defb 0		; Początkowy kierunek po wejściu na aktualny poziom
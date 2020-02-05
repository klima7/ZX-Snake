; Obowiązujące kierunki
; 0 - w dół
; 1 - w lewo
; 2 - w góre
; 3 - w prawo

frg	defs 2*22*32	; Bufor cykliczny w którym umieszczane są fragmenty węża postaci (x, y)
frgstart	defb 0		; Początek buforu cyklicznego
frgend	defb 0		; Koniec buforu cyklinicznegu

curdir	defb 0	; Aktualny kierunek węża
newdir	defb 0	; Kierunek gdzie chce się ruszyć gracz
curlen	defb 0	; Aktualna długość węża
totallen	defb 0	; Całkowita długość węża
score	defs 0	; Wynik wyświetlany na ekranie
curlevelnr	defb 0	; Aktualny poziom

currentlvl
creatd	defs 8	; Grafika dla poruszającego się w dół jedzenia aktualnego poziomu
creatl	defs 8	; Grafika dla poruszającego się w lewo jedzenia aktualnego poziomu
creatu	defs 8	; Grafika dla poruszającego się w górę jedzenia aktualnego poziomu
creatr	defs 8	; Grafika dla poruszającego się w prawo jedzenia aktualnego poziomu
meal	defs 8	; Grafika dla nieruchomego jedzenia aktualnego poziomu
block	defs 8	; Grafika dla ściany aktualnego poziomu
freespace	defs 8	; Grafika dla wolnej przestrzeni aktualnego poziomu
blocks	defs 88	; Mapa z blokami aktualnego poziomu
inpos	defs 2	; Współrzędne wejścia na aktualny poziom
outpos	defs 2	; Współrzędne wyjścia z aktualnego poziomu
reqscore	defs 2	; Wymagany wynik by przejść z aktualnego na następny poziom
startdir	defs 1	; Początkowy kierunek po wejściu na aktualny poziom



; Pozycja poruszającego się jedzenia
creatx	defb 0
creaty	defb 0

; Kierunek poruszającego się jedzenia
creatvx	defb 0
creatvy	defb 0

; Pozycja nieruchomego jedzenia
mealx	defb 0
mealy	defb 0
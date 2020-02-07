levels	defb 16,16,16,56,56,56,56,16		; Grafika mysz dół
	defb 0,0,120,255,120,0,0,0		; Grafika mysz lewo
	defb 8,28,28,28,28,8,8,8		; Grafika mysz góra
	defb 0,0,0,30,255,30,0,0		; Grafika mysz prawo
	defb 2,3,28,60,60,56,192,64		; Grafika dla cukierka
	defb 255,255,255,255,255,255,255,255	; Grafika dla bloku
	defb 0,0,0,24,24,0,0,0		; Grafika dla wolnej przestrzeni
	defb 255, 255, 255, 255		; Mapa z blokami
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
	defb 10, 10			; Współrzędne wejścia x, y
	defb 20, 20			; Współrzędne wyjścia x, y
	defb 0, 10			; Wynik potrzebny do otwarcia wyjścia
	defb 0			; Kierunek w którym ma się poruszać wąż po pojawieniu się
	
levellen	equ $-levels			; Ile bajtów zajmuje każdy poziom

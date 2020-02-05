ORG 32768					; Umieszczenie kodu na początu przestrzeni nieużywanych danych
jp start					; Skok do procedury rozpoczynającej
ret					; Powrót do kodu po zakończeniu gry

INCLUDE C:\Users\ukasz\Desktop\ZXGame\gamedata.asm	; Dołączanie danych
INCLUDE C:\Users\ukasz\Desktop\ZXGame\gameproc.asm	; Dołączanie wszystkich procedur
INCLUDE C:\Users\ukasz\Desktop\ZXGame\commongraph.asm	; Dołączanie grafiki wspólnej dla wszystkich poziomów
INCLUDE C:\Users\ukasz\Desktop\ZXGame\levels.asm	; Dołączanie poziomów gry







	
	
       

str_h:	defb 0,255,187,255,238,255,255,0	; Grafiki dla prostego fragmentu węża
str_v	defb 126,122,126,110,126,122,126,110

turn_dl	defb 0,192,176,248,116,252,222,122		; Grafiki dla skręcającego fragmentu węża
turn_ul	defb 110,250,188,252,232,112,192,0
turn_ur	defb 94,123,63,46,31,13,3,0
turn_dr	defb 0,3,14,23,63,61,95,118

eat_d	defb 126,126,126,126,90,126,36,0	; Grafiki dla jedzącego węża
eat_l	defb 0,63,111,63,63,111,63,0
eat_u	defb 0,36,126,90,126,126,126,126
eat_r	defb 0,252,246,252,252,246,252,0

head_d	defb 126,126,126,126,90,126,60,24	; Grafiki głowy węża
head_l	defb 0,63,111,255,255,111,63,0
head_u	defb 24,60,126,90,126,126,126,126
head_r	defb 0,252,246,255,255,246,252,0

tail_d	defb 24,60,60,110,126,122,126,110	; Grafiki dla ogona węża
tail_l	defb 0,248,254,119,255,222,248,0
tail_u	defb 118,126,94,126,118,60,60,24
tail_r	defb 0,31,123,255,238,127,31,0

stairs_u	defb 3,3,15,11,49,59,251,255		; Grafika dla schodów
stairs_d	defb 192,192,240,208,220,140,223,255

score_str	defb "SCORE:"
gameover_str	defb "GAME OVER"
snake_str	defb "ZX SNAKE"
press_str	defb "     PRESS ANY KEY TO START"
s_str	defb " Ssss "
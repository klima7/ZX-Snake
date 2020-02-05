@echo off

echo ---------------------------Assembling-----------------------------
C:\Users\ukasz\Desktop\ZXGame\pasmo --bin -v C:\Users\ukasz\Desktop\ZXGame\code.asm C:\Users\ukasz\Desktop\ZXGame\code_binary.bin  
if errorlevel 1 (
   echo ----------------------ASSEMBLING-FAILED------------------------
   PAUSE
   exit 
)

echo ---------------------------Injecting------------------------------
C:\Users\ukasz\Desktop\ZXGame\SNA_mutator C:\Users\ukasz\Desktop\ZXGame\SNA_template.sna C:\Users\ukasz\Desktop\ZXGame\code_binary.bin C:\Users\ukasz\Desktop\ZXGame\ZXGame.sna
if errorlevel 1 (
   echo ---------------------INJECTING-FAILED--------------------------
   PAUSE
   exit 
)

echo ----------------------------Starting-----------------------------
C:\Users\ukasz\Desktop\ZXGame\ZXGame.sna
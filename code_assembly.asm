org 32768	
       ld a,2             
       call 5633          
loop   ld de,string       
       ld bc,14
       call 8252      
	   jp loop

string defb 'Lukasz is cool'

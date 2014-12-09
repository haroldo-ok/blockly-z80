;==============================================================
; Data
;==============================================================

PaletteData:
	db $00,$3F,$00,$10,$15,$04,$05,$06,$16,$08,$1A,$0C,$0F,$1F,$1F,$30
	db $00,$3F,$00,$10,$15,$04,$05,$06,$16,$08,$1A,$0C,$0F,$1F,$1F,$30
PaletteDataEnd:

; VDP initialisation data
VDPInitData:
	db $04,$80,$00,$81,$ff,$82,$ff,$85,$ff,$86,$ff,$87,$00,$88,$00,$89,$ff,$8a
VDPInitDataEnd:

; VDP initialisation data
VDPInitDataSG1000:
;	db $04,$80,$00,$81,$ff,$82,$ff,$85,$ff,$86,$ff,$87
	db $00,$80,$40,$81,$0F,$82,$00,$83,$01,$84,$01,$85,$04,$86,$08,$87;
VDPInitDataSG1000End:

FontData:
	db 00h,00h,00h,00h,00h,00h,00h,00h,18h,18h,18h,18h,18h,00h,18h,00h
	db 6ch,6ch,6ch,00h,00h,00h,00h,00h,36h,36h,7fh,36h,7fh,36h,36h,00h
	db 0ch,3fh,68h,3eh,0bh,7eh,18h,00h,60h,66h,0ch,18h,30h,66h,06h,00h
	db 38h,6ch,6ch,38h,6dh,66h,3bh,00h,0ch,18h,30h,00h,00h,00h,00h,00h
	db 0ch,18h,30h,30h,30h,18h,0ch,00h,30h,18h,0ch,0ch,0ch,18h,30h,00h
	db 00h,18h,7eh,3ch,7eh,18h,00h,00h,00h,18h,18h,7eh,18h,18h,00h,00h
	db 00h,00h,00h,00h,00h,18h,18h,30h,00h,00h,00h,7eh,00h,00h,00h,00h
	db 00h,00h,00h,00h,00h,18h,18h,00h,00h,06h,0ch,18h,30h,60h,00h,00h
	db 3ch,66h,6eh,7eh,76h,66h,3ch,00h,18h,38h,18h,18h,18h,18h,7eh,00h
	db 3ch,66h,06h,0ch,18h,30h,7eh,00h,3ch,66h,06h,1ch,06h,66h,3ch,00h
	db 0ch,1ch,3ch,6ch,7eh,0ch,0ch,00h,7eh,60h,7ch,06h,06h,66h,3ch,00h
	db 1ch,30h,60h,7ch,66h,66h,3ch,00h,7eh,06h,0ch,18h,30h,30h,30h,00h
	db 3ch,66h,66h,3ch,66h,66h,3ch,00h,3ch,66h,66h,3eh,06h,0ch,38h,00h
	db 00h,00h,18h,18h,00h,18h,18h,00h,00h,00h,18h,18h,00h,18h,18h,30h
	db 0ch,18h,30h,60h,30h,18h,0ch,00h,00h,00h,7eh,00h,7eh,00h,00h,00h
	db 30h,18h,0ch,06h,0ch,18h,30h,00h,3ch,66h,0ch,18h,18h,00h,18h,00h
	db 3ch,66h,6eh,6ah,6eh,60h,3ch,00h,3ch,66h,66h,7eh,66h,66h,66h,00h
	db 7ch,66h,66h,7ch,66h,66h,7ch,00h,3ch,66h,60h,60h,60h,66h,3ch,00h
	db 78h,6ch,66h,66h,66h,6ch,78h,00h,7eh,60h,60h,7ch,60h,60h,7eh,00h
	db 7eh,60h,60h,7ch,60h,60h,60h,00h,3ch,66h,60h,6eh,66h,66h,3ch,00h
	db 66h,66h,66h,7eh,66h,66h,66h,00h,7eh,18h,18h,18h,18h,18h,7eh,00h
	db 3eh,0ch,0ch,0ch,0ch,6ch,38h,00h,66h,6ch,78h,70h,78h,6ch,66h,00h
	db 60h,60h,60h,60h,60h,60h,7eh,00h,63h,77h,7fh,6bh,6bh,63h,63h,00h
	db 66h,66h,76h,7eh,6eh,66h,66h,00h,3ch,66h,66h,66h,66h,66h,3ch,00h
	db 7ch,66h,66h,7ch,60h,60h,60h,00h,3ch,66h,66h,66h,6ah,6ch,36h,00h
	db 7ch,66h,66h,7ch,6ch,66h,66h,00h,3ch,66h,60h,3ch,06h,66h,3ch,00h
	db 7eh,18h,18h,18h,18h,18h,18h,00h,66h,66h,66h,66h,66h,66h,3ch,00h
	db 66h,66h,66h,66h,66h,3ch,18h,00h,63h,63h,6bh,6bh,7fh,77h,63h,00h
	db 66h,66h,3ch,18h,3ch,66h,66h,00h,66h,66h,66h,3ch,18h,18h,18h,00h
	db 7eh,06h,0ch,18h,30h,60h,7eh,00h,7ch,60h,60h,60h,60h,60h,7ch,00h
	db 00h,60h,30h,18h,0ch,06h,00h,00h,3eh,06h,06h,06h,06h,06h,3eh,00h
	db 18h,3ch,66h,42h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,ffh
	db 1ch,36h,30h,7ch,30h,30h,7eh,00h,00h,00h,3ch,06h,3eh,66h,3eh,00h
	db 60h,60h,7ch,66h,66h,66h,7ch,00h,00h,00h,3ch,66h,60h,66h,3ch,00h
	db 06h,06h,3eh,66h,66h,66h,3eh,00h,00h,00h,3ch,66h,7eh,60h,3ch,00h
	db 1ch,30h,30h,7ch,30h,30h,30h,00h,00h,00h,3eh,66h,66h,3eh,06h,3ch
	db 60h,60h,7ch,66h,66h,66h,66h,00h,18h,00h,38h,18h,18h,18h,3ch,00h
	db 18h,00h,38h,18h,18h,18h,18h,70h,60h,60h,66h,6ch,78h,6ch,66h,00h
	db 38h,18h,18h,18h,18h,18h,3ch,00h,00h,00h,36h,7fh,6bh,6bh,63h,00h
	db 00h,00h,7ch,66h,66h,66h,66h,00h,00h,00h,3ch,66h,66h,66h,3ch,00h
	db 00h,00h,7ch,66h,66h,7ch,60h,60h,00h,00h,3eh,66h,66h,3eh,06h,07h
	db 00h,00h,6ch,76h,60h,60h,60h,00h,00h,00h,3eh,60h,3ch,06h,7ch,00h
	db 30h,30h,7ch,30h,30h,30h,1ch,00h,00h,00h,66h,66h,66h,66h,3eh,00h
	db 00h,00h,66h,66h,66h,3ch,18h,00h,00h,00h,63h,6bh,6bh,7fh,36h,00h
	db 00h,00h,66h,3ch,18h,3ch,66h,00h,00h,00h,66h,66h,66h,3eh,06h,3ch
	db 00h,00h,7eh,0ch,18h,30h,7eh,00h,0ch,18h,18h,70h,18h,18h,0ch,00h
	db 18h,18h,18h,00h,18h,18h,18h,00h,30h,18h,18h,0eh,18h,18h,30h,00h
	db	31h,6bh,46h,00h,00h,00h,00h,00h 
FontDataEnd:

OrcData:
	; Orc sprite adapted from http://opengameart.org/content/16x16-16x24-32x32-rpg-enemies-updated
	db 03h,04h,03h,00h,07h,09h,04h,03h,07h,3Bh,00h,07h,3Fh,51h,0Ch,33h,01h,3Eh,01h,04h,05h,19h,02h,01h,07h,39h,04h,03h,13h,35h,02h,09h
	db 28h,5Bh,20h,04h,20h,5Ah,00h,27h,66h,FEh,01h,61h,66h,BFh,01h,60h,00h,7Bh,00h,07h,08h,1Dh,08h,06h,1Ch,26h,00h,1Ch,00h,3Eh,00h,00h
	db C0h,20h,C0h,00h,E0h,10h,20h,C0h,E0h,9Ch,20h,C0h,FCh,02h,30h,CCh,80h,7Ch,80h,20h,A0h,18h,C0h,00h,E0h,18h,A0h,40h,C8h,2Ch,40h,90h
	db 14h,DAh,04h,20h,04h,5Ah,00h,E4h,66h,7Fh,80h,86h,66h,FDh,80h,06h,00h,DEh,00h,E0h,10h,B8h,10h,60h,38h,64h,00h,38h,00h,7Ch,00h,00h
	db 03h,04h,03h,00h,07h,09h,04h,03h,07h,3Bh,00h,07h,3Fh,51h,0Ch,33h,01h,3Eh,01h,04h,05h,19h,02h,01h,07h,39h,04h,03h,13h,35h,02h,09h
	db 28h,5Bh,20h,04h,30h,4Ah,10h,27h,36h,6Eh,01h,31h,36h,7Fh,01h,30h,35h,5Dh,04h,32h,06h,39h,06h,00h,00h,1Fh,00h,00h,00h,00h,00h,00h
	db C0h,20h,C0h,00h,E0h,10h,20h,C0h,E0h,9Ch,20h,C0h,FCh,02h,30h,CCh,80h,7Ch,80h,20h,A0h,18h,C0h,00h,E0h,1Ch,A0h,40h,C8h,2Ch,40h,90h
	db 14h,DAh,04h,20h,0Ch,52h,08h,E4h,6Ch,72h,88h,84h,60h,FCh,80h,00h,00h,D0h,00h,E0h,00h,50h,00h,E0h,F0h,68h,10h,E0h,00h,F8h,00h,00h
	db 03h,04h,03h,00h,07h,09h,04h,03h,07h,3Bh,00h,07h,3Fh,51h,0Ch,33h,01h,3Eh,01h,04h,05h,19h,02h,01h,07h,39h,04h,03h,13h,35h,02h,09h
	db 28h,5Bh,20h,04h,20h,5Ah,00h,27h,66h,FEh,01h,61h,66h,BFh,01h,60h,00h,7Bh,00h,07h,08h,1Dh,08h,06h,1Ch,26h,00h,1Ch,00h,3Eh,00h,00h
	db C0h,20h,C0h,00h,E0h,10h,20h,C0h,E0h,9Ch,20h,C0h,FCh,02h,30h,CCh,80h,7Ch,80h,20h,A0h,18h,C0h,00h,E0h,18h,A0h,40h,C8h,2Ch,40h,90h
	db 14h,DAh,04h,20h,04h,5Ah,00h,E4h,66h,7Fh,80h,86h,66h,FDh,80h,06h,00h,DEh,00h,E0h,10h,B8h,10h,60h,38h,64h,00h,38h,00h,7Ch,00h,00h
	db 03h,04h,03h,00h,07h,09h,04h,03h,07h,3Bh,00h,07h,3Fh,51h,0Ch,33h,01h,3Eh,01h,04h,05h,19h,02h,01h,07h,39h,04h,03h,13h,35h,02h,09h
	db 28h,5Bh,20h,04h,30h,4Ah,10h,27h,36h,4Eh,11h,21h,06h,3Fh,01h,00h,00h,0Bh,00h,07h,00h,0Ah,00h,07h,0Fh,16h,08h,07h,00h,1Fh,00h,00h
	db C0h,20h,C0h,00h,E0h,10h,20h,C0h,E0h,9Ch,20h,C0h,FCh,02h,30h,CCh,80h,7Ch,80h,20h,A0h,18h,C0h,00h,E0h,1Ch,A0h,40h,C8h,2Ch,40h,90h
	db 14h,DAh,04h,20h,0Ch,52h,08h,E4h,6Ch,76h,80h,8Ch,6Ch,FEh,80h,0Ch,ACh,BAh,20h,4Ch,60h,9Ch,60h,00h,00h,F8h,00h,00h,00h,00h,00h,00h
OrcDataEnd:

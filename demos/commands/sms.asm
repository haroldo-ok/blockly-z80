;==============================================================
; SMS defines
;==============================================================
VDPControl:	equ $bf
VDPData: 	equ $be
VRAMWrite:	equ $4000
CRAMWrite:	equ $c000	
RAMStart: 	equ $c000

;==============================================================
; RAM defines
;==============================================================
hw_sprites_y:		equ RAMStart + 0
hw_sprites_y_len:	equ 64
hw_sprites_xc:		equ hw_sprites_y + hw_sprites_y_len
hw_sprites_xc_len:	equ 128

hw_joypad_1:		equ hw_sprites_xc + hw_sprites_xc_len
hw_joypad_2:		equ hw_joypad_1 + 1

UsrRAMStart:		equ hw_joypad_2 + 1

;==============================================================
; Joypad constants
;==============================================================
Joypad_UP: 		equ 01h
Joypad_DOWN:	equ 02h
Joypad_LEFT:	equ 04h
Joypad_RIGHT:	equ 08h
Joypad_FIREA:	equ 10h
Joypad_FIREB:	equ 20h


	org 0000h
	
;==============================================================
; Boot section
;==============================================================
	di              ; disable interrupts
	im 1            ; Interrupt mode 1
	jp setup         ; jump to setup routine

	; org $0066 ; multiple orgs not supported by bitz80... please, don't press pause... ^_^

;==============================================================
; Setup
;==============================================================
setup:
	ld sp, $dff0

	;==============================================================
	; Set up VDP registers
	;==============================================================
	ld hl,VDPInitData
	ld b,VDPInitDataEnd-VDPInitData
	ld c,VDPControl
	otir

	;==============================================================
	; Clear VRAM
	;==============================================================
	; 1. Set VRAM write address to $0000
	ld hl,$0000 | VRAMWrite
	call SetVDPAddress
	; 2. Output 16KB of zeroes
	ld bc,$4000     ; Counter for 16KB of VRAM
ClearVRAM_Loop:  
	xor a
	out (VDPData),a ; Output to VRAM address, which is auto-incremented after each write
	dec bc
	ld a,b
	or c
	jr nz, ClearVRAM_Loop

	;==============================================================
	; Load palette
	;==============================================================
	; 1. Set VRAM write address to CRAM (palette) address 0
	ld hl,$0000 | CRAMWrite
	call SetVDPAddress
	; 2. Output colour data
	ld hl,PaletteData
	ld bc,PaletteDataEnd-PaletteData
	call CopyToVDP
	
	;==============================================================
	; Load tiles (font)
	;==============================================================
	; 1. Set VRAM write address to tile index 0
	ld hl,$0000 | VRAMWrite
	call SetVDPAddress
	; 2. Output tile data
	ld hl,FontData              ; Location of tile data
	ld bc,FontDataEnd-FontData  ; Counter for number of bytes to write
	call Copy1bppToVDP

	;==============================================================
	; Load orc tiles
	;==============================================================
	; 1. Set VRAM write address to tile index 256
	ld hl,$2000 | VRAMWrite
	call SetVDPAddress
	; 2. Output tile data
	ld hl,OrcData              ; Location of tile data
	ld bc,OrcDataEnd-OrcData  ; Counter for number of bytes to write
	call CopyToVDP

	;==============================================================
	; Turn screen on
	;==============================================================
	ld a,01000010b
;          ||||||`- Zoomed sprites -> 16x16 pixels
;          |||||`-- Doubled sprites -> 2 tiles per sprite, 8x16
;          ||||`--- Mega Drive mode 5 enable
;          |||`---- 30 row/240 line mode
;          ||`----- 28 row/224 line mode
;          |`------ VBlank interrupts
;          `------- Enable display
	out (VDPControl),a
	ld a,$81
	out (VDPControl),a

; Infinite loop to stop program
; Infinite_Loop :  jr Infinite_Loop

; Show a sprite
	; Left side
	ld a, 96
	ld (hw_sprites_y), a
	ld (hw_sprites_xc), a
	ld a, 0
	ld (hw_sprites_xc+1), a
	; Right side
	ld a, 96
	ld (hw_sprites_y+1), a
	ld a, 96 + 8
	ld (hw_sprites_xc+2), a
	ld a, 2
	ld (hw_sprites_xc+3), a
	; Sprite list terminator
	ld a, 208
	ld (hw_sprites_y+2), a
	call UpdateSprites
	

; call main program
	; Set VRAM write address to tilemap index 0
	ld hl,$3800 | VRAMWrite
	call SetVDPAddress

	jp MAIN
	
;==============================================================
; Helper functions
;==============================================================

SetVDPAddress:
; Sets the VDP address
; Parameters: hl = address
	push af
		ld a,l
		out (VDPControl),a
		ld a,h
		out (VDPControl),a
	pop af
	ret

	
CopyToVDP:
; Copies data to the VDP
; Parameters: hl = data address, bc = data length
; Affects: a, hl, bc
CopyToVDP_Loop:  
	ld a,(hl)    ; Get data byte
	out (VDPData),a
	inc hl       ; Point to next letter
	dec bc
	ld a,b
	or c
	jr nz, CopyToVDP_Loop
	ret

	
Copy1bppToVDP:
; Copies 1bpp char data to the VDP
; Parameters: hl = data address, bc = data length
; Affects: a, hl, bc
Copy1bppToVDP_Loop:  
	ld a,(hl)    ; Get data byte
	out (VDPData),a
	xor a		; pad the next 3 bytes
	out (VDPData),a
	out (VDPData),a
	out (VDPData),a
	inc hl       ; Point to next byte
	dec bc
	ld a,b
	or c
	jr nz, Copy1bppToVDP_Loop
	ret
		
;====================================
; Print text
;====================================
text_print:
	ld a,(hl)
	or a
	jr z, text_print_end
	sub 32
	out (VDPData),a
	xor a
	out (VDPData),a
	inc hl
	jr text_print
text_print_end:
	ret

;====================================
; Print number
;====================================
number_print:
	xor a
	push af		; a = 0 will be used as a terminator
	; initially, hl contains the number
number_print_digits:
	ex	de, hl	; Now, DE contains the number
	ld	hl, 10	; It will be divided by 10
	call Divide	; Now, DE contains the digit, and HL contains the part that hasn't been processed, yet.
	
	ld a, e
	add a, 48-32 ; Adds '0'
	push af		; Saves the digit for later (TODO: Should optimize this to use just one byte per digit)
	
	ld a, l
	or h
	jr z, number_print_digits_done
	jr number_print_digits	; There are still digits to print
number_print_digits_done:
	
number_print_output_loop:
	pop af
	or a
	jr z, number_print_output_loop_done		
	out (VDPData),a
	xor a
	out (VDPData),a
	jr number_print_output_loop
number_print_output_loop_done:
	ret

	
;==============================================================
; Move an sprite to a certain (x,y) position
; Done only in RAM; needs UpdateSprites to actually update.
; HL = Sprite number
; E  = Sprite X coordinate
; C  = Sprite Y coordinate
;==============================================================	
MoveSpriteXY:
	; X coordinate
	push hl		; Saves a copy of the sprite number	
	add hl, hl	; Each record is two bytes long
	ld a, e
	ld de, hw_sprites_xc
	add hl, de
	ld (hl), a
	
	; Y coordinate
	pop hl		; Restores the copy of the sprite number
	ld de, hw_sprites_y
	add hl, de
	ld (hl), c
	
	ret
	


;==============================================================
; Sets the tile number for a certain sprite
; Done only in RAM; needs UpdateSprites to actually update.
; HL = Sprite number
; E  = Tile number
;==============================================================	
SetSpriteTile:
	add hl, hl	; Each record is two bytes long
	ld a, e
	ld de, hw_sprites_xc + 1
	add hl, de
	ld (hl), a	
	ret
	


;==============================================================
; Sets the sprites' positions/attributes
;==============================================================	
UpdateSprites:
	;vdp set addr (Y table)
	xor	a
	out	($bf), a
	ld	a, $7f
	out	($bf), a
	
	; Outputs Y table
	ld	hl, hw_sprites_y
	ld	bc, $40BE	; 64 bytes to $be
	otir			; Output table

	;vdp set addr (X/Tile table)
	ld	a, $80
	out	($bf), a
	ld	a, $7f
	out	($bf), a
	
	; Outputs XA table
	ld	hl, hw_sprites_xc
	ld	bc, $80BE	; 128 bytes to $be
	otir			; Output table
	ret


;==============================================================
; V Counter reader
; Waits for 2 consecutive identical values (to avoid garbage)
; Returns in a *and* b
;==============================================================
GetVCount:
    in a,($7e)  ; get VCount
GetVCount_loop:	
    ld b,a      ; store it
    in a,($7e)  ; and again
    cp b        ; Is it the same?
    jp nz,GetVCount_loop ; If not, repeat
    ret         ; If so, return it in a (and b)

;==============================================================
; Waits for vblank
;==============================================================
WaitForVBlank:
    push bc
    push af
WaitForVBlank_loop:
        call GetVCount
        cp 192
        jp nz,WaitForVBlank_loop
    pop af
    pop bc
    ret

;==============================================================
; Reads both joypads
;==============================================================
ReadJoypads:
    ; Joypad reading
    in a, ($DD)
    ld h, a
    in a, ($DC)
    ld l, a

    ; Joypad 1
    cpl
    and $7F
    ld (hw_joypad_1), a
    
    ; Joypad 2
    add hl, hl
    add hl, hl		; Shifts top two bits from l (U/D Joypad 2) to h.
    ld a, h
    cpl
    and $7F
    ld (hw_joypad_2), a

	ret

	
;==============================================================
; Reads joypad 2 (assumes ReadJoypads has been called)
; ANDs hw_joypad_1 and C; 
; If the result is nonzero, HL = 1, else HL = 0
;==============================================================
ReadJoypad1:
	ld a, (hw_joypad_1)
Joypad_check:	; Shared by 
	and c
	jr z, Joypad_false
	ld hl, 1
	ret
Joypad_false:
	ld hl, 0
	ret

	
;==============================================================
; Reads joypad 2 (assumes ReadJoypads has been called)
; ANDs hw_joypad_2 and C; 
; If the result is nonzero, HL = 1, else HL = 0
;==============================================================
ReadJoypad2:
	ld a, (hw_joypad_2)
	jr Joypad_check

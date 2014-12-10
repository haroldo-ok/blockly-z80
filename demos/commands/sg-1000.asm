;==============================================================
; Hacked from the SMS version, plus some snippets from Wickeycolumbus' Snake.
; Many constants and memory addresses are still using SMS values.
; Cleanup is still pending.
;==============================================================

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

UsrRAMStart:		equ hw_sprites_xc + hw_sprites_xc_len

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
	;;Initialize VDP
	;;
	;;VDP Memory Map:
	;;
	;;Color Table		R3 00	$0000-$003F
	;;Sprite Attribute	R5 01	$0080-$00FF
	;;Pattern Generator	R4 01	$0800-$0FFF	;reserve 2K
	;;Sprite Pattern	R6 04	$2000-$27FF
	;;Name Table		R2 0F	$3C00-$3FFF	(1K) reserve 768b
	ld hl,VDPInitDataSG1000
	ld b,VDPInitDataSG1000End-VDPInitDataSG1000
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
	; 1. Set VRAM write address to tile index $800
	ld hl,$0800 | VRAMWrite
	call SetVDPAddress
	; 2. Output tile data
	ld hl,FontData              ; Location of tile data
	ld bc,FontDataEnd-FontData  ; Counter for number of bytes to write
	call Copy1bppToVDP
	
	; Set up color tables
	ld hl,$4000
	call SetVDPAddress
	
	ld c, $40;
ColorTableLoop:
	ld a,$a6	;8c c6
	out (VDPData),a
	dec c
	ld a, c
	or a
	jr nz,ColorTableLoop
	

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
	

; call main program
	; Set VRAM write address to tilemap index 0
	ld hl,$3C00 | VRAMWrite
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
	jr number_print_output_loop
number_print_output_loop_done:
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

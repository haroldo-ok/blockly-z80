; COLECOVISION - HELLO WORLD!
; By Daniel Bienvenu, 2010
; To be compiled with TNIASM

; BIOS (SOME) ENTRY POINTS
CALC_OFFSET: equ $08c0
LOAD_ASCII: equ $1f7f
FILL_VRAM: equ $1f82
MODE_1: equ $1f85
PUT_VRAM: equ $1fbe
TURN_OFF_SOUND: equ $1fd6
WRITE_REGISTER: equ $1fd9
READ_REGISTER: equ $1fdc
WRITE_VRAM: equ $1fdf

; VRAM DEFAULT TABLES
VRAM_PATTERN: equ $0000
VRAM_NAME: equ $1800
VRAM_SPRATTR: equ $1B00
VRAM_COLOR: equ $2000
VRAM_SPRGEN: equ $3800
    
    org $8000
    
    ; HEADER
    db $aa,$55 ; use $55,$aa to avoid the default CV title screen
    dw 0,0,0,0
    dw Start
rst_8:
    reti
    nop
rst_10:
    reti
    nop
rst_18:
    reti
    nop
rst_20:
    reti
    nop
rst_28:
    reti
    nop
rst_30:
    reti
    nop
rst_38:
    reti
    nop
    jp Nmi
    
    db "HELLO WORLD!/PRINT ON SCREEN/2010"

    ; PROGRAM
Start:
    im 1
    
    ; CLEAR VIDEO MEMORY
    ld  hl,$0000
    ld  de,$4000
    xor a
    call FILL_VRAM
    
    ; INIT DEFAULT SCREEN GRAPHIC MODE 1
    call MODE_1

    ; NO SOUND
    call TURN_OFF_SOUND

    ; DEFAULT FONT TO VIDEO MEMORY
    call LOAD_ASCII
    
    ; COLOR WHITE ON BLACK BACKGROUND
    ld  hl,VRAM_COLOR ; COLOR TABLE
    ld  de,32
    ld  a,$f0 ; WHITE ON BLACK
    call FILL_VRAM

    ; PRINT "HELLO WORLD!" CENTERED AT THE TOP OF THE SCREEN
    ; FORMULA = (32 CHARS PER LINE - 12 CHARS TO OUTPUT) / 2 = 10    
    call Static_Offset ; or use Calculated_Offset
    call Write_HelloWorld ; or use Put_HelloWorld but make sure to not add VRAM NAME TABLE with the Offset
    
    ; 16KB VIDEO MEMORY, 16x16 NORMAL SPRITES, AND TURN ON SCREEN
    ld  bc,$01c2 ; $01e2 ; = AND ENABLE NMI EXECUTION
    call WRITE_REGISTER
    
TheEnd:
    jp  TheEnd
    
HelloWorld:
    db "HELLO WORLD!"

Static_Offset:
    ld  de,VRAM_NAME+10 ; VRAM NAME TABLE + OFFSET
    ret 

Calculated_Offset:
    ld  d,0 ; LINE = 0
    ld  e,10 ; COLUMN = 10
    call CALC_OFFSET ; OFFSET = 32 * D + E
    ld  hl,VRAM_NAME
    add hl,de
    ex  de,hl
    ret
    
Write_HelloWorld:
    ld  hl,HelloWorld
    ld  bc,12 ; COUNT
    jp WRITE_VRAM

Put_HelloWorld:
    ld  a,2 ; ID#2 = VRAM NAME TABLE
    ld  hl,HelloWorld
    ld  iy,12 ; COUNT
    jp PUT_VRAM

Nmi:
    ; RANDOM COLOR ON BLACK BACKGROUND
    ld  hl,VRAM_COLOR ; COLOR TABLE
    ld  de,32
    ld  a,r ; REFRESH MEMORY STATE USED AS A RANDOM VALUE
    and $f0 ; BLACK BACKGROUND
    call FILL_VRAM

    ; ABSOLUTELY NEEDED
    call READ_REGISTER
    retn